import SwiftUI

struct HomeView: View {
    @EnvironmentObject var profileStore: ProfileStore

    var body: some View {
        NavigationView {
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

                        NavigationLink {
                            OperationSelectionView()
                        } label: {
                            BigMenuCard(
                                emoji: "🎓",
                                title: "Начать занятие",
                                subtitle: "Решай примеры и получай звёзды"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink {
                            ParentDashboardView()
                        } label: {
                            BigMenuCard(
                                emoji: "👨‍👩‍👧",
                                title: "Родительский экран",
                                subtitle: "Прогресс, слабые темы, история"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink {
                            ChildProfileView()
                        } label: {
                            BigMenuCard(
                                emoji: "🧒",
                                title: "Профиль ребёнка",
                                subtitle: "Имя, аватар и уровень"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())

                        NavigationLink {
                            SettingsView()
                        } label: {
                            BigMenuCard(
                                emoji: "⚙️",
                                title: "Настройки",
                                subtitle: "Звуки, ответы, поведение приложения"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                }
            }
            .navigationTitle("Математика")
        }
        #if os(iOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #endif
    }
}
