import SwiftUI

struct BonusGameHeaderBar: View {
    let title: String
    let scoreTitle: String
    let scoreValue: String
    let timeValue: String
    let backAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button("← Назад") {
                    backAction()
                }
                .buttonStyle(.bordered)

                Spacer()

                Text(title)
                    .font(.headline)

                Spacer()

                Color.clear.frame(width: 86, height: 1)
            }

            HStack(spacing: 12) {
                capsule("⏰ \(timeValue)")
                Spacer()
                capsule("\(scoreTitle) \(scoreValue)")
            }
        }
        .padding(.horizontal)
    }

    private func capsule(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Capsule().fill(Color.white.opacity(0.88)))
    }
}

struct BonusGameResultCard: View {
    let title: String
    let scoreText: String
    let bestScoreText: String
    let primaryTitle: String
    let primaryAction: () -> Void
    let secondaryTitle: String
    let secondaryAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.largeTitle.bold())

            Text(scoreText)
                .font(.title2.bold())

            Text(bestScoreText)
                .font(.headline)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Button(primaryTitle) {
                    primaryAction()
                }
                .buttonStyle(.borderedProminent)

                Button(secondaryTitle) {
                    secondaryAction()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.94))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .padding()
    }
}
