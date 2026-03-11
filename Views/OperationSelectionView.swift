import SwiftUI

struct OperationSelectionView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var profileStore: ProfileStore
    
    var body: some View {
        HStack {
            Button("← Назад") {
                router.goHome()
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(.horizontal)
        ZStack {
            KidBackgroundView()

            VStack(spacing: 16) {
                HStack {
                    Button("← Назад") {
                        router.goHome()
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                }
                .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(MathOperation.allCases) { operation in
                            Button {
                                router.goToTraining(operation)
                            } label: {
                                BigMenuCard(
                                    emoji: operation.emoji,
                                    title: operation.title,
                                    subtitle: "\(profileStore.profile.name) · \(profileStore.profile.selectedLevel.title)"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
