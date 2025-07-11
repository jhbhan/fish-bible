import SpriteKit

class BaseMenuHUD: SKNode {    
    public let background: SKShapeNode
    
    init (size: CGSize) {
        background = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.height * 0.8), cornerRadius: 12)
        background.fillColor = .white
        background.strokeColor = .black
        background.lineWidth = 4
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hide() {
        removeFromParent()
    }
}
