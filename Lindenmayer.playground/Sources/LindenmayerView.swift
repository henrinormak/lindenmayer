import UIKit

open class LindenmayerView: UIView {
    open var rules: [LindenmayerRule] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var unitLength: Double = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var initialState: State = State(0, CGPoint(x: 0, y: 0)) {        
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var strokeColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    open var strokeWidth: CGFloat = 2 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public struct State {
        var angle: Double
        var position: CGPoint
        
        public init(_ angle: Double, _ position: CGPoint) {
            self.angle = angle
            self.position = position
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.isOpaque = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        if let color = self.backgroundColor {
            ctx?.setFillColor(color.cgColor)
            ctx?.fill(rect)
        }
        
        if self.rules.count == 0 {
            return
        }
        
        // Go over the rules and draw out the path
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        var state = [State]()
        var currentState = self.initialState
        
        for rule in self.rules {
            switch rule {
            case .storeState:
                state.append(currentState)
            case .restoreState:
                currentState = state.removeLast()
                path.move(to: currentState.position)
            case .move:
                currentState = self.calculateState(currentState, distance: self.unitLength)
                path.move(to: currentState.position)
            case .draw:
                currentState = self.calculateState(currentState, distance: self.unitLength)
                path.addLine(to: currentState.position)
            case .turn(let direction, let angle):
                currentState = self.calculateState(currentState, angle: angle, direction: direction)
            case .ignore:
                break
            }
        }
        
        // Fit the path into our bounds
        var pathRect = path.boundingBox
        let bounds = self.bounds.insetBy(dx: CGFloat(self.unitLength), dy: CGFloat(self.unitLength))
        
        // First make sure the path is aligned with our origin
        var transform = CGAffineTransform(translationX: -pathRect.minX, y: -pathRect.minY)
        var finalPath = path.copy(using: &transform)
        
        // Next, scale the path to fit snuggly in our path
        pathRect = (finalPath?.boundingBoxOfPath)!
        let scale = min(bounds.width / pathRect.width, bounds.height / pathRect.height)
        transform = CGAffineTransform(scaleX: scale, y: scale)
        finalPath = finalPath?.copy(using: &transform)
        
        // Finally, move the path to the correct origin
        transform = CGAffineTransform(translationX: bounds.minX, y: bounds.minY)
        finalPath = finalPath?.copy(using: &transform)
        
        ctx?.addPath(finalPath!)
        
        ctx?.setStrokeColor(self.strokeColor.cgColor)
        ctx?.setLineWidth(self.strokeWidth)
        ctx?.strokePath()
    }
    
    fileprivate func degreesToRadians(_ value:Double) -> Double {
        return value * M_PI / 180.0
    }
    
    fileprivate func calculateState(_ state: State, distance: Double) -> State {
        let x = state.position.x + CGFloat(distance * cos(self.degreesToRadians(state.angle)))
        let y = state.position.y + CGFloat(distance * sin(self.degreesToRadians(state.angle)))
        
        return State(state.angle, CGPoint(x: x, y: y))
    }
    
    fileprivate func calculateState(_ state: State, angle: Double, direction: LindenmayerDirection) -> State {
        if direction == .left {
            return State(state.angle - angle, state.position)
        }
        
        return State(state.angle + angle, state.position)
    }
}
