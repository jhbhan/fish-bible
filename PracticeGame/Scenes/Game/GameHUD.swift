import SpriteKit

class GameHUD: SKNode {
    private let scoreLabel = SKLabelNode(fontNamed: "Fredoka-Bold")
    private let comboLabel = SKLabelNode(fontNamed: "Fredoka-Bold")
    private let verseLabel = SKLabelNode(fontNamed: "Fredoka-Medium")
    private let verseLabelBackground: SKShapeNode
    private let collectedWordsLabel = SKLabelNode(fontNamed: "Fredoka-Medium")
    private let collectedWordsBackground: SKShapeNode
    private var collectedWordLines: [SKLabelNode] = []
    private let maxDisplayLines = 2

    private var collectedWords: [String] = []
    
    init(size: CGSize, verseReference: String) {
        let horizontalMargin: CGFloat = size.width * 0.05
        let bgWidth = size.width - 2 * horizontalMargin
        let collectedBGHeight = size.height * 0.2
        let verseBGHeight = size.height * 0.06
        let verticalSpacing = size.height * 0.01

        collectedWordsBackground = SKShapeNode(rectOf: CGSize(width: bgWidth, height: collectedBGHeight), cornerRadius: 8)
        verseLabelBackground = SKShapeNode(rectOf: CGSize(width: bgWidth / 2, height: verseBGHeight), cornerRadius: 8)
        super.init()
        
        zPosition = 1000
        
        // Score
        scoreLabel.fontSize = size.height * 0.045
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - size.height * 0.08)
        addChild(scoreLabel)
        
        // Combo
        comboLabel.fontSize = size.height * 0.035
        comboLabel.fontColor = .white
        comboLabel.horizontalAlignmentMode = .left
        comboLabel.position = CGPoint(x: horizontalMargin, y: size.height - size.height * 0.04)
        addChild(comboLabel)
        
        // Word list background
        collectedWordsBackground.fillColor = .systemBlue
        collectedWordsBackground.alpha = 0.8
        collectedWordsBackground.strokeColor = .white
        collectedWordsBackground.lineWidth = 2
        collectedWordsBackground.position = CGPoint(x: size.width / 2, y: collectedBGHeight / 2 + size.height * 0.05)
        collectedWordsBackground.zPosition = -1
        addChild(collectedWordsBackground)
        
        // Word list label
        collectedWordsLabel.fontSize = size.height * 0.03
        collectedWordsLabel.fontColor = .white
        collectedWordsLabel.position = collectedWordsBackground.position
        collectedWordsLabel.zPosition = 1
        addChild(collectedWordsLabel)
        
        // Verse label background (above word list)
        verseLabelBackground.strokeColor = .white
        verseLabelBackground.fillColor = .systemCyan
        verseLabelBackground.position = CGPoint(
            x: collectedWordsBackground.position.x,
            y: collectedWordsBackground.position.y + collectedBGHeight / 2 + verseBGHeight / 2 + verticalSpacing
        )
        addChild(verseLabelBackground)
        
        // Verse label
        verseLabel.text = verseReference
        verseLabel.fontSize = size.height * 0.03
        verseLabel.fontColor = .white
        verseLabel.position = verseLabelBackground.position
        verseLabel.horizontalAlignmentMode = .center
        verseLabel.verticalAlignmentMode = .center
        verseLabel.zPosition = 1
        addChild(verseLabel)
        
        update(score: 0, combo: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(score: Int32, combo: Int32, newWord: String? = nil) {
        scoreLabel.text = "Score: \(score)"
        comboLabel.text = "Combo: \(combo)"
        
        if let word = newWord {
            collectedWords.append(word)
        }
        
        renderWrappedWords(collectedWords)
    }
    
    private func wrapText(_ text: String, maxLineLength: Int) -> String {
        let words = text.split(separator: " ")
        var currentLine = ""
        var wrappedText = ""
        
        for word in words {
            let wordLength = word.count
            let lineLength = currentLine.count
            
            // Check if adding this word exceeds line limit
            if lineLength + wordLength + (lineLength > 0 ? 1 : 0) > maxLineLength {
                wrappedText += currentLine + "\n"
                currentLine = ""
            }
            
            currentLine += (currentLine.isEmpty ? "" : " ") + word
        }
        
        if !currentLine.isEmpty {
            wrappedText += currentLine
        }
        
        return wrappedText
    }
    
    func emptyWordList() {
        collectedWords.removeAll()
        for node in collectedWordLines {
            node.removeFromParent()
        }
    }
    
    func updateVerseRef(verseRef: String) {
        verseLabel.text = verseRef
    }
    
    private func renderWrappedWords(_ words: [String]) {
        // Remove existing line nodes
        for label in collectedWordLines {
            label.removeFromParent()
        }
        collectedWordLines.removeAll()

        // Determine maxCharsPerLine based on background width
        let fontSize = collectedWordsBackground.frame.height / CGFloat(maxDisplayLines + 2)
        let estimatedCharWidth = fontSize * 0.6  // closer match to Fredoka
        let maxLineLength = Int((collectedWordsBackground.frame.width - 20) / estimatedCharWidth)

        // Wrap text
        var currentLine = ""
        var lines: [String] = []

        for word in words {
            if currentLine.count + word.count + 1 > maxLineLength {
                lines.append(currentLine)
                currentLine = word
            } else {
                currentLine += (currentLine.isEmpty ? "" : " ") + word
            }
        }
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }

        // Only display the last few lines
        let displayLines = lines.suffix(maxDisplayLines)

        // Responsive font size and spacing
        let lineSpacing = fontSize * 1.2

        for (i, lineText) in displayLines.enumerated() {
            let lineLabel = SKLabelNode(fontNamed: "Fredoka-Regular")
            lineLabel.text = lineText
            lineLabel.fontSize = fontSize
            lineLabel.fontColor = .white
            lineLabel.horizontalAlignmentMode = .left
            lineLabel.verticalAlignmentMode = .center
            lineLabel.position = CGPoint(
                x: collectedWordsBackground.position.x - collectedWordsBackground.frame.width / 2 + 10,
                y: collectedWordsBackground.position.y + (CGFloat(displayLines.count - i - 1) * lineSpacing)
            )
            lineLabel.zPosition = 1
            addChild(lineLabel)
            collectedWordLines.append(lineLabel)
        }
    }
    
    func resize(to newSize: CGSize) {
        let horizontalMargin: CGFloat = newSize.width * 0.05
        let bgWidth = newSize.width - 2 * horizontalMargin
        let collectedBGHeight = newSize.height * 0.2
        let verseBGHeight = newSize.height * 0.06
        let verticalSpacing = newSize.height * 0.01

        // Update score
        scoreLabel.fontSize = newSize.height * 0.045
        scoreLabel.position = CGPoint(x: newSize.width / 2, y: newSize.height - newSize.height * 0.08)

        // Update combo
        comboLabel.fontSize = newSize.height * 0.035
        comboLabel.position = CGPoint(x: horizontalMargin, y: newSize.height - newSize.height * 0.04)

        // Update collected words background
        collectedWordsBackground.path = CGPath(rect: CGRect(x: -bgWidth/2, y: -collectedBGHeight/2, width: bgWidth, height: collectedBGHeight), transform: nil)
        collectedWordsBackground.position = CGPoint(x: newSize.width / 2, y: collectedBGHeight / 2 + newSize.height * 0.05)

        // Update collected words label
        collectedWordsLabel.fontSize = newSize.height * 0.03
        collectedWordsLabel.position = collectedWordsBackground.position

        // Update verse label background
        verseLabelBackground.path = CGPath(rect: CGRect(x: -bgWidth/2, y: -verseBGHeight/2, width: bgWidth, height: verseBGHeight), transform: nil)
        verseLabelBackground.position = CGPoint(
            x: collectedWordsBackground.position.x,
            y: collectedWordsBackground.position.y + collectedBGHeight / 2 + verseBGHeight / 2 + verticalSpacing
        )

        // Update verse label
        verseLabel.fontSize = newSize.height * 0.03
        verseLabel.position = verseLabelBackground.position

        // Re-render wrapped words
        renderWrappedWords(collectedWords)
    }

}
