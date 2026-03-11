import SwiftUI

struct ChildProfileView: View {
    @EnvironmentObject var profileStore: ProfileStore

    private let avatars = ["🦊", "🐼", "🐸", "🐱", "🦁", "🐵"]
    private let columns = [GridItem(.adaptive(minimum: 60), spacing: 12)]

    var body: some View {
        Form {
            Section("Профиль") {
                TextField("Имя", text: $profileStore.profile.name)

                Stepper("Возраст: \(profileStore.profile.age)", value: $profileStore.profile.age, in: 4...12)
            }

            Section("Аватар") {
                LazyVGrid(columns: columns, spacing: 12) {
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
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.vertical, 8)
            }

            Section("Уровень") {
                Picker("Сложность", selection: $profileStore.profile.selectedLevel) {
                    ForEach(DifficultyLevel.allCases) { level in
                        Text("\(level.emoji) \(level.title)").tag(level)
                    }
                }
            }
        }
        .navigationTitle("Профиль ребёнка")
    }
}
