import SwiftUI

struct RewardBadgeView: View { let stars: Int; var body: some View { HStack(spacing: 10) { ForEach(0..<3, id: \.self) { index in Text(index < stars ? "⭐️" : "☆").font(.system(size: 34)) } } } }
