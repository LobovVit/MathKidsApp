import SwiftUI

struct OperationSelectionView: View {
    @EnvironmentObject var router: AppRouter
    @EnvironmentObject var profileStore: ProfileStore
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isPhoneLike: Bool { horizontalSizeClass == .compact }

    var body: some View {
        ZStack {
            KidBackgroundView()
            VStack(spacing: isPhoneLike ? 12 : 16) {
                HeaderBackView(title: "Выбери тему")
                ScrollView(showsIndicators: false) {
                    VStack(spacing: isPhoneLike ? 12 : 16) {
                        ForEach(MathOperation.allCases) { operation in
                            Button { router.goToTraining(operation) } label: {
                                BigMenuCard(emoji: operation.emoji, title: operation.title, subtitle: "\(profileStore.profile.name) · \(profileStore.profile.selectedLevel.title)", compact: isPhoneLike)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, isPhoneLike ? 14 : 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
