import SpriteKit

class BaseScene: SKScene {
    private var parallaxBackground: ParallaxBackground!
    private var didFinishLoading: Bool = false

    override func didMove(to view: SKView) {
        parallaxBackground = ParallaxBackground(scene: self)
        didFinishLoading = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(didFinishLoading) {
            parallaxBackground.update()
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        if(didFinishLoading) {
            parallaxBackground.resize()
        }
    }
}
