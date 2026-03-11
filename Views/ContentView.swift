import SwiftUI

struct ContentView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var profileStore: ProfileStore

    var body: some View {
        ZStack {
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

            case .childProfiles:
                ProfilesView()

            case .parentGate:
                ParentGateView()

            case .parentDashboard:
                ParentDashboardView()

            case .settings:
                SettingsView()

            case .childProfile:
                ChildProfileView(profileID: profileStore.selectedProfileID)
            }
        }
        .frame(minWidth: 900, minHeight: 650)
    }
}
