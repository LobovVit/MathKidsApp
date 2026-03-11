import SwiftUI

struct ChildProfileView: View {
    @EnvironmentObject var profilesStore: ProfilesStore
    let profileID: UUID

    private let avatars = ["🦊", "🐼", "🐸", "🐱", "🦁", "🐵", "🐻", "🐨"]

    var body: some View {
        Form {
            if let binding = bindingForProfile() {
                Section {
                    TextField("Имя", text: binding.name)
                    Stepper("Возраст: \(binding.age.wrappedValue)", value: binding.age, in: 4...12)
                    Picker("Уровень", selection: binding.selectedLevel) {
                        ForEach(DifficultyLevel.allCases) { level in
                            Text("\(level.emoji) \(level.title)").tag(level)
                        }
                    }
                    Toggle("Сделать активным", isOn: Binding(
                        get: { profilesStore.selectedProfileID == profileID },
                        set: { value in if value { profilesStore.selectedProfileID = profileID } }
                    ))
                } header: {
                    Text("Профиль")
                }

                Section {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 12) {
                        ForEach(avatars, id: \.self) { avatar in
                            Button {
                                binding.avatar.wrappedValue = avatar
                            } label: {
                                Text(avatar)
                                    .font(.system(size: 34))
                                    .frame(width: 56, height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(binding.avatar.wrappedValue == avatar ? Color.blue.opacity(0.2) : Color.secondary.opacity(0.08))
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.vertical, 8)
                } header: {
                    Text("Аватар")
                }
            } else {
                Text("Профиль не найден")
            }
        }
        .navigationTitle("Профиль ребёнка")
    }

    private func bindingForProfile() -> (name: Binding<String>, age: Binding<Int>, avatar: Binding<String>, selectedLevel: Binding<DifficultyLevel>)? {
        guard let index = profilesStore.profiles.firstIndex(where: { $0.id == profileID }) else { return nil }
        return (
            name: $profilesStore.profiles[index].name,
            age: $profilesStore.profiles[index].age,
            avatar: $profilesStore.profiles[index].avatar,
            selectedLevel: $profilesStore.profiles[index].selectedLevel
        )
    }
}
