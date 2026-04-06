//
//  SimpleBarChartModels.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 13.03.2026.
//

import Foundation

struct ProgressPoint: Identifiable, Hashable {
    let id = UUID()
    let label: String
    let value: Double

    init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
}

struct SimpleBarChartItem: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let value: Double

    init(title: String, value: Double) {
        self.title = title
        self.value = value
    }
}
