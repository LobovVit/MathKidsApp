import SwiftUI

struct ToolBarView: View {
    @Binding var selectedTool: PlayerTool
    let saveAction: () -> Void
    let resetAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button("Поставить") {
                selectedTool = .place
            }
            .buttonStyle(.borderedProminent)
            .tint(selectedTool == .place ? .blue : .gray)

            Button("Убрать") {
                selectedTool = .remove
            }
            .buttonStyle(.borderedProminent)
            .tint(selectedTool == .remove ? .orange : .gray)

            Button("Новый мир") {
                resetAction()
            }
            .buttonStyle(.bordered)

            Button("Сохранить") {
                saveAction()
            }
            .buttonStyle(.bordered)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
    }
}
