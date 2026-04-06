import SwiftUI

struct ColumnarInteractiveTaskView: View {
    let left: Int
    let right: Int
    let operation: MathOperation

    @Binding var answerDigits: [String]
    @Binding var carryDigits: [String]
    @Binding var selectedColumn: Int?

    private let answerCellSize = CGSize(width: 36, height: 42)
    private let carryCellSize = CGSize(width: 36, height: 28)

    private var maxDigits: Int {
        max(String(left).count, String(right).count, answerDigits.count)
    }

    private var paddedLeft: [String] { paddedDigits(left, to: maxDigits) }
    private var paddedRight: [String] { paddedDigits(right, to: maxDigits) }
    private var answerIndices: [Int] { Array(0..<maxDigits) }
    private var carryIndices: [Int] { Array(0..<max(maxDigits - 1, 0)) }

    private var activeColumn: Int {
        if let selectedColumn, answerIndices.contains(selectedColumn) {
            return selectedColumn
        }
        return max(0, maxDigits - 1)
    }

    var body: some View {
        VStack(spacing: 14) {
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
            .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.9)))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.black.opacity(0.06), lineWidth: 1))

            ColumnarKeypadView(
                digitAction: insertDigit,
                deleteAction: deleteDigit,
                clearAction: clearAllAnswers
            )
        }
        .onAppear {
            if selectedColumn == nil {
                selectedColumn = maxDigits - 1
            }
        }
    }

    private var carryRow: some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: carryCellSize.height)

            ForEach(carryIndices, id: \.self) { index in
                let enabled = isCarryEnabled(at: index)
                let isOn = carryDigits.indices.contains(index) ? carryDigits[index] == "•" : false
                let style: MathCellStyle = enabled ? .carryDotSelected : .carryDot

                Button { toggleCarry(at: index) } label: {
                    CarryDotCell(isOn: isOn, style: style, width: carryCellSize.width, height: carryCellSize.height)
                }
                .buttonStyle(.plain)
            }

            Color.clear.frame(width: carryCellSize.width, height: carryCellSize.height)
        }
    }

    private func numberRow(symbol: String?, digits: [String]) -> some View {
        HStack(spacing: 8) {
            Text(symbol ?? " ")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .frame(width: 24)

            ForEach(answerIndices, id: \.self) { index in
                let highlighted = activeColumn == index

                Text(digits[index].isEmpty ? " " : digits[index])
                    .font(.system(size: 34, weight: .bold, design: .monospaced))
                    .frame(width: answerCellSize.width, height: answerCellSize.height)
                    .background(RoundedRectangle(cornerRadius: 8).fill(highlighted ? Color.blue.opacity(0.18) : Color.clear))
                    .foregroundColor(highlighted ? .blue : .primary)
            }
        }
    }

    private var answerRow: some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: answerCellSize.height)

            ForEach(answerIndices, id: \.self) { index in
                let enabled = isAnswerEnabled(at: index)
                let focused = activeColumn == index
                let style: MathCellStyle = !enabled ? .disabled : (focused ? .selected : .normal)

                Button {
                    guard enabled else { return }
                    selectedColumn = index
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(style.backgroundColor)
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style.borderColor, lineWidth: 1.3)
                        Text(answerValue(at: index).isEmpty ? " " : answerValue(at: index))
                            .font(.system(size: 30, weight: .bold, design: .monospaced))
                            .foregroundColor(style.textColor)
                    }
                    .frame(width: answerCellSize.width, height: answerCellSize.height)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func isAnswerEnabled(at index: Int) -> Bool {
        guard answerDigits.indices.contains(index) else { return false }
        if index == maxDigits - 1 { return true }
        if activeColumn == index { return true }

        let rightIndex = index + 1
        if answerDigits.indices.contains(rightIndex), !answerDigits[rightIndex].isEmpty {
            return true
        }
        if rightIndex < answerDigits.count {
            for i in rightIndex..<answerDigits.count where !answerDigits[i].isEmpty {
                return true
            }
        }
        return false
    }

    private func isCarryEnabled(at index: Int) -> Bool {
        let column = activeColumn
        return column == index + 1 || (column == 0 && index == 0)
    }

    private func toggleCarry(at index: Int) {
        guard carryDigits.indices.contains(index), isCarryEnabled(at: index) else { return }
        carryDigits[index] = carryDigits[index] == "•" ? "" : "•"
    }

    private func insertDigit(_ digit: String) {
        let index = activeColumn
        guard answerDigits.indices.contains(index), isAnswerEnabled(at: index) else { return }
        answerDigits[index] = digit
    }

    private func deleteDigit() {
        let index = activeColumn
        guard answerDigits.indices.contains(index) else { return }
        answerDigits[index] = ""
    }

    private func clearAllAnswers() {
        for index in answerDigits.indices {
            answerDigits[index] = ""
        }
    }

    private func answerValue(at index: Int) -> String {
        guard answerDigits.indices.contains(index) else { return "" }
        return answerDigits[index]
    }

    private func paddedDigits(_ number: Int, to count: Int) -> [String] {
        let digits = String(number).map { String($0) }
        return Array(repeating: "", count: max(0, count - digits.count)) + digits
    }
}
