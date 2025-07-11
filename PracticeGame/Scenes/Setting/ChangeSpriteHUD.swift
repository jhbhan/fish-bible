import SpriteKit

class ChangeSpriteHUD: BaseMenuHUD {
    override init(size: CGSize) {
        super.init(size: size)

        let menuLabel = SKLabelNode(text: "Change Sprite")
        menuLabel.fontName = "Fredoka-Bold"
        menuLabel.fontSize = 24
        menuLabel.fontColor = .black
        menuLabel.position = CGPoint(x: 0, y: 100) // Relative to background center

        let closeButton = SKLabelNode(text: "Back")
        closeButton.name = "backButton"
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
