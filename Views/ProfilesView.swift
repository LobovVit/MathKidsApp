import SwiftUI

struct ProfilesView: View {
    @EnvironmentObject var profileStore: ProfileStore
    @EnvironmentObject var router: AppRouter
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    private var isPhoneLike: Bool { horizontalSizeClass == .compact }

    var body: some View {
        ZStack {
            KidBackgroundView()
            VStack(spacing: isPhoneLike ? 12 : 16) {
                HeaderBackView(title: "Профили детей")
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        ForEach(profileStore.profiles) { profile in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack(spacing: isPhoneLike ? 12 : 16) {
                                    Text(profile.avatar).font(.system(size: isPhoneLike ? 34 : 42))
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(profile.name).font(.headline)
                                        Text("Возраст: \(profile.age)").foregroundColor(.secondary)
                                        Text("Уровень: \(profile.selectedLevel.title)").foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                HStack {
                                    if profile.id == profileStore.selectedProfileID {
                                        Text("Активный")
                                            .font(.caption.bold())
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 6)
                                            .background(Capsule().fill(Color.green.opacity(0.2)))
                                    }
                                    Spacer()
                                    Button("Выбрать") { profileStore.selectProfile(profile) }.buttonStyle(.bordered)
                                    Button("Удалить", role: .destructive) { profileStore.deleteProfile(profile) }.buttonStyle(.bordered)
                                }
                            }
                            .padding(isPhoneLike ? 14 : 18)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.84)))
                        }
                        Button { profileStore.addProfile() } label: { Label("Добавить профиль", systemImage: "plus.circle.fill").font(.headline) }
                            .buttonStyle(.borderedProminent)
                        Button("Редактировать активный профиль") { router.goToChildProfile() }
                            .buttonStyle(.bordered)
                    }
                    .padding(.horizontal, isPhoneLike ? 14 : 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}
