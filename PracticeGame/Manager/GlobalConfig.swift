import SpriteKit

class GlobalConfig {
    static let shared = GlobalConfig()

    var selectedVerses: [Verse] = []
    var characterSprite: String
    var enemySprite: String
    
    private init() {
        characterSprite = "guppy"
        enemySprite = "wordfish"
        selectedVerses = stockVerses
    }
}
