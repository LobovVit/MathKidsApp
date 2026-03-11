import SwiftUI

struct ParentDashboardView: View {
    @EnvironmentObject var statsStore: StatsStore
    @EnvironmentObject var profileStore: ProfileStore
    @StateObject private var viewModel = ParentDashboardViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    StatMiniCard(title: "Всего решено", value: "\(statsStore.totalSolved())")
                    StatMiniCard(title: "Точность", value: "\(Int(statsStore.accuracy() * 100))%")
                }

                HStack(spacing: 12) {
                    StatMiniCard(
                        title: "Слабая тема",
                        value: shortWeakTopic(viewModel.weakestOperation(from: statsStore.results))
                    )

                    StatMiniCard(
                        title: "Время занятий",
                        value: viewModel.totalTrainingTime(from: statsStore.results)
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Ребёнок")
                        .font(.title3.bold())

                    HStack(spacing: 12) {
                        Text(profileStore.profile.avatar)
                            .font(.system(size: 50))

                        VStack(alignment: .leading, spacing: 6) {
                            Text(profileStore.profile.name)
                                .font(.headline)
                            Text("Возраст: \(profileStore.profile.age)")
                            Text("Уровень: \(profileStore.profile.selectedLevel.title)")
                        }

                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.secondary.opacity(0.10))
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Последние занятия")
                        .font(.title3.bold())

                    if statsStore.results.isEmpty {
                        Text("Пока нет занятий")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(Array(statsStore.results.prefix(10))) { result in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(result.operation.title)
                                        .font(.headline)
                                    Spacer()
                                    Text("\(Int(result.accuracy * 100))%")
                                        .font(.headline)
                                }

                                Text("Уровень: \(result.difficulty.title)")
                                    .foregroundColor(.secondary)

                                Text("Серия: \(result.bestStreak) 🔥")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.secondary.opacity(0.08))
                            )
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Родительский экран")
    }

    private func shortWeakTopic(_ text: String) -> String {
        switch text {
        case "Сложение": return "➕"
        case "Вычитание": return "➖"
        case "Умножение": return "✖️"
        case "Деление": return "➗"
        default: return "—"
        }
    }
}
