import SwiftUI

struct SimpleBarChartView: View {
    let items: [SimpleBarChartItem]

    private var maxValue: Double {
        max(items.map(\.value).max() ?? 1, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if items.isEmpty {
                Text("Нет данных")
                    .foregroundColor(.secondary)
            } else {
                ForEach(items) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.title)
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Spacer()

                            Text(valueText(item.value))
                                .font(.caption.bold())
                        }

                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.12))
                                    .frame(height: 16)

                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.accentColor)
                                    .frame(
                                        width: barWidth(totalWidth: geo.size.width, value: item.value),
                                        height: 16
                                    )
                            }
                        }
                        .frame(height: 16)
                    }
                }
            }
        }
    }

    private func barWidth(totalWidth: CGFloat, value: Double) -> CGFloat {
        guard maxValue > 0 else { return 0 }
        return totalWidth * CGFloat(value / maxValue)
    }

    private func valueText(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        } else {
            return String(format: "%.1f", value)
        }
    }
}
