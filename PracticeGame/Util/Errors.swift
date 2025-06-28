import Foundation

enum GameError: Error {
    case invalidState
    case missingResource(name: String)
}
