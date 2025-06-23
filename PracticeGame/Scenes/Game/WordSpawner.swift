import SpriteKit

class WordSpawner {
    private unowned let scene: SKScene
    private var speed: CGFloat = 100.00;
    
    private(set) var activeWords: [SKNode] = []
    private var wordSupplier: () -> [String]
    private var wordUsageCount: [String: Int] = [:]

    enum Edge: CaseIterable { case top, bottom, left, right }

    private var lastSetEdge: Edge? = nil;
    
    init(scene: SKScene, wordSupplier: @escaping () -> [String]) {
        self.scene = scene
        self.wordSupplier = wordSupplier
    }
    
    private func getNextWord(from words: [String]) -> String? {
        // Filter words that haven't been used yet
        let eligibleWords = words.filter { wordUsageCount[$0, default: 0] < 1 }

        if let word = eligibleWords.randomElement() {
            wordUsageCount[word, default: 0] += 1
            return word
        }

        // All words used once – reset and retry
        wordUsageCount = [:]
        return getNextWord(from: words)
    }
    
    func spawnFishWord() {
        if activeWords.count > 20 { return }

        let words = wordSupplier()
        
        guard !words.isEmpty else { return }
        
        guard let word = getNextWord(from: words) else { return }

        let fishNode = createFishNode(with: word)

        let startEdge = randomEdge(excluding: lastSetEdge)

        let startPos = position(for: startEdge, node: fishNode)
        fishNode.position = startPos
        scene.addChild(fishNode)

        // Define mid point near center
        let center = CGPoint(x: scene.size.width / 2, y: scene.size.height / 2)
        let jitter: CGFloat = 100
        let midPoint = CGPoint(
            x: center.x + CGFloat.random(in: -jitter...jitter),
            y: center.y + CGFloat.random(in: -jitter...jitter)
        )

        // Vector from start → mid
        let dx = midPoint.x - startPos.x
        let dy = midPoint.y - startPos.y

        // Normalize vector
        let length = sqrt(dx*dx + dy*dy)
        let vx = dx / length
        let vy = dy / length

        // Extend to endPos far offscreen (multiplier = how far it travels)
        let multiplier: CGFloat = max(scene.size.width, scene.size.height) * 2
        let endPos = CGPoint(
            x: midPoint.x + vx * multiplier,
            y: midPoint.y + vy * multiplier
        )

        // Rotate fish to face movement direction
        face(node: fishNode, toward: midPoint)

        // Durations
        let midDuration = getDistance(from: startPos, to: midPoint) / speed
        let endDuration = getDistance(from: midPoint, to: endPos) / speed

        // Actions
        let moveToMid = SKAction.move(to: midPoint, duration: midDuration)
        moveToMid.timingMode = .linear

        let rotateToEnd = SKAction.run { [weak fishNode] in
            guard let fishNode = fishNode else { return }
            self.face(node: fishNode, toward: endPos)
        }

        let moveToEnd = SKAction.move(to: endPos, duration: endDuration)
        moveToEnd.timingMode = .linear

        let remove = SKAction.removeFromParent()
        let cleanup = SKAction.run { [weak self] in
            self?.activeWords.removeAll { $0 == fishNode }
        }

        let sequence = SKAction.sequence([
            moveToMid,
            rotateToEnd,
            moveToEnd,
            remove,
            cleanup
        ])

        fishNode.run(sequence)

        activeWords.append(fishNode)
        self.lastSetEdge = startEdge
    }

    private func createFishNode(with word: String) -> SKSpriteNode {
        let texture = SKTexture(imageNamed: GlobalConfig.shared.enemySprite)
        let fish = SKSpriteNode(texture: texture)
        fish.setScale(0.5)
        fish.name = word

        let label = SKLabelNode(text: word)
        label.fontSize = 45
        label.fontColor = .white
        label.fontName = "Fredoka-Medium"
        label.position = CGPoint(x: 0, y: -fish.size.height * 0.6)
        label.zPosition = 1
        label.verticalAlignmentMode = .center

        fish.addChild(label)
        return fish
    }

    private func randomEdge(excluding excluded: Edge? = nil) -> Edge {
        var edges = Edge.allCases
        if let excluded = excluded {
            edges.removeAll { $0 == excluded }
        }
        return edges.randomElement()!
    }

    private func position(for edge: Edge, node: SKSpriteNode) -> CGPoint {
        let frame = scene.frame
        switch edge {
        case .top:
            return CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: frame.maxY + node.size.height)
        case .bottom:
            return CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: frame.minY - node.size.height)
        case .left:
            return CGPoint(x: frame.minX - node.size.width, y: CGFloat.random(in: frame.minY...frame.maxY))
        case .right:
            return CGPoint(x: frame.maxX + node.size.width, y: CGFloat.random(in: frame.minY...frame.maxY))
        }
    }

    private func face(node: SKSpriteNode, toward point: CGPoint) {
        let dx = point.x - node.position.x
        let dy = point.y - node.position.y
        node.zRotation = atan2(dy, dx)
    }

    private func animate(node: SKNode, to destination: CGPoint) {
        let duration = getDistance(from: node.position, to: destination) / speed
        let move = SKAction.move(to: destination, duration: duration)
        let remove = SKAction.removeFromParent()
        let cleanup = SKAction.run { [weak self] in
            self?.activeWords.removeAll { $0 == node }
        }
        node.run(SKAction.sequence([move, remove, cleanup]))
    }

    func startSpawning(every interval: TimeInterval) {
        let spawnAction = SKAction.repeatForever(
            SKAction.sequence([
                SKAction.wait(forDuration: interval),
                SKAction.run { [weak self] in self?.spawnFishWord() }
            ])
        )
        scene.run(spawnAction, withKey: "wordSpawning")
    }
    func stopSpawning() {
        scene.removeAction(forKey: "wordSpawning")
    }

    func cleanUpInactiveWords() {
        activeWords = activeWords.filter { $0.parent != nil }
    }
    
    func resetWords() {
        for node in activeWords {
            node.removeFromParent()
        }

        // Clear the active list and usage counts
        activeWords.removeAll()
        wordUsageCount.removeAll()
    }
}
