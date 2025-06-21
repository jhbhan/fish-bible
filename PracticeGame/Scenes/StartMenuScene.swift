import SpriteKit

class StartMenuScene: SKScene {
    private var parallaxBackground: ParallaxBackground!
    
    private func MakeButton(_ text: String, _ buttonName: String, _ position: CGPoint) -> (label: SKLabelNode, background: SKShapeNode) {
        // Start Button
        let label = SKLabelNode(text: text)
        label.name = buttonName
        label.fontName = "Fredoka-Regular"
        label.fontSize = 36
        label.fontColor = .black
        label.position = position
        label.verticalAlignmentMode = .center


        // Button background
        let background = SKShapeNode(rectOf: CGSize(width: 220, height: 60), cornerRadius: 12)
        background.fillColor = .white
        background.strokeColor = .black
        background.lineWidth = 4
        background.name = buttonName // delegate touches to this node too
        background.position = label.position
        
        return (label, background)
    }
    
    override func didMove(to view: SKView) {
        parallaxBackground = ParallaxBackground(scene: self)

        backgroundColor = .cyan

        // Title Label
        let titleLabel = SKLabelNode(text: "Fish Word Game")
        titleLabel.fontName = "Fredoka-Bold"
        titleLabel.fontSize = 48
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)
        addChild(titleLabel)

        let (startButton, startBackground) = MakeButton("Start Game", "startButton", CGPoint(x: size.width / 2, y: size.height * 0.4))
        
        addChild(startBackground)
        addChild(startButton)
        
        let (settingButton, settingBackground) = MakeButton("settings", "settingButton", CGPoint(x: size.width / 2, y: size.height * 0.2))
        
        addChild(settingBackground)
        addChild(settingButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        if tappedNode.name == "startButton" {
            let gameScene = GameScene(size: size)
            gameScene.scaleMode = .resizeFill
            let transition = SKTransition.fade(withDuration: 1.0)
            view?.presentScene(gameScene, transition: transition)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        parallaxBackground.update()
    }
}
