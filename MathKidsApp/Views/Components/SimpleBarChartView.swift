import SwiftUI

struct SimpleBarChartView: View {
    let points: [ProgressPoint]

    private var maxValue: Double {
        max(points.map(\.value).max() ?? 0, 1)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Прогресс")
                .font(.title3.bold())

            HStack(alignment: .bottom, spacing: 12) {
                ForEach(points) { point in
                    VStack(spacing: 8) {
                        Text("\(Int(point.value))")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)

                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.75), Color.green.opacity(0.7)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(height: max(CGFloat(point.value / maxValue) * 140, 10))

                        Text(point.label)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .bottom)
                }
            }
            .frame(height: 200, alignment: .bottom)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.72)))
    }
}

