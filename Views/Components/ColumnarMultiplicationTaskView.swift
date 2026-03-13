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

    private var width: Int {
        max(String(left * right).count, String(left).count + String(right).count)
    }

    private var topDigits: [String] {
        padLeft(String(left).map { String($0) }, to: width)
    }

    private var bottomDigits: [String] {
        padLeft(String(right).map { String($0) }, to: width)
    }

    private var bottomStartIndex: Int {
        width - String(right).count
    }

    private var finalRowIndex: Int {
        partialRows.count
    }

    private var hasFinalAdditionBlock: Bool {
        String(right).count > 1
    }

    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            numberRow(symbol: nil, digits: topDigits, highlightColumn: currentTopDigitHighlight)
            numberRow(symbol: "×", digits: bottomDigits, highlightColumn: currentBottomDigitHighlight)
            divider

            ForEach(0..<partialRows.count, id: \.self) { row in
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
            if selectedRow == nil { selectedRow = 0 }
            if selectedColumn == nil { selectedColumn = width - 1 }
        }
    }

    // MARK: - Highlight logic

    private var currentTopDigitHighlight: Int? {
        guard let selectedRow,
              let selectedColumn,
              selectedRow < partialRows.count else { return nil }

        guard let bounds = editableBounds(forPartialRow: selectedRow) else { return nil }
        guard selectedColumn >= bounds.start && selectedColumn <= bounds.end else { return nil }

        let mappedTopColumn = selectedColumn + selectedRow
        guard (0..<width).contains(mappedTopColumn) else { return nil }

        return mappedTopColumn
    }

    private var currentBottomDigitHighlight: Int? {
        guard let selectedRow,
              selectedRow < partialRows.count else { return nil }

        let digitCount = String(right).count
        let highlightedInBottom = digitCount - 1 - selectedRow

        guard highlightedInBottom >= 0 && highlightedInBottom < digitCount else { return nil }
        return bottomStartIndex + highlightedInBottom
    }

    // MARK: - Static rows

    private var divider: some View {
        Rectangle()
            .fill(Color.primary)
            .frame(width: CGFloat(width) * 44 + 28, height: 2)
    }

    private func plusSeparatorRow() -> some View {
        HStack(spacing: 8) {
            Text("+")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .foregroundColor(.red.opacity(0.9))
                .frame(width: 24)

            ForEach(0..<width, id: \.self) { _ in
                Color.clear.frame(width: 36, height: 12)
            }
        }
    }

    private func numberRow(symbol: String?, digits: [String], highlightColumn: Int?) -> some View {
        HStack(spacing: 8) {
            Text(symbol ?? " ")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .frame(width: 24)

            ForEach(0..<width, id: \.self) { index in
                Text(digits[index].isEmpty ? " " : digits[index])
                    .font(.system(size: 34, weight: .bold, design: .monospaced))
                    .frame(width: 36, height: 42)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(highlightColumn == index ? Color.blue.opacity(0.18) : Color.clear)
                    )
                    .foregroundColor(highlightColumn == index ? .blue : .primary)
            }
        }
    }

    // MARK: - Partial carry rows

    private func partialCarryRow(_ row: Int) -> some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: 28)

            ForEach(0..<width, id: \.self) { column in
                partialCarryCell(row: row, column: column)
            }
        }
    }

    @ViewBuilder
    private func partialCarryCell(row: Int, column: Int) -> some View {
        if isPartialCarryAvailable(row: row, column: column) {
            let enabled = isPartialCarryEnabled(row: row, column: column)
            let isSelected = selectedRow == row && selectedColumn == column + 1

            TextField(
                "",
                text: Binding(
                    get: { partialCarryRows[safe: row]?[safe: column] ?? "" },
                    set: { newValue in
                        guard enabled else { return }
                        partialCarryRows[row][column] = singleDigit(from: newValue)
                        selectedRow = row
                        selectedColumn = column + 1
                    }
                )
            )
#if os(iOS)
            .keyboardType(.numberPad)
#endif
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .font(.system(size: 18, weight: .bold, design: .monospaced))
            .frame(width: 36, height: 28)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(carryBackgroundColor(enabled: enabled, isSelected: isSelected))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(carryBorderColor(enabled: enabled, isSelected: isSelected), lineWidth: 1)
            )
            .disabled(!enabled)
            .onTapGesture {
                guard enabled else { return }
                selectedRow = row
                selectedColumn = column + 1
            }
        } else {
            Color.clear.frame(width: 36, height: 28)
        }
    }

    // MARK: - Partial result rows

    private func partialRow(_ row: Int) -> some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: 42)

            ForEach(0..<width, id: \.self) { column in
                partialCell(row: row, column: column)
            }
        }
    }

    @ViewBuilder
    private func partialCell(row: Int, column: Int) -> some View {
        let enabled = isPartialCellEnabled(row: row, column: column)
        let showZero = shouldShowShiftZero(row: row, column: column)
        let isSelected = selectedRow == row && selectedColumn == column

        if showZero {
            Text("0")
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(.red.opacity(0.9))
                .frame(width: 36, height: 42)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.10))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1.5)
                )
        } else {
            TextField(
                "",
                text: Binding(
                    get: { partialRows[safe: row]?[safe: column] ?? "" },
                    set: { newValue in
                        guard enabled else { return }
                        partialRows[row][column] = singleDigit(from: newValue)
                        selectedRow = row
                        selectedColumn = column
                    }
                )
            )
#if os(iOS)
            .keyboardType(.numberPad)
#endif
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .font(.system(size: 28, weight: .bold, design: .monospaced))
            .frame(width: 36, height: 42)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(inputBackgroundColor(enabled: enabled, isSelected: isSelected))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(inputBorderColor(enabled: enabled, isSelected: isSelected), lineWidth: 1.5)
            )
            .disabled(!enabled)
            .onTapGesture {
                guard enabled else { return }
                selectedRow = row
                selectedColumn = column
            }
        }
    }

    // MARK: - Final carry row

    private var finalCarryRow: some View {
        HStack(spacing: 8) {
            Text("=")
                .font(.system(size: 34, weight: .bold, design: .monospaced))
                .foregroundColor(.red.opacity(0.9))
                .frame(width: 24)

            ForEach(0..<width, id: \.self) { column in
                finalCarryCell(column: column)
            }
        }
    }

    @ViewBuilder
    private func finalCarryCell(column: Int) -> some View {
        if column < width - 1 {
            let enabled = isFinalCarryEnabled(at: column)
            let isSelected = selectedRow == finalRowIndex && selectedColumn == column + 1

            TextField(
                "",
                text: Binding(
                    get: { carryDigits[safe: column] ?? "" },
                    set: { newValue in
                        guard enabled else { return }
                        carryDigits[column] = singleDigit(from: newValue)
                        selectedRow = finalRowIndex
                        selectedColumn = column + 1
                    }
                )
            )
#if os(iOS)
            .keyboardType(.numberPad)
#endif
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .font(.system(size: 18, weight: .bold, design: .monospaced))
            .frame(width: 36, height: 28)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(carryBackgroundColor(enabled: enabled, isSelected: isSelected))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(carryBorderColor(enabled: enabled, isSelected: isSelected), lineWidth: 1)
            )
            .disabled(!enabled)
            .onTapGesture {
                guard enabled else { return }
                selectedRow = finalRowIndex
                selectedColumn = column + 1
            }
        } else {
            Color.clear.frame(width: 36, height: 28)
        }
    }

    // MARK: - Final result row

    private var finalResultRow: some View {
        HStack(spacing: 8) {
            Color.clear.frame(width: 24, height: 42)

            ForEach(0..<width, id: \.self) { column in
                finalResultCell(column: column)
            }
        }
    }

    private func finalResultCell(column: Int) -> some View {
        let enabled = isFinalResultCellEnabled(at: column)
        let isSelected = selectedRow == finalRowIndex && selectedColumn == column

        return TextField(
            "",
            text: Binding(
                get: { resultDigits[safe: column] ?? "" },
                set: { newValue in
                    guard enabled else { return }
                    resultDigits[column] = singleDigit(from: newValue)
                    selectedRow = finalRowIndex
                    selectedColumn = column
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
                .fill(inputBackgroundColor(enabled: enabled, isSelected: isSelected))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(inputBorderColor(enabled: enabled, isSelected: isSelected), lineWidth: 1.5)
        )
        .disabled(!enabled)
        .onTapGesture {
            guard enabled else { return }
            selectedRow = finalRowIndex
            selectedColumn = column
        }
    }

    // MARK: - Styling

    private func inputBackgroundColor(enabled: Bool, isSelected: Bool) -> Color {
        if !enabled { return Color.gray.opacity(0.06) }
        if isSelected { return Color.green.opacity(0.22) }
        return Color.gray.opacity(0.10)
    }

    private func inputBorderColor(enabled: Bool, isSelected: Bool) -> Color {
        if !enabled { return Color.gray.opacity(0.18) }
        if isSelected { return .green }
        return Color.gray.opacity(0.3)
    }

    private func carryBackgroundColor(enabled: Bool, isSelected: Bool) -> Color {
        if !enabled { return Color.gray.opacity(0.06) }
        if isSelected { return Color.orange.opacity(0.28) }
        return Color.orange.opacity(0.18)
    }

    private func carryBorderColor(enabled: Bool, isSelected: Bool) -> Color {
        if !enabled { return Color.gray.opacity(0.2) }
        if isSelected { return Color.orange }
        return Color.orange.opacity(0.8)
    }

    // MARK: - Rules

    private func editableBounds(forPartialRow row: Int) -> (start: Int, end: Int)? {
        let rowShift = row
        let availableRightEdge = width - 1 - rowShift
        let topCount = String(left).count
        let startColumn = max(0, availableRightEdge - topCount)

        guard startColumn <= availableRightEdge else { return nil }
        return (startColumn, availableRightEdge)
    }

    private func isPartialCellEnabled(row: Int, column: Int) -> Bool {
        guard let bounds = editableBounds(forPartialRow: row) else { return false }
        guard column >= bounds.start && column <= bounds.end else { return false }
        return !shouldShowShiftZero(row: row, column: column)
    }

    private func shouldShowShiftZero(row: Int, column: Int) -> Bool {
        let rowShift = row
        return rowShift > 0 && column > width - 1 - rowShift
    }

    private func isPartialCarryAvailable(row: Int, column: Int) -> Bool {
        guard let bounds = editableBounds(forPartialRow: row) else { return false }
        return column >= bounds.start && column < bounds.end
    }

    private func isPartialCarryEnabled(row: Int, column: Int) -> Bool {
        guard selectedRow == row, let selectedColumn else { return false }
        return column == selectedColumn - 1 && isPartialCarryAvailable(row: row, column: column)
    }

    private func isFinalResultCellEnabled(at column: Int) -> Bool {
        let partialReady = partialRows.allSatisfy { row in
            row.contains(where: { !$0.isEmpty })
        }
        guard partialReady else { return false }

        if column == width - 1 { return true }

        let rightIndex = column + 1
        guard resultDigits.indices.contains(rightIndex) else { return false }
        return !resultDigits[rightIndex].isEmpty
    }

    private func isFinalCarryEnabled(at column: Int) -> Bool {
        guard selectedRow == finalRowIndex, let selectedColumn else { return false }
        return column == selectedColumn - 1
    }

    // MARK: - Helpers

    private func singleDigit(from text: String) -> String {
        guard let lastDigit = text.last(where: { $0.isNumber }) else {
            return ""
        }
        return String(lastDigit)
    }

    private func padLeft(_ digits: [String], to count: Int) -> [String] {
        Array(repeating: "", count: max(0, count - digits.count)) + digits
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
