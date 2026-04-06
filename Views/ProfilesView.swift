import SwiftUI

struct ProfilesView: View {
    @EnvironmentObject private var profilesStore: ProfileStore
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 16) {
                HeaderBackView(title: "Профили детей").padding(26)

                Button {
                    profilesStore.addProfile()
                    router.goToChildProfile()
                } label: {
                    Label("Добавить профиль ребёнка", systemImage: "plus.circle.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.horizontal)

                List {
                    ForEach(profilesStore.profiles) { profile in
                        Button {
                            profilesStore.selectProfile(profile)
                            router.goToChildProfile()
                        } label: {
                            HStack {
                                Text(profile.avatar)
                                    .font(.system(size: 34))
                                VStack(alignment: .leading) {
                                    Text(profile.name)
                                        .font(.headline)
                                    Text("Возраст: \(profile.age) · \(profile.selectedLevel.title)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                if profilesStore.selectedProfileID == profile.id {
                                    Text("Активный")
                                        .font(.caption)
                                        .padding(6)
                                        .background(Capsule().fill(Color.blue.opacity(0.15)))
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .profileDeleteActions {
                            profilesStore.deleteProfile(profile)
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .padding(.vertical, 8)
        }
        .navigationBarBackButtonHidden(true)
    }
}

private extension View {
    @ViewBuilder
    func profileDeleteActions(_ action: @escaping () -> Void) -> some View {
        if #available(iOS 15.0, *) {
            swipeActions {
                Button(role: .destructive, action: action) {
                    Label("Удалить", systemImage: "trash")
                }
            }
        } else {
            contextMenu {
                Button(action: action) {
                    Label("Удалить", systemImage: "trash")
                }
            }
        }
    }
}
