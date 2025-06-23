import SpriteKit

class SettingScene: SKScene {
    private var parallaxBackground: ParallaxBackground!
    override func didMove(to view: SKView) {
        parallaxBackground = ParallaxBackground(scene: self)
        
        let background = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.width * 0.8), cornerRadius: 12)
        background.fillColor = .white
        background.strokeColor = .black
        
        addChild(background)
    }
}
