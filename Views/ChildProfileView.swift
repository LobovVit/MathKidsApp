import SwiftUI

struct ChildProfileView: View {
    @EnvironmentObject private var profileStore: ProfileStore
    private let avatars = ["🦊", "🐼", "🐸", "🐱", "🦁", "🐵"]

    var body: some View {
        ZStack {
            KidBackgroundView()

            VStack(spacing: 14) {
                HeaderBackView(title: "Профиль ребёнка")

                Form {
                    Section("Профиль") {
                        TextField("Имя", text: nameBinding)

                        Stepper(
                            "Возраст: \(profileStore.profile.age)",
                            value: ageBinding,
                            in: 4...12
                        )
                    }

                    Section("Аватар") {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                            ForEach(avatars, id: \.self) { avatar in
                                Button {
                                    profileStore.profile.avatar = avatar
                                } label: {
                                    Text(avatar)
                                        .font(.system(size: 34))
                                        .frame(width: 56, height: 56)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(profileStore.profile.avatar == avatar ? Color.blue.opacity(0.2) : Color.secondary.opacity(0.08))
                                        )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 8)
                    }

                    Section("Уровень") {
                        Picker("Сложность", selection: levelBinding) {
                            ForEach(DifficultyLevel.allCases) { level in
                                Text("\(level.emoji) \(level.title)")
                                    .tag(level)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
        }
    }

    private var nameBinding: Binding<String> {
        Binding(
            get: { profileStore.profile.name },
            set: { profileStore.profile.name = $0 }
        )
    }

    private var ageBinding: Binding<Int> {
        Binding(
            get: { profileStore.profile.age },
            set: { profileStore.profile.age = $0 }
        )
    }

    private var levelBinding: Binding<DifficultyLevel> {
        Binding(
            get: { profileStore.profile.selectedLevel },
            set: { profileStore.profile.selectedLevel = $0 }
        )
    }
}
