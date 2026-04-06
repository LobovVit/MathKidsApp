import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var settingsStore: SettingsStore
    @EnvironmentObject private var profileStore: ProfileStore

    var body: some View {
        ZStack {
            switch router.currentRoute {
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
                if let profileID = profileStore.selectedProfileID {
                    ChildProfileView(profileID: profileID)
                } else {
                    ProfilesView()
                }

            case .parentGate:
                ParentGateView()

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

            case .blockGarden:
                GameView()

            case .settings:
                SettingsView()
            }
        }
    }
}
