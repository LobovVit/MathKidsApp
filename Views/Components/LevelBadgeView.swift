import SwiftUI

struct LevelBadgeView: View {
    let level: DifficultyLevel

    var body: some View {
        HStack(spacing: 8) {
            Text(level.emoji)
            Text(level.title)
                .font(.headline)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Capsule().fill(Color.white.opacity(0.72)))
    }
}
