import SwiftUI

struct PinDotsView: View {
    let pin: String
    var slots: Int = 4

    var body: some View {
        HStack(spacing: 14) {
            ForEach(0..<slots, id: \.self) { index in
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 20, height: 20)

                    if index < pin.count {
                        Circle()
                            .fill(Color.primary)
                            .frame(width: 10, height: 10)
                    }
                }
            }
        }
        .padding(.vertical, 6)
    }
}

struct PinKeypadView: View {
    let digitAction: (String) -> Void
    let deleteAction: () -> Void

    private let rows: [[String]] = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(rows, id: \.self) { row in
                HStack(spacing: 12) {
                    ForEach(row, id: \.self) { item in
                        button(item) { digitAction(item) }
                    }
                }
            }

            HStack(spacing: 12) {
                Color.clear.frame(width: 72, height: 72)
                button("0") { digitAction("0") }
                button("⌫") { deleteAction() }
            }
        }
    }

    private func button(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.92))
                    .frame(width: 72, height: 72)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black.opacity(0.08), lineWidth: 1)
                    )

                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ParentPinCard<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 18) {
            Text(title)
                .font(.largeTitle.bold())

            Text(subtitle)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            content()
        }
        .padding(24)
        .frame(maxWidth: 380)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.06), radius: 10, y: 4)
    }
}
