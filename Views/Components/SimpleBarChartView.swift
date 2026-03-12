import SwiftUI

struct SimpleBarChartItem: Identifiable { let id = UUID(); let title: String; let value: Double }

struct SimpleBarChartView: View { let items: [SimpleBarChartItem]; let maxValue: Double; var body: some View { VStack(alignment: .leading, spacing: 12) { ForEach(items) { item in VStack(alignment: .leading, spacing: 6) { HStack { Text(item.title).font(.subheadline); Spacer(); Text("\(Int(item.value))%").font(.subheadline.bold()) }; GeometryReader { geo in ZStack(alignment: .leading) { RoundedRectangle(cornerRadius: 8).fill(Color.secondary.opacity(0.12)).frame(height: 22); RoundedRectangle(cornerRadius: 8).fill(Color.accentColor.opacity(0.8)).frame(width: barWidth(totalWidth: geo.size.width, value: item.value), height: 22) } }.frame(height: 22) } } } }; private func barWidth(totalWidth: CGFloat, value: Double) -> CGFloat { guard maxValue > 0 else { return 0 }; return totalWidth * CGFloat(value / maxValue) } }
