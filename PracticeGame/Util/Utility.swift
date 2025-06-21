import SwiftUI;

public func getDistance(from: CGPoint, to: CGPoint) -> CGFloat {
    let dx = from.x - to.x
    let dy = from.y - to.y
    return sqrt(dx * dx + dy * dy)
}
