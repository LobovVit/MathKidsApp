import SwiftUI

struct ColumnarTaskView: View {
    let left: Int
    let right: Int
    let operation: MathOperation

    private var maxDigits: Int {
        max(String(left).count, String(right).count)
    }

    private var lineWidth: CGFloat {
        CGFloat(max(maxDigits, 2)) * 34 + 28
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            if operation == .division {
                HStack(alignment: .top, spacing: 8) {
                    Text("\(right)")
                        .font(.system(size: 42, weight: .bold, design: .monospaced))

                    VStack(alignment: .leading, spacing: 6) {
                        Text(") \(left)")
                            .font(.system(size: 42, weight: .bold, design: .monospaced))
                        Rectangle()
                            .frame(width: max(lineWidth, 120), height: 3)
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
                    .frame(width: lineWidth, height: 3)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.88))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}
