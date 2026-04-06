import SwiftUI

struct ColumnarKeypadView: View {
    let digitAction: (String) -> Void
    let deleteAction: () -> Void
    let clearAction: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                key("1") { digitAction("1") }
                key("2") { digitAction("2") }
                key("3") { digitAction("3") }
            }
            HStack(spacing: 10) {
                key("4") { digitAction("4") }
                key("5") { digitAction("5") }
                key("6") { digitAction("6") }
            }
            HStack(spacing: 10) {
                key("7") { digitAction("7") }
                key("8") { digitAction("8") }
                key("9") { digitAction("9") }
            }
            HStack(spacing: 10) {
                key("⌫", action: deleteAction)
                key("0") { digitAction("0") }
                key("C", action: clearAction)
            }
        }
    }

    private func key(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(width: 72, height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.white.opacity(0.92))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.black.opacity(0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
