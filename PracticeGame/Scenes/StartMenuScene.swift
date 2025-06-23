import SpriteKit

class StartMenuScene: SKScene {
    private var parallaxBackground: ParallaxBackground!
    
    private func MakeButton(_ text: String, _ buttonName: String, _ position: CGPoint){
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
        
        addChild(label)
        addChild(background)
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

        MakeButton("Start Game", "startButton", CGPoint(x: size.width / 2, y: size.height * 0.4))
        MakeButton("Settings", "settingButton", CGPoint(x: size.width / 2, y: size.height * 0.3))
        MakeButton("My Verses", "versesButton", CGPoint(x: size.width / 2, y: size.height * 0.2))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        switch tappedNode.name {
        case "startButton":
            showScene(GameScene(size: size))
        case "settingButton":
            showScene(SettingScene(size: size))
        case "versesButton":
            showScene(VerseScene(size: size))
        default:
            return
        }
    }
    
    private func showScene(_ scene: SKScene) {
        scene.scaleMode = .resizeFill
        let transition = SKTransition.fade(withDuration: 1.0)
        view?.presentScene(scene, transition: transition)
    }
    
    override func update(_ currentTime: TimeInterval) {
        parallaxBackground.update()
    }
}
