import UIKit

public class LindenmayerView: UIView {
    public var rules: [LindenmayerRule] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var unitLength: Double = 10 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var initialState: State = State(0, CGPoint(x: 0, y: 0)) {        
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var strokeColor: UIColor = UIColor.blackColor() {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    public var strokeWidth: CGFloat = 2 {
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
        
        self.backgroundColor = UIColor.whiteColor()
        self.opaque = true
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        if let color = self.backgroundColor {
            CGContextSetFillColorWithColor(ctx, color.CGColor)
            CGContextFillRect(ctx, rect)
        }
        
        if self.rules.count == 0 {
            return
        }
        
        // Go over the rules and draw out the path
        let path = CGPathCreateMutable()
        CGPathMoveToPoint(path, nil, 0, 0)
        
        var state = [State]()
        var currentState = self.initialState
        
        for rule in self.rules {
            switch rule {
            case .StoreState:
                state.append(currentState)
            case .RestoreState:
                currentState = state.removeLast()
                CGPathMoveToPoint(path, nil, currentState.position.x, currentState.position.y)
            case .Move:
                currentState = self.calculateState(currentState, distance: self.unitLength)
                CGPathMoveToPoint(path, nil, currentState.position.x, currentState.position.y)
            case .Draw:
                currentState = self.calculateState(currentState, distance: self.unitLength)
                CGPathAddLineToPoint(path, nil, currentState.position.x, currentState.position.y)
            case .Turn(let direction, let angle):
                currentState = self.calculateState(currentState, angle: angle, direction: direction)
            case .Ignore:
                break
            }
        }
        
        // Fit the path into our bounds
        var pathRect = CGPathGetBoundingBox(path)
        var bounds = CGRectInset(self.bounds, CGFloat(self.unitLength), CGFloat(self.unitLength))
        
        // First make sure the path is aligned with our origin
        var transform = CGAffineTransformMakeTranslation(-CGRectGetMinX(pathRect), -CGRectGetMinY(pathRect))
        var finalPath = CGPathCreateCopyByTransformingPath(path, &transform)
        
        // Next, scale the path to fit snuggly in our path
        pathRect = CGPathGetPathBoundingBox(finalPath)
        let scale = min(CGRectGetWidth(bounds) / CGRectGetWidth(pathRect), CGRectGetHeight(bounds) / CGRectGetHeight(pathRect))
        transform = CGAffineTransformMakeScale(scale, scale)
        finalPath = CGPathCreateCopyByTransformingPath(finalPath, &transform)
        
        // Finally, move the path to the correct origin
        transform = CGAffineTransformMakeTranslation(CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        finalPath = CGPathCreateCopyByTransformingPath(finalPath, &transform)
        
        CGContextAddPath(ctx, finalPath)
        
        CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor)
        CGContextSetLineWidth(ctx, self.strokeWidth)
        CGContextStrokePath(ctx)
    }
    
    private func degreesToRadians(value:Double) -> Double {
        return value * M_PI / 180.0
    }
    
    private func calculateState(state: State, distance: Double) -> State {
        let x = state.position.x + CGFloat(distance * cos(self.degreesToRadians(state.angle)))
        let y = state.position.y + CGFloat(distance * sin(self.degreesToRadians(state.angle)))
        
        return State(state.angle, CGPoint(x: x, y: y))
    }
    
    private func calculateState(state: State, angle: Double, direction: LindenmayerDirection) -> State {
        if direction == .Left {
            return State(state.angle - angle, state.position)
        }
        
        return State(state.angle + angle, state.position)
    }
}
