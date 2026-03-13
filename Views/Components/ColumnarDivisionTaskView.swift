import SwiftUI

struct ColumnarDivisionTaskView: View {
    let dividend: Int
    let divisor: Int
    @Binding var mode: DivisionTrainingMode

    @Binding var quotientDigits: [String]
    @Binding var productRows: [[String]]
    @Binding var remainderRows: [[String]]
    @Binding var bringDownRows: [[String]]
    @Binding var selectedRow: Int?
    @Binding var selectedColumn: Int?

    private var dividendDigits: [String] {
        String(dividend).map { String($0) }
    }

    private var divisorDigits: [String] {
        String(divisor).map { String($0) }
    }

    private var quotientWidth: Int {
        max(1, quotientDigits.count)
    }

    private var bodyWidth: CGFloat {
        CGFloat(max(dividendDigits.count + 3, quotientWidth + divisorDigits.count + 2)) * 30
    }

    var body: some View {
        VStack(spacing: 14) {
            Picker("Режим деления", selection: $mode) {
                ForEach(DivisionTrainingMode.allCases) { item in
                    Text(item.title).tag(item)
                }
            }
            .pickerStyle(.segmented)

            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.9))

                VStack(alignment: .leading, spacing: 10) {
                    divisionHeader

                    switch mode {
                    case .resultOnly:
                        Text("Введи только частное")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.top, 8)

                    case .steps:
                        stepsBlock(showBringDown: false)

                    case .full:
                        stepsBlock(showBringDown: true)
                    }
                }
                .padding(20)
            }
            .frame(maxWidth: 460)
        }
        .padding(.horizontal)
    }

    // MARK: - Header

    private var divisionHeader: some View {
        HStack(alignment: .top, spacing: 0) {
            // Делимое слева
            HStack(spacing: 4) {
                ForEach(0..<dividendDigits.count, id: \.self) { index in
                    Text(dividendDigits[index])
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .frame(width: 26, height: 34)
                }
            }

            ZStack(alignment: .topLeading) {
                // Скобка деления
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle()
                        .fill(Color.primary)
                        .frame(width: 2, height: 40)

                    Rectangle()
                        .fill(Color.primary)
                        .frame(
                            width: CGFloat(max(divisorDigits.count, quotientWidth)) * 30 + 18,
                            height: 2
                        )
                }
                .offset(x: 0, y: 20)

                VStack(alignment: .leading, spacing: 6) {
                    // сверху справа — делитель
                    HStack(spacing: 4) {
                        Color.clear.frame(width: 10, height: 1)

                        ForEach(0..<divisorDigits.count, id: \.self) { index in
                            Text(divisorDigits[index])
                                .font(.system(size: 30, weight: .bold, design: .monospaced))
                                .frame(width: 26, height: 34)
                        }
                    }

                    // ниже — частное
                    HStack(spacing: 4) {
                        Color.clear.frame(width: 18, height: 1)

                        ForEach(0..<quotientWidth, id: \.self) { index in
                            quotientCell(index: index)
                        }
                    }
                }
            }
            .padding(.leading, 8)
        }
    }

    private func quotientCell(index: Int) -> some View {
        let isSelected = selectedRow == -1 && selectedColumn == index

        return TextField(
            "",
            text: Binding(
                get: { quotientDigits[safe: index] ?? "" },
                set: { newValue in
                    guard quotientDigits.indices.contains(index) else { return }
                    quotientDigits[index] = singleDigit(from: newValue)
                    selectedRow = -1
                    selectedColumn = index
                }
            )
        )
        #if os(iOS)
        .keyboardType(.numberPad)
        #endif
        .textFieldStyle(.plain)
        .multilineTextAlignment(.center)
        .font(.system(size: 28, weight: .bold, design: .monospaced))
        .frame(width: 26, height: 32)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected ? Color.green.opacity(0.22) : Color.gray.opacity(0.10))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(isSelected ? Color.green : Color.gray.opacity(0.3), lineWidth: 1)
        )
        .onTapGesture {
            selectedRow = -1
            selectedColumn = index
        }
    }

    // MARK: - Work area

    private func stepsBlock(showBringDown: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(0..<productRows.count, id: \.self) { step in
                if showBringDown && step < bringDownRows.count {
                    gridRow(
                        cells: bringDownRows[step],
                        rowIndex: step * 3,
                        color: .secondary
                    )
                }

                gridRow(
                    cells: productRows[step],
                    rowIndex: step * 3 + 1,
                    color: .primary
                )

                gridRow(
                    cells: remainderRows[step],
                    rowIndex: step * 3 + 2,
                    color: .green
                )
            }
        }
        .frame(width: bodyWidth, alignment: .leading)
    }

    private func gridRow(cells: [String], rowIndex: Int, color: Color) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<max(dividendDigits.count, cells.count), id: \.self) { col in
                editableCell(
                    value: cells[safe: col] ?? "",
                    rowIndex: rowIndex,
                    col: col,
                    color: color
                )
            }
        }
    }

    private func editableCell(value: String, rowIndex: Int, col: Int, color: Color) -> some View {
        let isSelected = selectedRow == rowIndex && selectedColumn == col

        return TextField(
            "",
            text: Binding(
                get: { value },
                set: { newValue in
                    updateGrid(rowIndex: rowIndex, col: col, value: singleDigit(from: newValue))
                    selectedRow = rowIndex
                    selectedColumn = col
                }
            )
        )
        #if os(iOS)
        .keyboardType(.numberPad)
        #endif
        .textFieldStyle(.plain)
        .multilineTextAlignment(.center)
        .font(.system(size: 26, weight: .bold, design: .monospaced))
        .frame(width: 26, height: 30)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isSelected ? color.opacity(0.18) : Color.gray.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(isSelected ? color : Color.gray.opacity(0.2), lineWidth: 1)
        )
        .foregroundColor(color)
        .onTapGesture {
            selectedRow = rowIndex
            selectedColumn = col
        }
    }

    // MARK: - Grid update

    private func updateGrid(rowIndex: Int, col: Int, value: String) {
        let block = rowIndex / 3
        let kind = rowIndex % 3

        if kind == 0 {
            if bringDownRows.indices.contains(block), bringDownRows[block].indices.contains(col) {
                bringDownRows[block][col] = value
            }
        } else if kind == 1 {
            if productRows.indices.contains(block), productRows[block].indices.contains(col) {
                productRows[block][col] = value
            }
        } else {
            if remainderRows.indices.contains(block), remainderRows[block].indices.contains(col) {
                remainderRows[block][col] = value
            }
        }
    }

    // MARK: - Helpers

    private func singleDigit(from text: String) -> String {
        guard let lastDigit = text.last(where: { $0.isNumber }) else {
            return ""
        }
        return String(lastDigit)
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
