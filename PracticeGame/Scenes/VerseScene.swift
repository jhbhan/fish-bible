import SpriteKit

class VerseScene: SKScene {
    private var parallaxBackground: ParallaxBackground!
    override func didMove(to view: SKView) {
        parallaxBackground = ParallaxBackground(scene: self)
    }
}
