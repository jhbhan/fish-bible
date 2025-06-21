import SpriteKit

class PauseMenu: SKNode {

    var onResume: (() -> Void)?
    var onRestart: (() -> Void)?
    var onMainMenu: (() -> Void)?

    private let background: SKShapeNode

    init(size: CGSize) {
        background = SKShapeNode(rectOf: CGSize(width: size.width * 0.8, height: size.height * 0.5), cornerRadius: 16)
        super.init()

        self.name = "pauseMenu"
        self.zPosition = 2000

        background.fillColor = .black.withAlphaComponent(0.8)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(background)

        let buttonDefs = [
            ("resumeButton", "▶ Resume"),
            ("restartButton", "🔁 Restart"),
            ("mainMenuButton", "🏠 Main Menu")
        ]

        for (index, (name, label)) in buttonDefs.enumerated() {
            let btn = SKLabelNode(text: label)
            btn.name = name
            btn.fontName = "Fredoka-Bold"
            btn.fontSize = 28
            btn.fontColor = .white
            btn.position = CGPoint(x: 0, y: CGFloat(60 - index * 60))
            background.addChild(btn)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func handleTouch(at location: CGPoint) {
        let nodes = self.nodes(at: convert(location, from: self.scene!))

        for node in nodes {
            switch node.name {
            case "resumeButton": onResume?()
            case "restartButton": onRestart?()
            case "mainMenuButton": onMainMenu?()
            default: break
            }
        }
    }
}
