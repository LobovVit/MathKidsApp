import SwiftUI

struct ParentDashboardView: View {
    @EnvironmentObject private var statsStore: StatsStore
    @EnvironmentObject private var profileStore: ProfileStore
    @EnvironmentObject private var authStore: ParentAuthStore
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = ParentDashboardViewModel()
    @State private var newPin = ""

    var body: some View {
        let childResults = statsStore.results(for: profileStore.selectedProfileID)
        let chartItems = viewModel.chartItems(from: childResults)

        return ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.08)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HeaderBackView(title: "Родительский экран")

                    HStack(spacing: 12) {
                        StatMiniCard(title: "Всего решено", value: "\(statsStore.totalSolved(for: profileStore.selectedProfileID))")
                        StatMiniCard(title: "Точность", value: "\(Int(statsStore.accuracy(for: profileStore.selectedProfileID) * 100))%")
                    }

                    HStack(spacing: 12) {
                        StatMiniCard(title: "Слабая тема", value: shortWeakTopic(viewModel.weakestOperation(from: childResults)))
                        StatMiniCard(title: "Общее время", value: viewModel.totalTrainingTime(from: childResults))
                    }

                    HStack(spacing: 12) {
                        StatMiniCard(title: "Среднее занятие", value: viewModel.averageTrainingTime(from: childResults))
                        StatMiniCard(title: "Последнее занятие", value: viewModel.lastTrainingTime(from: childResults))
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("График прогресса")
                            .font(.title3.bold())
                        SimpleBarChartView(
                            items: chartItems,
                            maxValue: max(chartItems.map({ $0.value }).max() ?? 100, 100)
                        )
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.78)))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Сменить PIN")
                            .font(.title3.bold())
                        HStack {
                            SecureField("Новый PIN", text: $newPin)
                                .textFieldStyle(.roundedBorder)
                            Button("Сохранить") {
                                authStore.updatePin(to: newPin)
                                newPin = ""
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.78)))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Последние занятия")
                            .font(.title3.bold())

                        ForEach(childResults.prefix(10)) { result in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(result.operation.title).font(.headline)
                                    Spacer()
                                    Text("\(Int(result.accuracy * 100))%").font(.headline)
                                }
                                Text("Уровень: \(result.difficulty.title)").foregroundColor(.secondary)
                                Text("Серия: \(result.bestStreak) 🔥").foregroundColor(.secondary)
                                Text("Время: \(formatDuration(result.duration))").foregroundColor(.secondary)
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.78)))
                        }
                    }

                    Button("Заблокировать экран") {
                        authStore.lock()
                        router.goHome()
                    }
                    .buttonStyle(.bordered)
                }
                .frame(maxWidth: 920)
                .padding(.horizontal, 12)
                .padding(.vertical, 16)
            }
        }
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

    private func formatDuration(_ duration: TimeInterval) -> String {
        let totalSeconds = Int(duration)
        if totalSeconds < 60 {
            return "\(totalSeconds) сек"
        }
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        if seconds == 0 {
            return "\(minutes) мин"
        } else {
            return "\(minutes) мин \(seconds) сек"
        }
    }
}
