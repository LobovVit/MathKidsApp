import SwiftUI

struct BigMenuCard: View {
    let emoji: String
    let title: String
    let subtitle: String
    var compact: Bool = false

    var body: some View {
        HStack(spacing: compact ? 12 : 16) {
            Text(emoji)
                .font(.system(size: compact ? 28 : 44))
                .frame(width: compact ? 32 : 48)
            VStack(alignment: .leading, spacing: compact ? 4 : 6) {
                Text(title)
                    .font(compact ? .headline : .title3.bold())
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                Text(subtitle)
                    .font(compact ? .caption : .body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
            Spacer(minLength: 0)
        }
        .padding(compact ? 14 : 20)
        .frame(maxWidth: .infinity, minHeight: compact ? 78 : 96, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.84)))
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}
