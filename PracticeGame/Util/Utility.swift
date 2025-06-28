import SwiftUI;
import SpriteKit;

public func getDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    let dx = from.x - to.x
    let dy = from.y - to.y
    return sqrt(dx * dx + dy * dy)
}

public func showScene(_ view: SKView?, _ scene: SKScene) {
    scene.scaleMode = .resizeFill
    let transition = SKTransition.fade(withDuration: 1.0)
    view?.presentScene(scene, transition: transition)
}
