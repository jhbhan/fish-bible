import SpriteKit

class MenuHUD: BaseMenuHUD {
    override init(size: CGSize) {
        super.init(size: size)

        let menuLabel = SKLabelNode(text: "Settings")
        menuLabel.fontName = "Fredoka-Bold"
        menuLabel.fontSize = 24
        menuLabel.fontColor = .black
        menuLabel.position = CGPoint(x: 0, y: 100) // Relative to background center

        
        let changeSpriteButton = SKLabelNode(text: "Change Sprite")
        changeSpriteButton.name = "changeSpriteButton"
        changeSpriteButton.fontName = "Fredoka-Bold"
        changeSpriteButton.fontSize = 18
        changeSpriteButton.fontColor = .black
        changeSpriteButton.position = CGPoint(x: 0, y: -50) // Relative to background center
        
        let closeButton = SKLabelNode(text: "Close")
        closeButton.name = "closeButton"
        closeButton.fontName = "Fredoka-Bold"
        closeButton.fontSize = 18
        closeButton.fontColor = .red
        closeButton.position = CGPoint(x: 0, y: -100) // Relative to background center

        let settingsMenu = SKNode()
        settingsMenu.addChild(menuLabel)
        settingsMenu.addChild(closeButton)
        settingsMenu.addChild(changeSpriteButton)

        // Add to background
        background.addChild(settingsMenu)
        
        addChild(background)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
