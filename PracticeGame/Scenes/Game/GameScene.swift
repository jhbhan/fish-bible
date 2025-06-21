//
//  GameScene.swift
//  PracticeGame
//
//  Created by Jason Bhan on 6/8/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    private var fish : SKSpriteNode?
    private var wordSpawner : WordSpawner!
    private var parallaxBackground: ParallaxBackground!
    private var hud: GameHUD!
    private var gameManager: GameManager!

    private var fishMaxSpeed: CGFloat = 100.00
    private var minFishMoveDuration: CGFloat = 0.3
    private var fishDetectionBuffer: CGFloat = 50.0 // optional padding
    
    private var pauseMenu: PauseMenu?
    private let pauseButtonMargin: CGFloat = 40
    
    override func didMove(to view: SKView) {
        parallaxBackground = ParallaxBackground(scene: self)
        gameManager = GameManager(stockVerses)
        
        let fishTexture = SKTexture(imageNamed: "guppy")
        let fishNode = SKSpriteNode(texture: fishTexture)
        fishNode.name = "fish"
        fishNode.zPosition = 1
        fishNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(fishNode)
        fish = fishNode
        
        let pauseButton = SKLabelNode(text: "⏸")
        pauseButton.name = "pauseButton"
        pauseButton.fontName = "Fredoka-Bold"
        pauseButton.fontSize = 36
        pauseButton.fontColor = .white
        pauseButton.position = CGPoint(x: size.width - pauseButtonMargin, y: size.height - pauseButtonMargin)
        pauseButton.zPosition = 1000
        addChild(pauseButton)

        hud = GameHUD(size: size, verseReference: gameManager.getCurrentVerseReference())
        addChild(hud)
        
        wordSpawner = WordSpawner(scene: self, wordSupplier: { [weak self] in
            self?.gameManager.getTargetWordList() ?? []
        })
        
        wordSpawner.startSpawning(every: 1.0)
    }
    
    private func checkIntersection() {
        guard let fish = fish else { return }
        let fishFrame = CGRect(
            origin: CGPoint(x: fish.position.x - fish.size.width / 2,
                            y: fish.position.y - fish.size.height / 2),
            size: fish.size
        )

        // Broad phase: early reject far-away words
        let nearbyWords = wordSpawner.activeWords.filter { node in
            let dx = node.position.x - fish.position.x
            let dy = node.position.y - fish.position.y
            return abs(dx) < fishFrame.width + fishDetectionBuffer &&
            abs(dy) < fishFrame.height + fishDetectionBuffer
        }

        // Narrow phase: precise collision
        for node in nearbyWords {
            if node.parent != nil && node.frame.intersects(fishFrame) {
                node.removeFromParent()
                                
                let wordText = node.name ?? ""

                let correct = gameManager.handleCollected(word: wordText)
                if correct {
                    hud.update(
                        score: gameManager.score,
                        combo: gameManager.combo,
                        newWord: wordText
                    )
                    // if currentWordIndex is zero at time time, then new verse is made
                    if gameManager.currentWordIndex == 0 {
                        hud.updateVerseRef(verseRef: gameManager.getCurrentVerseReference())
                        hud.emptyWordList()
                        wordSpawner.resetWords()
                    }
                } else {
                    hud.update(
                        score: gameManager.score,
                        combo: gameManager.combo
                    )
                    if let fish = self.fish {
                        let moveLeft = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
                        let moveRight = SKAction.moveBy(x: 20, y: 0, duration: 0.1)
                        let moveBack = SKAction.moveBy(x: -10, y: 0, duration: 0.05)
                        let shake = SKAction.sequence([moveLeft, moveRight, moveBack])
                        
                        // Tint to red then fade back to normal
                        let tintRed = SKAction.colorize(with: .red, colorBlendFactor: 0.7, duration: 0.1)
                        let clearTint = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)
                        let tintSequence = SKAction.sequence([tintRed, clearTint])
                        
                        // Group both actions
                        let group = SKAction.group([shake, tintSequence])
                        fish.run(group)
                    }
                }
            }
        }

        // Cleanup: only once per frame
        wordSpawner.cleanUpInactiveWords()
    }
    
    private func showPauseMenu() {
        isPaused = true

        let menu = PauseMenu(size: size)
        menu.onResume = { [weak self] in
            self?.pauseMenu?.removeFromParent()
            self?.pauseMenu = nil
            self?.isPaused = false
        }
        menu.onRestart = { [weak self] in
            guard let self = self, let view = view else { return }
            gameManager.resetGame()
            let newScene = GameScene(size: size)
            newScene.scaleMode = scaleMode
            view.presentScene(newScene, transition: .fade(withDuration: 0.5))
        }
        menu.onMainMenu = { [weak self] in
            guard let self = self, let view = view else { return }
            gameManager.resetGame()
            let mainMenu = StartMenuScene(size: size)
            mainMenu.scaleMode = scaleMode
            view.presentScene(mainMenu, transition: .fade(withDuration: 0.5))
        }

        addChild(menu)
        pauseMenu = menu
    }
    
    func touchDown(atPoint pos: CGPoint) {
        guard let fish = self.fish else { return }
        
        let duration = min(getDistance(from: fish.position, to: pos) / self.fishMaxSpeed, minFishMoveDuration)
        let moveAction = SKAction.move(to: pos, duration: duration)
        fish.run(moveAction)
    }
    
    func touchMoved(toPoint pos: CGPoint) {
        guard let fish = fish else { return }
        fish.position = pos
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
            let location = touch.location(in: self)

            // If pause menu is open, let it handle the touch
            if let pauseMenu = pauseMenu {
                pauseMenu.handleTouch(at: location)
                return
            }

            let touchedNode = atPoint(location)
            if touchedNode.name == "pauseButton" {
                showPauseMenu()
                return
            }

            touchDown(atPoint: location)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        parallaxBackground.update()
        checkIntersection()
    }
}
