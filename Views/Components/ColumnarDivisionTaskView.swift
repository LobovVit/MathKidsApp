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

    private let cellSize = CGSize(width: 26, height: 30)
    private let quotientSize = CGSize(width: 26, height: 32)

    private var dividendDigits: [String] { String(dividend).map { String($0) } }
    private var divisorDigits: [String] { String(divisor).map { String($0) } }
    private var quotientWidth: Int { max(1, quotientDigits.count) }
    private var bodyWidth: CGFloat { CGFloat(max(dividendDigits.count + 3, quotientWidth + divisorDigits.count + 2)) * 30 }

    private var dividendIndexList: [Int] { Array(0..<dividendDigits.count) }
    private var divisorIndexList: [Int] { Array(0..<divisorDigits.count) }
    private var quotientIndexList: [Int] { Array(0..<quotientWidth) }

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

            ColumnarKeypadView(
                digitAction: insertDigit,
                deleteAction: deleteDigit,
                clearAction: clearAll
            )
        }
        .padding(.horizontal)
        .onAppear {
            if selectedRow == nil { selectedRow = -1 }
            if selectedColumn == nil { selectedColumn = max(0, quotientWidth - 1) }
        }
    }

    private var divisionHeader: some View {
        HStack(alignment: .top, spacing: 0) {
            HStack(spacing: 4) {
                ForEach(dividendIndexList, id: \.self) { index in
                    Text(dividendDigits[index])
                        .font(.system(size: 32, weight: .bold, design: .monospaced))
                        .frame(width: 26, height: 34)
                }
            }

            ZStack(alignment: .topLeading) {
                VStack(alignment: .leading, spacing: 0) {
                    Rectangle().fill(Color.primary).frame(width: 2, height: 40)
                    Rectangle().fill(Color.primary)
                        .frame(width: CGFloat(max(divisorDigits.count, quotientWidth)) * 30 + 18, height: 2)
                }
                .offset(x: 0, y: 20)

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 4) {
                        Color.clear.frame(width: 10, height: 1)
                        ForEach(divisorIndexList, id: \.self) { index in
                            Text(divisorDigits[index])
                                .font(.system(size: 30, weight: .bold, design: .monospaced))
                                .frame(width: 26, height: 34)
                        }
                    }

                    HStack(spacing: 4) {
                        Color.clear.frame(width: 18, height: 1)
                        ForEach(quotientIndexList, id: \.self) { index in
                            quotientCell(index: index)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .padding(.leading, 8)
        }
    }

    private func quotientCell(index: Int) -> some View {
        let focused = selectedRow == -1 && selectedColumn == index
        let style: MathCellStyle = focused ? .selected : .normal

        return cellButton(
            value: quotientValue(index),
            style: style,
            width: quotientSize.width,
            height: quotientSize.height,
            fontSize: 28
        ) {
            selectedRow = -1
            selectedColumn = index
        }
    }

    private func stepsBlock(showBringDown: Bool) -> some View {
        let stepList = Array(0..<productRows.count)

        return VStack(alignment: .leading, spacing: 4) {
            ForEach(stepList, id: \.self) { step in
                if showBringDown && step < bringDownRows.count {
                    gridRow(values: bringDownRows[step], rowIndex: step * 3, color: .secondary)
                }
                gridRow(values: productRows[step], rowIndex: step * 3 + 1, color: .primary)
                gridRow(values: remainderRows[step], rowIndex: step * 3 + 2, color: .green)
            }
        }
        .frame(width: bodyWidth, alignment: .leading)
    }

    private func gridRow(values: [String], rowIndex: Int, color: Color) -> some View {
        let columnList = Array(0..<max(dividendDigits.count, values.count))

        return HStack(spacing: 4) {
            ForEach(columnList, id: \.self) { col in
                let focused = selectedRow == rowIndex && selectedColumn == col
                let style: MathCellStyle = focused ? .selected : .normal
                cellButton(
                    value: valueForGrid(rowIndex: rowIndex, column: col),
                    style: style,
                    width: cellSize.width,
                    height: cellSize.height,
                    fontSize: 26
                ) {
                    selectedRow = rowIndex
                    selectedColumn = col
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
        guard let row = selectedRow, let col = selectedColumn else { return }
        if row == -1 {
            guard quotientDigits.indices.contains(col) else { return }
            quotientDigits[col] = digit
            return
        }
        setGridValue(rowIndex: row, column: col, value: digit)
    }

    private func deleteDigit() {
        guard let row = selectedRow, let col = selectedColumn else { return }
        if row == -1 {
            guard quotientDigits.indices.contains(col) else { return }
            quotientDigits[col] = ""
            return
        }
        setGridValue(rowIndex: row, column: col, value: "")
    }

    private func clearAll() {
        for i in quotientDigits.indices { quotientDigits[i] = "" }
        for r in productRows.indices { for c in productRows[r].indices { productRows[r][c] = "" } }
        for r in remainderRows.indices { for c in remainderRows[r].indices { remainderRows[r][c] = "" } }
        for r in bringDownRows.indices { for c in bringDownRows[r].indices { bringDownRows[r][c] = "" } }
    }

    private func quotientValue(_ index: Int) -> String {
        quotientDigits.indices.contains(index) ? quotientDigits[index] : ""
    }

    private func valueForGrid(rowIndex: Int, column: Int) -> String {
        let block = rowIndex / 3
        let kind = rowIndex % 3
        switch kind {
        case 0:
            return (bringDownRows.indices.contains(block) && bringDownRows[block].indices.contains(column)) ? bringDownRows[block][column] : ""
        case 1:
            return (productRows.indices.contains(block) && productRows[block].indices.contains(column)) ? productRows[block][column] : ""
        default:
            return (remainderRows.indices.contains(block) && remainderRows[block].indices.contains(column)) ? remainderRows[block][column] : ""
        }
    }

    private func setGridValue(rowIndex: Int, column: Int, value: String) {
        let block = rowIndex / 3
        let kind = rowIndex % 3

        switch kind {
        case 0:
            if bringDownRows.indices.contains(block), bringDownRows[block].indices.contains(column) {
                bringDownRows[block][column] = value
            }
        case 1:
            if productRows.indices.contains(block), productRows[block].indices.contains(column) {
                productRows[block][column] = value
            }
        default:
            if remainderRows.indices.contains(block), remainderRows[block].indices.contains(column) {
                remainderRows[block][column] = value
            }
        }
    }
}
