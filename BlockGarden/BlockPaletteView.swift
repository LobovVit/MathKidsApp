import SwiftUI

struct BlockPaletteView: View {
    @Binding var selectedBlock: BlockType

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(BlockType.allCases) { block in
                    Button {
                        selectedBlock = block
                    } label: {
                        VStack(spacing: 6) {
                            Text(block.icon)
                                .font(.system(size: 28))
                                .frame(width: 34, height: 34)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.82))
                                )

                            Text(block.displayName)
                                .font(.caption2.bold())
                                .foregroundColor(.primary)
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(selectedBlock == block ? Color.white.opacity(0.95) : Color.white.opacity(0.82))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(selectedBlock == block ? Color.blue : Color.clear, lineWidth: 2)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 4)
    }
}
