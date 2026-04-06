import Foundation
import CoreGraphics

struct TennisBonusItem: Identifiable {
    let id: UUID
    let emoji: String
    var x: CGFloat
    var y: CGFloat
    let points: Int

    init(id: UUID = UUID(), emoji: String, x: CGFloat, y: CGFloat, points: Int) {
        self.id = id
        self.emoji = emoji
        self.x = x
        self.y = y
        self.points = points
    }
}
