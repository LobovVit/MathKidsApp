//
//  AppRouter.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import Combine
import Foundation
import SwiftUI

final class AppRouter: ObservableObject {
    @Published var route: AppRoute = .home

    func goHome() {
        route = .home
    }

    func goToOperations() {
        route = .operationSelection
    }

    func goToTraining(_ operation: MathOperation) {
        route = .training(operation: operation)
    }

    func goToProfiles() {
        route = .childProfiles
    }

    func goToParentGate() {
        route = .parentGate
    }

    func goToParentDashboard() {
        route = .parentDashboard
    }

    func goToSettings() {
        route = .settings
    }

    func goToChildProfile() {
        route = .childProfile
    }
}
