import SpriteKit

class SettingScene: BaseScene {
    private var didFinishLoading: Bool = false
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let background = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.height * 0.8), cornerRadius: 12)
        background.fillColor = .white
        background.strokeColor = .black
        background.lineWidth = 4
        background.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        
        let menuLabel = SKLabelNode(text: "Settings")
        menuLabel.fontName = "Fredoka-Bold"
        menuLabel.fontSize = 24
        menuLabel.fontColor = .black
        menuLabel.position = CGPoint(x: 0, y: 100) // Relative to background center

        let closeButton = SKLabelNode(text: "Close")
        closeButton.name = "closeButton"
        closeButton.fontName = "Fredoka-Bold"
        closeButton.fontSize = 18
        closeButton.fontColor = .red
        closeButton.position = CGPoint(x: 0, y: -100) // Relative to background center

        let settingsMenu = SKNode()
        settingsMenu.addChild(menuLabel)
        settingsMenu.addChild(closeButton)

        // Add to background
        background.addChild(settingsMenu)
        
        addChild(background)
        
        didFinishLoading = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        switch tappedNode.name {
        case "closeButton":
            showScene(view, StartMenuScene(size: size))
        default:
            return
        }
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        if (didFinishLoading) {
            super.didChangeSize(oldSize)
        }
    }
}
