import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject var router: AppRouter

    var body: some View {
        ZStack {
            KidBackgroundView()

            ScrollView {
                VStack(spacing: 16) {
                    VStack(spacing: 10) {
                        Text(profileStore.profile.avatar)
                            .font(.system(size: 64))

                        Text("Привет, \(profileStore.profile.name)!")
                            .font(.largeTitle.bold())

                        LevelBadgeView(level: profileStore.profile.selectedLevel)
                    }
                    .padding(.top, 12)

                    Button {
                        router.goToOperations()
                    } label: {
                        BigMenuCard(
                            emoji: "🎓",
                            title: "Начать занятие",
                            subtitle: "Решай примеры и получай звёзды"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button {
                        router.goToChildProfile()
                    } label: {
                        BigMenuCard(
                            emoji: "🧒",
                            title: "Профиль ребёнка",
                            subtitle: "Имя, аватар и уровень"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button {
                        router.goToParentGate()
                    } label: {
                        BigMenuCard(
                            emoji: "🔐",
                            title: "Родительский экран",
                            subtitle: "PIN-код, графики и аналитика"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button {
                        router.goToSettings()
                    } label: {
                        BigMenuCard(
                            emoji: "⚙️",
                            title: "Настройки",
                            subtitle: "Звуки, ответы и iCloud sync"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
            }
        }
    }
}
