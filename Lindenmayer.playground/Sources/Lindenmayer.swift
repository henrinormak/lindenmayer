
import Foundation

public enum LindenmayerDirection: Equatable {
    case Right
    case Left
}

public enum LindenmayerRule: Equatable, Printable {
    case Move
    case Draw
    case Turn(LindenmayerDirection, Double)
    case StoreState
    case RestoreState
    case Ignore
    
    public var description: String {
        switch self {
            case Move:
                return "Move"
            case Draw:
                return "Draw"
            case Turn(.Right, let angle):
                return "Turn right by \(angle)°"
            case Turn(.Left, let angle):
                return "Turn left by \(angle)°"
            case StoreState:
                return "["
            case RestoreState:
                return "]"
            case Ignore:
                return ""
        }
    }
}

public func ==(a: LindenmayerDirection, b: LindenmayerDirection) -> Bool {
    switch (a, b) {
    case (.Right, .Right), (.Left, .Left):
        return true
    default:
        return false
    }
}

public func ==(a: LindenmayerRule, b: LindenmayerRule) -> Bool {
    switch (a, b) {
        case (.Move, .Move), (.Draw, .Draw), (.Ignore, .Ignore), (.StoreState, .StoreState), (.RestoreState, .RestoreState):
            return true
        case (.Turn(let ad, let aa), .Turn(let bd, let ba)) where ad == bd && aa == ba:
            return true
        default:
            return false
    }
}


public struct Lindenmayer {
    var start: String
    var rules: [String: String]
    var variables: [String: LindenmayerRule]
    
    public init(start: String, rules: [String: String], variables: [String: LindenmayerRule]) {
        self.start = start
        self.rules = rules
        self.variables = variables
        
        // Add the two default state storing values
        if self.variables["["] == nil {
            self.variables["["] = .StoreState
        }
        
        if self.variables["]"] == nil {
            self.variables["]"] = .RestoreState
        }
    }
    
    ///
    ///  Main Lindenmayer evolution, expands the start
    ///  string by given number of generations
    ///
    ///  :param:    generations - Number of expansions to make
    ///  :returns:  Expanded state
    ///
    public func expandedString(generations: Int) -> String {
        return self.evolve(generations, state: self.start)
    }
    
    ///
    ///  Expand the state given number of generations
    ///  and return the produced rules
    ///
    ///  :param:    state - A state to convert
    ///  :returns:  A list of rules that correspond to the state
    ///
    public func expand(generations: Int) -> [LindenmayerRule] {
        let state = self.evolve(generations, state: self.start)
        
        var result = [LindenmayerRule]()
        for character in state {
            if let rule = self.variables[String(character)] where rule != .Ignore {
                result.append(rule)
            }
        }
        
        return result
    }
    
    private func evolve(generations: Int, state: String) -> String {
        // End condition for recursion
        if (generations < 1) {
            return state
        }
        
        // Expand each variable with its corresponding rule (or itself)
        var result: String = ""
        for character in state {
            if let rule = rules[String(character)] {
                result += rule
            } else {
                result += String(character)
            }
        }
        
        return self.evolve(generations - 1, state: result)
    }
}
