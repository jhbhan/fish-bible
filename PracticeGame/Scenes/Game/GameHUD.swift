import SpriteKit

class GameHUD: SKNode {
    private let scoreLabel = SKLabelNode(fontNamed: "Fredoka-Bold")
    private let comboLabel = SKLabelNode(fontNamed: "Fredoka-Bold")
    private let verseLabel = SKLabelNode(fontNamed: "Fredoka-Medium")
    private let collectedWordsLabel = SKLabelNode(fontNamed: "Fredoka-Medium")
    private let collectedWordsBackground: SKShapeNode
    private var collectedWordLines: [SKLabelNode] = []
    private let maxDisplayLines = 2

    private var collectedWords: [String] = []
    
    init(size: CGSize, verseReference: String) {
        let bgWidth = size.width - 40
        let bgHeight: CGFloat = 60
        collectedWordsBackground = SKShapeNode(rectOf: CGSize(width: bgWidth, height: bgHeight), cornerRadius: 8)
        
        super.init()
        
        zPosition = 1000
        
        // Score
        scoreLabel.fontSize = 28
        scoreLabel.fontColor = .white
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 80)
        addChild(scoreLabel)
        
        // Combo
        comboLabel.fontSize = 20
        comboLabel.fontColor = .white
        comboLabel.horizontalAlignmentMode = .left
        comboLabel.position = CGPoint(x: 20, y: size.height - 40)
        addChild(comboLabel)
        
        // Word list background
        collectedWordsBackground.fillColor = .systemBlue
        collectedWordsBackground.alpha = 0.8
        collectedWordsBackground.strokeColor = .white
        collectedWordsBackground.lineWidth = 2
        collectedWordsBackground.position = CGPoint(x: size.width / 2, y: 60)
        collectedWordsBackground.zPosition = -1
        addChild(collectedWordsBackground)
        
        // Word list label
        collectedWordsLabel.fontSize = 16
        collectedWordsLabel.fontColor = .white
        collectedWordsLabel.position = collectedWordsBackground.position
        collectedWordsLabel.zPosition = 1
        addChild(collectedWordsLabel)
        
        //Verse list label
        verseLabel.text = verseReference
        verseLabel.fontSize = 24
        verseLabel.fontColor = .white
        verseLabel.position = CGPoint(x: collectedWordsBackground.position.x, y: collectedWordsBackground.position.y + 20)
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
        
        renderWrappedWords(collectedWords, maxCharsPerLine: 45)
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
    
    private func renderWrappedWords(_ words: [String], maxCharsPerLine: Int) {
        // Remove existing line nodes
        for label in collectedWordLines {
            label.removeFromParent()
        }
        collectedWordLines.removeAll()
        
        // Wrap text
        var currentLine = ""
        var lines: [String] = []
        
        for word in words {
            if currentLine.count + word.count + 1 > maxCharsPerLine {
                lines.append(currentLine)
                currentLine = word
            } else {
                currentLine += (currentLine.isEmpty ? "" : " ") + word
            }
        }
        if !currentLine.isEmpty {
            lines.append(currentLine)
        }
        
        // Keep only the last `maxDisplayLines` lines
        if lines.count > maxDisplayLines {
            lines = Array(lines.suffix(maxDisplayLines))
        }
        
        // Render visible lines
        for (i, lineText) in lines.enumerated() {
            let lineLabel = SKLabelNode(fontNamed: "Fredoka-Regular")
            lineLabel.text = lineText
            lineLabel.fontSize = 16
            lineLabel.fontColor = .white
            lineLabel.horizontalAlignmentMode = .left
            lineLabel.verticalAlignmentMode = .center
            lineLabel.position = CGPoint(
                x: collectedWordsBackground.position.x - collectedWordsBackground.frame.width / 2 + 10,
                y: collectedWordsBackground.position.y + CGFloat(maxDisplayLines - i - 1) * 20
            )
            lineLabel.zPosition = 1
            addChild(lineLabel)
            collectedWordLines.append(lineLabel)
        }
    }
}
