//
//  GameManager.swift
//  PracticeGame
//
//  Created by Jason Bhan on 6/14/25.
//

import SpriteKit

class GameManager {
    private(set) var score: Int32 = 0
    private(set) var combo: Int32 = 0
    private(set) var collectedWords: [String] = []
    private var currentTargetWords: [String] = []
    public var currentWordIndex = 0

    private let verses: [Verse]
    private var currentVerseIndex: Int = 0
    private(set) var currentVerse: Verse
    
    init() {
        self.verses = GlobalConfig.shared.selectedVerses
        self.currentVerseIndex = 0
        self.currentVerse = verses[0]
        loadVerse(at: currentVerseIndex)
    }

    private func cleanAndSplitText(_ text: String) -> [String] {
        let unwantedCharacterSet = CharacterSet.punctuationCharacters.subtracting(CharacterSet(charactersIn: "'"))
        let cleanedText = text
            .unicodeScalars
            .filter { !unwantedCharacterSet.contains($0) }
            .map { String($0) }
            .joined()

        return cleanedText
            .split(separator: " ")
            .map { String($0) }
    }

    private func loadVerse(at index: Int) {
        guard index >= 0 && index < verses.count else { return }
        currentVerse = verses[index]
        currentTargetWords = cleanAndSplitText(currentVerse.text)
        currentWordIndex = 0
        collectedWords.removeAll()
    }

    public func resetGame() {
        score = 0
        combo = 0
        currentVerseIndex = 0
        loadVerse(at: currentVerseIndex)
    }

    public func incrementScore() {
        combo += 1
        score += min(combo, 10)
    }

    public func resetCombo() {
        combo = 0
    }

    func getCurrentWord() -> String? {
        guard currentWordIndex < currentTargetWords.count else { return nil }
        return currentTargetWords[currentWordIndex]
    }

    func handleCollected(word: String) -> Bool {
        guard let expected = getCurrentWord() else { return false }

        if word == expected {
            collectedWords.append(word)
            currentWordIndex += 1
            incrementScore()

            // Verse completed
            if currentWordIndex >= currentTargetWords.count {
                onVerseCompleted()
            }

            return true
        } else {
            resetCombo()
            return false
        }
    }

    func onVerseCompleted() {
        currentVerseIndex += 1

        if currentVerseIndex < verses.count {
            loadVerse(at: currentVerseIndex)
        } else {
            // All verses complete
            print("All verses completed. Total Score: \(score)")
        }
    }

    func getTargetWordList() -> [String] {
        guard !currentTargetWords.isEmpty else { return [] }

        let maxCount = min(5, currentTargetWords.count)
        let startingIndex = max(0, min(currentWordIndex, currentTargetWords.count - maxCount))
        let endingIndex = startingIndex + maxCount

        return Array(currentTargetWords[startingIndex..<endingIndex])
    }
    
    func getCollectedList() -> [String] {
        return collectedWords
    }
    
    func getCurrentVerseReference() -> String {
        return currentVerse.reference
    }
}
