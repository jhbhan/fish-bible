import SpriteKit

class SettingScene: SKScene {
    private var parallaxBackground: ParallaxBackground!
    override func didMove(to view: SKView) {
        parallaxBackground = ParallaxBackground(scene: self)
        
        let background = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.width * 1.5), cornerRadius: 12)
        background.fillColor = .white
        background.strokeColor = .black
        background.lineWidth = 4
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        addChild(background)
    }
    
    override func update(_ currentTime: TimeInterval) {
        parallaxBackground.update()
    }
}
