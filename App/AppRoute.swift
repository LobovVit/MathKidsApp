//
//  AppRoute.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import Foundation

enum AppRoute: Equatable {
    case home
    case operationSelection
    case training(operation: MathOperation)
    case childProfiles
    case parentGate
    case parentDashboard
    case settings
    case childProfile
}

