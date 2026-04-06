import SwiftUI

struct ColumnarMultiplicationTaskView: View {
    let left: Int
    let right: Int

    @Binding var partialRows: [[String]]
    @Binding var partialCarryRows: [[String]]
    @Binding var carryDigits: [String]
    @Binding var resultDigits: [String]
    @Binding var selectedRow: Int?
    @Binding var selectedColumn: Int?

    private let cellSize = CGSize(width: 36, height: 42)
    private let carrySize = CGSize(width: 36, height: 28)

    private var width: Int { max(String(left * right).count, String(left).count + String(right).count) }
    private var topDigits: [String] { padLeft(String(left).map { String($0) }, to: width) }
    private var bottomDigits: [String] { padLeft(String(right).map { String($0) }, to: width) }
    private var bottomStartIndex: Int { width - String(right).count }
    private var finalRowIndex: Int { partialRows.count }
    private var hasFinalAdditionBlock: Bool { String(right).count > 1 }
    private var rowIndices: [Int] { Array(partialRows.indices) }
    private var columnIndices: [Int] { Array(0..<width) }

    var body: some View {
        VStack(spacing: 14) {
            VStack(alignment: .trailing, spacing: 10) {
                numberRow(symbol: nil, digits: topDigits, highlightColumn: currentTopDigitHighlight)
                numberRow(symbol: "×", digits: bottomDigits, highlightColumn: currentBottomDigitHighlight)
                divider

                ForEach(rowIndices, id: \.self) { row in
                    partialCarryRow(row)
                    partialRow(row)
                    if hasFinalAdditionBlock && row < partialRows.count - 1 {
                        plusSeparatorRow()
                    }
                }

                if hasFinalAdditionBlock {
                    divider
                    finalCarryRow
                    finalResultRow
                }
            }
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 24).fill(Color.white.opacity(0.9)))
            .overlay(RoundedRectangle(cornerRadius: 24).stroke(Color.black.opacity(0.06), lineWidth: 1))
            .padding(.horizontal)

            ColumnarKeypadView(
                digitAction: insertDigit,
                deleteAction: deleteDigit,
                clearAction: clearAll
            )
        }
        .onAppear {
            if selectedRow == nil { selectedRow = 0 }
            if selectedColumn == nil { selectedColumn = width - 1 }
        }
    }

    private var currentTopDigitHighlight: Int? {
        guard let selectedRow, let selectedColumn, selectedRow < partialRows.count else { return nil }
        let mappedTopColumn = selectedColumn + selectedRow
        return (0..<width).contains(mappedTopColumn) ? mappedTopColumn : nil
    }

    private var currentBottomDigitHighlight: Int? {
        guard let selectedRow, selectedRow < partialRows.count else { return nil }
        let digitCount = String(right).count
        let highlightedInBottom = digitCount - 1 - selectedRow
        guard highlightedInBottom >= 0 && highlightedInBottom < digitCount else { return nil }
        return bottomStartIndex + highlightedInBottom
    }

    private var divider: some View {
        Rectangle().fill(Color.primary).frame(width: CGFloat(width) * 44 + 28, height: 2)
    }

    private func plusSeparatorRow() -> some View {
        HStack(spacing: 8) {
            Text("+")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .foregroundColor(.red.opacity(0.9))
                .frame(width: 24)
            ForEach(columnIndices, id: \.self) { _ in
                Color.clear.frame(width: cellSize.width, height: 12)
            }
        }
    }

    private func numberRow(symbol: String?, digits: [String], highlightColumn: Int?) -> some View {
        HStack(spacing: 8) {
            Text(symbol ?? " ")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .frame(width: 24)
            ForEach(columnIndices, id: \.self) { index in
                Text(digits[index].isEmpty ? " " : digits[index])
                    .font(.system(size: 34, weight: .bold, design: .monospaced))
                    .frame(width: cellSize.width, height: cellSize.height)
                    .background(RoundedRectangle(cornerRadius: 8).fill(highlightColumn == index ? Color.blue.opacity(0.18) : Color.clear))
                    .foregroundColor(highlightColumn == index ? .blue : .primary)
            }
        }
    }

    private func partialCarryRow(_ row: Int) -> some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: carrySize.height)
            ForEach(columnIndices, id: \.self) { column in
                if isPartialCarryAvailable(row: row, column: column) {
                    let focused = selectedRow == row && selectedColumn == column + 1
                    let value = partialCarryValue(row: row, column: column)
                    let style: MathCellStyle = focused ? .carrySelected : .carry
                    cellButton(value: value, style: style, width: carrySize.width, height: carrySize.height, fontSize: 18) {
                        selectedRow = row
                        selectedColumn = column + 1
                    }
                } else {
                    Color.clear.frame(width: carrySize.width, height: carrySize.height)
                }
            }
        }
    }

    private func partialRow(_ row: Int) -> some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: cellSize.height)
            ForEach(columnIndices, id: \.self) { column in
                let enabled = isPartialCellEditable(row: row, column: column)
                let showZero = shouldShowShiftZero(row: row, column: column)
                let focused = selectedRow == row && selectedColumn == column

                if showZero {
                    DigitReadonlyCell(value: "0", width: cellSize.width, height: cellSize.height, fontSize: 28, style: .readonlyAccent)
                } else {
                    let style: MathCellStyle = !enabled ? .disabled : (focused ? .selected : .normal)
                    cellButton(value: partialValue(row: row, column: column), style: style, width: cellSize.width, height: cellSize.height, fontSize: 28) {
                        guard enabled else { return }
                        selectedRow = row
                        selectedColumn = column
                    }
                }
            }
        }
    }

    private var finalCarryRow: some View {
        HStack(spacing: 8) {
            Text("=")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .foregroundColor(.red.opacity(0.9))
                .frame(width: 24)

            ForEach(columnIndices, id: \.self) { column in
                if column < width - 1 {
                    let focused = selectedRow == finalRowIndex && selectedColumn == column + 1
                    let style: MathCellStyle = focused ? .carrySelected : .carry
                    cellButton(value: carryValue(column), style: style, width: carrySize.width, height: carrySize.height, fontSize: 18) {
                        selectedRow = finalRowIndex
                        selectedColumn = column + 1
                    }
                } else {
                    Color.clear.frame(width: carrySize.width, height: carrySize.height)
                }
            }
        }
    }

    private var finalResultRow: some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: cellSize.height)
            ForEach(columnIndices, id: \.self) { column in
                let focused = selectedRow == finalRowIndex && selectedColumn == column
                let style: MathCellStyle = focused ? .selected : .normal
                cellButton(value: resultValue(column), style: style, width: cellSize.width, height: cellSize.height, fontSize: 30) {
                    selectedRow = finalRowIndex
                    selectedColumn = column
                }
            }
        }
    }

    private func cellButton(value: String, style: MathCellStyle, width: CGFloat, height: CGFloat, fontSize: CGFloat, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(style.backgroundColor)
                RoundedRectangle(cornerRadius: 8).stroke(style.borderColor, lineWidth: 1.3)
                Text(value.isEmpty ? " " : value)
                    .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                    .foregroundColor(style.textColor)
            }
            .frame(width: width, height: height)
        }
        .buttonStyle(.plain)
    }

    private func insertDigit(_ digit: String) {
        guard let row = selectedRow, let column = selectedColumn else { return }

        if row == finalRowIndex {
            if column >= 1 && column < width {
                carrySet(digit, column: column - 1)
            } else if column >= 0 && column < width {
                resultSet(digit, column: column)
            }
            return
        }

        guard row >= 0 && row < partialRows.count else { return }
        if column >= 1 && column < width && isPartialCarryAvailable(row: row, column: column - 1) {
            partialCarrySet(digit, row: row, column: column - 1)
        } else if column >= 0 && column < width && isPartialCellEditable(row: row, column: column) && !shouldShowShiftZero(row: row, column: column) {
            partialSet(digit, row: row, column: column)
        }
    }

    private func deleteDigit() {
        guard let row = selectedRow, let column = selectedColumn else { return }

        if row == finalRowIndex {
            if column >= 1 && column < width {
                carrySet("", column: column - 1)
            } else if column >= 0 && column < width {
                resultSet("", column: column)
            }
            return
        }

        guard row >= 0 && row < partialRows.count else { return }
        if column >= 1 && column < width && isPartialCarryAvailable(row: row, column: column - 1) {
            partialCarrySet("", row: row, column: column - 1)
        } else if column >= 0 && column < width && isPartialCellEditable(row: row, column: column) && !shouldShowShiftZero(row: row, column: column) {
            partialSet("", row: row, column: column)
        }
    }

    private func clearAll() {
        for r in partialRows.indices {
            for c in partialRows[r].indices { partialRows[r][c] = "" }
        }
        for r in partialCarryRows.indices {
            for c in partialCarryRows[r].indices { partialCarryRows[r][c] = "" }
        }
        for c in carryDigits.indices { carryDigits[c] = "" }
        for c in resultDigits.indices { resultDigits[c] = "" }
    }

    private func editableBounds(forPartialRow row: Int) -> (start: Int, end: Int)? {
        let availableRightEdge = width - 1 - row
        let topCount = String(left).count
        let startColumn = max(0, availableRightEdge - topCount + 1)
        guard startColumn <= availableRightEdge else { return nil }
        return (startColumn, availableRightEdge)
    }

    private func isPartialCellEditable(row: Int, column: Int) -> Bool {
        guard let bounds = editableBounds(forPartialRow: row) else { return false }
        return column >= bounds.start && column <= bounds.end && !shouldShowShiftZero(row: row, column: column)
    }

    private func shouldShowShiftZero(row: Int, column: Int) -> Bool {
        row > 0 && column > width - 1 - row
    }

    private func isPartialCarryAvailable(row: Int, column: Int) -> Bool {
        guard let bounds = editableBounds(forPartialRow: row) else { return false }
        return column >= bounds.start && column < bounds.end
    }

    private func partialValue(row: Int, column: Int) -> String {
        guard partialRows.indices.contains(row), partialRows[row].indices.contains(column) else { return "" }
        return partialRows[row][column]
    }

    private func partialSet(_ value: String, row: Int, column: Int) {
        guard partialRows.indices.contains(row), partialRows[row].indices.contains(column) else { return }
        partialRows[row][column] = value
    }

    private func partialCarryValue(row: Int, column: Int) -> String {
        guard partialCarryRows.indices.contains(row), partialCarryRows[row].indices.contains(column) else { return "" }
        return partialCarryRows[row][column]
    }

    private func partialCarrySet(_ value: String, row: Int, column: Int) {
        guard partialCarryRows.indices.contains(row), partialCarryRows[row].indices.contains(column) else { return }
        partialCarryRows[row][column] = value
    }

    private func carryValue(_ column: Int) -> String {
        guard carryDigits.indices.contains(column) else { return "" }
        return carryDigits[column]
    }

    private func carrySet(_ value: String, column: Int) {
        guard carryDigits.indices.contains(column) else { return }
        carryDigits[column] = value
    }

    private func resultValue(_ column: Int) -> String {
        guard resultDigits.indices.contains(column) else { return "" }
        return resultDigits[column]
    }

    private func resultSet(_ value: String, column: Int) {
        guard resultDigits.indices.contains(column) else { return }
        resultDigits[column] = value
    }

    private func padLeft(_ digits: [String], to count: Int) -> [String] {
        Array(repeating: "", count: max(0, count - digits.count)) + digits
    }
}
