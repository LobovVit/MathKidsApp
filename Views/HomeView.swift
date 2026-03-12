import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject var router: AppRouter
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isPhoneLike: Bool { horizontalSizeClass == .compact }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                KidBackgroundView()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: isPhoneLike ? 12 : 18) {
                        VStack(spacing: isPhoneLike ? 8 : 12) {
                            Text(profileStore.profile.avatar)
                                .font(.system(size: isPhoneLike ? 54 : 64))
                            Text("Привет, \(profileStore.profile.name)!")
                                .font(isPhoneLike ? .system(size: 28, weight: .bold) : .largeTitle.bold())
                                .multilineTextAlignment(.center)
                                .minimumScaleFactor(0.8)
                            LevelBadgeView(level: profileStore.profile.selectedLevel)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, isPhoneLike ? 8 : 18)

                        Button { router.goToOperations() } label: {
                            BigMenuCard(emoji: "🎓", title: "Начать занятие", subtitle: "Решай примеры и получай звёзды", compact: isPhoneLike)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button { router.goToProfiles() } label: {
                            BigMenuCard(emoji: "👧", title: "Профили детей", subtitle: "Несколько детей в одном приложении", compact: isPhoneLike)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button { router.goToParentGate() } label: {
                            BigMenuCard(emoji: "🔐", title: "Родительский экран", subtitle: "PIN-код, графики и аналитика", compact: isPhoneLike)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Button { router.goToSettings() } label: {
                            BigMenuCard(emoji: "⚙️", title: "Настройки", subtitle: "Звуки, ответы и iCloud sync", compact: isPhoneLike)
                        }
                        .buttonStyle(PlainButtonStyle())

                        Spacer(minLength: 24)
                    }
                    .padding(.horizontal, isPhoneLike ? 14 : 20)
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity, minHeight: geo.size.height, alignment: .top)
                }
            }
        }
    }
}
