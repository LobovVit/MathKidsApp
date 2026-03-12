import Foundation
import Combine

final class AppRouter: ObservableObject {
    @Published var route: AppRoute = .home

    func goHome() { route = .home }
    func goToOperations() { route = .operationSelection }
    func goToTraining(_ operation: MathOperation) { route = .training(operation) }
    func goToProfiles() { route = .profiles }
    func goToChildProfile() { route = .childProfile }
    func goToParentGate() { route = .parentGate }
    func goToParentDashboard() { route = .parentDashboard }
    func goToRewardGamePicker() { route = .rewardGamePicker }
    func goToRewardGame() { route = .rewardGame }
    func goToRaceGame() { route = .raceGame }
    func goToSettings() { route = .settings }
}
