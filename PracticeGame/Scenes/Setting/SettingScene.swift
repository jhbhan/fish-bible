import SpriteKit

class SettingScene: BaseScene {
    private var didFinishLoading: Bool = false
    private var currentHud: BaseMenuHUD?
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        let menuHud = MenuHUD(size: size)
        currentHud = menuHud
        
        addChild(menuHud)
        
        didFinishLoading = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        switch tappedNode.name {
        case "closeButton":
            showScene(view, StartMenuScene(size: size))
        case "backButton":
            if let oldHud = currentHud {
                oldHud.hide()
                let menuHud = MenuHUD(size: size)
                addChild(menuHud)
                currentHud = menuHud
            }
        case "changeSpriteButton":
            if let oldHud = currentHud {
                oldHud.hide()
                let changeSpriteHUD = ChangeSpriteHUD(size: size)
                addChild(changeSpriteHUD)
                currentHud = changeSpriteHUD
            }
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
