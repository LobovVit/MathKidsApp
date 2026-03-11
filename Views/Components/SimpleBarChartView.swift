//
//  SimpleBarChartView.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import SwiftUI

struct SimpleBarChartView: View {
    let points: [ProgressPoint]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Прогресс по занятиям")
                .font(.title3.bold())

            HStack(alignment: .bottom, spacing: 10) {
                ForEach(points) { point in
                    VStack(spacing: 8) {
                        Text("\(Int(point.value))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 28, height: max(8, point.value * 1.6))
                        Text(point.label)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 220, alignment: .bottomLeading)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white.opacity(0.72))
        )
    }
}
