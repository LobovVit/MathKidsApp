import SwiftUI

struct ColumnarInteractiveTaskView: View {
    let left: Int
    let right: Int
    let operation: MathOperation

    @Binding var answerDigits: [String]
    @Binding var carryDigits: [String]
    @Binding var selectedColumn: Int?

    private let carryMark = "•"

    private var maxDigits: Int {
        max(String(left).count, String(right).count, answerDigits.count)
    }

    private var paddedLeft: [String] {
        paddedDigits(left, to: maxDigits)
    }

    private var paddedRight: [String] {
        paddedDigits(right, to: maxDigits)
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            carryRow
            numberRow(symbol: nil, digits: paddedLeft)
            numberRow(symbol: operation.symbol, digits: paddedRight)

            Rectangle()
                .fill(Color.primary)
                .frame(width: CGFloat(maxDigits) * 44 + 28, height: 2)

            answerRow
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
        .padding(.horizontal)
        .onAppear {
            if selectedColumn == nil {
                selectedColumn = maxDigits - 1
            }
        }
    }

    private var carryRow: some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: 28)

            ForEach(0..<maxDigits, id: \.self) { index in
                if isCarryAvailable(at: index) {
                    Button {
                        guard isCarryEnabled(at: index) else { return }
                        toggleCarry(at: index)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(carryBackgroundColor(index))
                                .frame(width: 36, height: 28)

                            Text(carryDigits[safe: index] ?? "")
                                .font(.system(size: 18, weight: .bold, design: .monospaced))
                                .foregroundColor(carryForegroundColor(index))
                        }
                    }
                    .buttonStyle(.plain)
                    .disabled(!isCarryEnabled(at: index))
                } else {
                    Color.clear.frame(width: 36, height: 28)
                }
            }
        }
    }

    private func numberRow(symbol: String?, digits: [String]) -> some View {
        HStack(spacing: 8) {
            Text(symbol ?? " ")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .frame(width: 24)

            ForEach(0..<maxDigits, id: \.self) { index in
                Text(digits[index].isEmpty ? " " : digits[index])
                    .font(.system(size: 34, weight: .bold, design: .monospaced))
                    .frame(width: 36, height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isDigitHighlighted(index) ? Color.blue.opacity(0.18) : Color.clear)
                    )
                    .foregroundColor(isDigitHighlighted(index) ? .blue : .primary)
            }
        }
    }

    private var answerRow: some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: 42)

            ForEach(0..<maxDigits, id: \.self) { index in
                TextField(
                    "",
                    text: Binding(
                        get: { answerDigits[safe: index] ?? "" },
                        set: { newValue in
                            guard isAnswerEnabled(at: index) else { return }

                            let filteredDigits = newValue.filter { $0.isNumber }
                            let replacement = filteredDigits.isEmpty ? "" : String(filteredDigits.suffix(1))

                            if answerDigits.indices.contains(index) {
                                answerDigits[index] = replacement
                            }

                            selectedColumn = index
                        }
                    )
                )
#if os(iOS)
                .keyboardType(.numberPad)
#endif
                .textFieldStyle(.plain)
                .multilineTextAlignment(.center)
                .font(.system(size: 30, weight: .bold, design: .monospaced))
                .frame(width: 36, height: 42)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(answerBackgroundColor(index))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(answerBorderColor(index), lineWidth: 1.5)
                )
                .disabled(!isAnswerEnabled(at: index))
                .onTapGesture {
                    guard isAnswerEnabled(at: index) else { return }
                    selectedColumn = index
                }
            }
        }
    }

    private func isDigitHighlighted(_ index: Int) -> Bool {
        selectedColumn == index
    }

    private func isCarryHighlighted(_ index: Int) -> Bool {
        guard let selectedColumn else { return false }
        return index == selectedColumn - 1
    }

    private func isCarryAvailable(at index: Int) -> Bool {
        index < maxDigits - 1
    }

    private func isCarryEnabled(at index: Int) -> Bool {
        guard let selectedColumn else { return false }
        return index == selectedColumn - 1
    }

    private func isAnswerEnabled(at index: Int) -> Bool {
        // самый правый всегда доступен
        if index == maxDigits - 1 { return true }

        // любой следующий слева доступен только если справа уже есть цифра
        let rightIndex = index + 1
        guard answerDigits.indices.contains(rightIndex) else { return false }
        return !answerDigits[rightIndex].isEmpty
    }

    private func toggleCarry(at index: Int) {
        guard carryDigits.indices.contains(index), isCarryAvailable(at: index), isCarryEnabled(at: index) else { return }
        carryDigits[index] = (carryDigits[index] == carryMark) ? "" : carryMark
    }

    private func answerBackgroundColor(_ index: Int) -> Color {
        if !isAnswerEnabled(at: index) {
            return Color.gray.opacity(0.06)
        }
        if isDigitHighlighted(index) {
            return Color.green.opacity(0.22)
        }
        return Color.gray.opacity(0.10)
    }

    private func answerBorderColor(_ index: Int) -> Color {
        if !isAnswerEnabled(at: index) {
            return Color.gray.opacity(0.18)
        }
        if isDigitHighlighted(index) {
            return Color.green
        }
        return Color.gray.opacity(0.3)
    }

    private func carryBackgroundColor(_ index: Int) -> Color {
        if !isCarryEnabled(at: index) {
            return Color.gray.opacity(0.06)
        }
        if isCarryHighlighted(index) {
            return Color.orange.opacity(0.28)
        }
        return Color.yellow.opacity(0.12)
    }

    private func carryForegroundColor(_ index: Int) -> Color {
        if !isCarryEnabled(at: index) {
            return Color.gray.opacity(0.35)
        }
        if isCarryHighlighted(index) {
            return .orange
        }
        return .primary
    }

    private func paddedDigits(_ number: Int, to count: Int) -> [String] {
        let digits = String(number).map { String($0) }
        let padding = Array(repeating: "", count: max(0, count - digits.count))
        return padding + digits
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
