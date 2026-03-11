import SwiftUI

struct OperationSelectionView: View {
    @EnvironmentObject var settingsStore: SettingsStore
    @EnvironmentObject var profileStore: ProfileStore

    var body: some View {
        ZStack {
            KidBackgroundView()

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(MathOperation.allCases) { operation in
                        NavigationLink {
                            TrainingView(
                                viewModel: TrainingViewModel(
                                    operation: operation,
                                    settings: settingsStore.settings,
                                    childProfile: profileStore.profile
                                )
                            )
                        } label: {
                            BigMenuCard(
                                emoji: operation.emoji,
                                title: operation.title,
                                subtitle: "Уровень: \(profileStore.profile.selectedLevel.title)"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Выбери тему")
    }
}
