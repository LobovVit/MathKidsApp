import Foundation
import CoreGraphics

struct RaceItem: Identifiable {
    let id: UUID
    let emoji: String
    var x: CGFloat
    var y: CGFloat
    let points: Int
    let isHazard: Bool

    init(
        id: UUID = UUID(),
        emoji: String,
        x: CGFloat,
        y: CGFloat,
        points: Int,
        isHazard: Bool
    ) {
        self.id = id
        self.emoji = emoji
        self.x = x
        self.y = y
        self.points = points
        self.isHazard = isHazard
    }
}
