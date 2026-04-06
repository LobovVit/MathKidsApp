import Foundation
import Combine

final class AppRouter: ObservableObject {
    @Published var currentRoute: AppRoute = .home

    func goHome() {
        currentRoute = .home
    }

    func goBack() {
        currentRoute = .home
    }

    func goToOperations() {
        currentRoute = .operationSelection
    }

    func goToTraining(_ operation: MathOperation) {
        currentRoute = .training(operation)
    }

    func goToProfiles() {
        currentRoute = .profiles
    }

    func goToChildProfile() {
        currentRoute = .childProfile
    }

    func goToParentGate() {
        currentRoute = .parentGate
    }

    func goToParentDashboard() {
        currentRoute = .parentDashboard
    }

    func goToRewardGamePicker() {
        currentRoute = .rewardGamePicker
    }

    func goToRewardGame() {
        currentRoute = .rewardGame
    }

    func goToRaceGame() {
        currentRoute = .raceGame
    }

    func goToTennisGame() {
        currentRoute = .tennisGame
    }

    func goToBlockGarden() {
        currentRoute = .blockGarden
    }

    func goToSettings() {
        currentRoute = .settings
    }
}
