import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var profileStore: ProfileStore

    @ViewBuilder
    private var currentScreen: some View {
        switch router.route {
        case .home:
            HomeView()
        case .operationSelection:
            OperationSelectionView()
        case .training(let operation):
            TrainingView(
                viewModel: TrainingViewModel(
                    operation: operation,
                    settings: settingsStore.settings,
                    childProfile: profileStore.profile
                )
            )
        case .profiles:
            ProfilesView()
        case .childProfile:
            ChildProfileView()
        case .parentGate:
            ParentPinGateView()
        case .parentDashboard:
            ParentDashboardView()
        case .rewardGamePicker:
            RewardGamePickerView()
        case .rewardGame:
            RewardGameView()
        case .raceGame:
            RaceGameView()
        case .tennisGame:
            TennisGameView()
        case .settings:
            SettingsView()
        }
    }

    var body: some View {
        currentScreen
            .frame(minWidth: 320, minHeight: 480)
            .onAppear {
                settingsStore.loadFromICloudIfNeeded()
            }
    }
}
