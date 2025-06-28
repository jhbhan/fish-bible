import SpriteKit

class StartMenuScene: BaseScene {
    private var titleLabel: SKLabelNode!
    private var buttons: [(label: SKLabelNode, background: SKShapeNode)] = []
    private var didFinishLoading: Bool = false

    private func makeButton(_ text: String, _ buttonName: String, _ yRatio: CGFloat) {
        let label = SKLabelNode(text: text)
        label.name = buttonName
        label.fontName = "Fredoka-Regular"
        label.fontColor = .black
        label.verticalAlignmentMode = .center
        addChild(label)

        let background = SKShapeNode()
        background.fillColor = .white
        background.strokeColor = .black
        background.lineWidth = 4
        background.name = buttonName
        addChild(background)

        buttons.append((label, background))

        // Initial position/sizing handled in layout()
        didFinishLoading = true
    }

    private func layoutUI() {
        // Title
        titleLabel.fontSize = size.height * 0.06
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.7)

        // Buttons
        let buttonWidth = size.width * 0.6
        let buttonHeight = size.height * 0.08
        let fontSize = size.height * 0.035

        let yRatios: [CGFloat] = [0.4, 0.3, 0.2]
        for (index, (label, background)) in buttons.enumerated() {
            let y = size.height * yRatios[index]
            let position = CGPoint(x: size.width / 2, y: y)

            label.fontSize = fontSize
            label.position = position

            background.path = CGPath(rect: CGRect(x: -buttonWidth/2, y: -buttonHeight/2, width: buttonWidth, height: buttonHeight), transform: nil)
            background.position = position
        }
    }

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        // Title Label
        titleLabel = SKLabelNode(text: "Fish Word Game")
        titleLabel.fontName = "Fredoka-Bold"
        titleLabel.fontColor = .white
        addChild(titleLabel)

        makeButton("Start Game", "startButton", 0.4)
        makeButton("Settings", "settingButton", 0.3)
        makeButton("My Verses", "versesButton", 0.2)

        layoutUI()
    }

    override func didChangeSize(_ oldSize: CGSize) {
        if (didFinishLoading) {
            super.didChangeSize(oldSize)
            layoutUI()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNode = atPoint(location)

        switch tappedNode.name {
        case "startButton":
            showScene(view, GameScene(size: size))
        case "settingButton":
            showScene(view, SettingScene(size: size))
        case "versesButton":
            showScene(view, VerseScene(size: size))
        default:
            return
        }
    }
}
