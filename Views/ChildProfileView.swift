import SwiftUI

struct ChildProfileView: View {
    @EnvironmentObject private var profileStore: ProfileStore
    let profileID: UUID

    private let avatars = ["🦊", "🐼", "🐸", "🐱", "🦁", "🐵", "🐻", "🐨"]

    var body: some View {
        VStack(spacing: 12) {
            HeaderBackView(title: "Профиль ребёнка")

            Form {
                if let binding = bindingForProfile() {
                    Section(header: Text("Профиль")) {
                        TextField("Имя", text: binding.name)

                        Stepper(
                            "Возраст: \(binding.age.wrappedValue)",
                            value: binding.age,
                            in: 4...12
                        )

                        Picker("Уровень", selection: binding.selectedLevel) {
                            ForEach(DifficultyLevel.allCases) { level in
                                Text("\(level.emoji) \(level.title)").tag(level)
                            }
                        }
                        .pickerStyle(.menu)

                        Picker("Режим ответа", selection: binding.answerMode) {
                            ForEach(AnswerMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)

                        Toggle("Только целочисленное деление", isOn: binding.divisionOnlyIntegers)
                        Toggle("Разрешить отрицательное вычитание", isOn: binding.allowNegativeSubtraction)

                        Toggle(
                            "Сделать активным",
                            isOn: Binding(
                                get: { profileStore.selectedProfileID == profileID },
                                set: { value in
                                    if value { profileStore.selectedProfileID = profileID }
                                }
                            )
                        )

                        Text("Баланс игр: \(profileStore.profiles.first(where: { $0.id == profileID })?.formattedPlayTime ?? "00:00")")
                            .foregroundColor(.secondary)
                    }

                    Section(header: Text("Аватар")) {
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
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                } else {
                    Text("Профиль не найден")
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func bindingForProfile() -> (
        name: Binding<String>,
        age: Binding<Int>,
        avatar: Binding<String>,
        selectedLevel: Binding<DifficultyLevel>,
        answerMode: Binding<AnswerMode>,
        divisionOnlyIntegers: Binding<Bool>,
        allowNegativeSubtraction: Binding<Bool>
    )? {
        guard let index = profileStore.profiles.firstIndex(where: { $0.id == profileID }) else { return nil }

        return (
            name: $profileStore.profiles[index].name,
            age: $profileStore.profiles[index].age,
            avatar: $profileStore.profiles[index].avatar,
            selectedLevel: $profileStore.profiles[index].selectedLevel,
            answerMode: $profileStore.profiles[index].answerMode,
            divisionOnlyIntegers: $profileStore.profiles[index].divisionOnlyIntegers,
            allowNegativeSubtraction: $profileStore.profiles[index].allowNegativeSubtraction
        )
    }
}
