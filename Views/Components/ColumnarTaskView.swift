import SwiftUI

struct ColumnarTaskView: View {
    let left: Int
    let right: Int
    let operation: MathOperation

    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            if operation == .division {
                HStack(alignment: .top, spacing: 8) {
                    Text("\(left)")
                        .font(.system(size: 42, weight: .bold, design: .monospaced))

                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 8) {
                            Text("\(right)")
                                .font(.system(size: 38, weight: .bold, design: .monospaced))
                            Rectangle()
                                .fill(Color.primary)
                                .frame(width: 2, height: 40)
                        }
                        Rectangle()
                            .fill(Color.primary)
                            .frame(width: 90, height: 2)
                    }
                }
            } else {
                Text("\(left)")
                    .font(.system(size: 42, weight: .bold, design: .monospaced))

                HStack(spacing: 8) {
                    Text(operation.symbol)
                        .font(.system(size: 42, weight: .bold, design: .monospaced))
                    Text("\(right)")
                        .font(.system(size: 42, weight: .bold, design: .monospaced))
                }

                Rectangle()
                    .fill(Color.primary)
                    .frame(width: 140, height: 3)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}
