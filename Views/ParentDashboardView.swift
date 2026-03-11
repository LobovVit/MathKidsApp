import SwiftUI

struct ParentDashboardView: View {
    @EnvironmentObject var statsStore: StatsStore
    @EnvironmentObject var profilesStore: ProfilesStore
    @EnvironmentObject var parentAuthStore: ParentAuthStore
    @StateObject private var viewModel = ParentDashboardViewModel()
    @EnvironmentObject var router: AppRouter

    var body: some View {
        let child = profilesStore.selectedProfile
        let childResults = statsStore.results(for: child.id)
        let points = viewModel.progressPoints(from: childResults)
        HStack {
            Button("← Назад") {
                router.goHome()
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(.horizontal)
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 12) {
                    StatMiniCard(title: "Всего решено", value: "\(statsStore.totalSolved(for: child.id))")
                    StatMiniCard(title: "Точность", value: "\(Int(statsStore.accuracy(for: child.id) * 100))%")
                }

                HStack(spacing: 12) {
                    StatMiniCard(title: "Слабая тема", value: shortWeakTopic(viewModel.weakestOperation(from: childResults)))
                    StatMiniCard(title: "Время занятий", value: viewModel.totalTrainingTime(from: childResults))
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Ребёнок").font(.title3.bold())
                    HStack(spacing: 12) {
                        Text(child.avatar).font(.system(size: 50))
                        VStack(alignment: .leading, spacing: 6) {
                            Text(child.name).font(.headline)
                            Text("Возраст: \(child.age)")
                            Text("Уровень: \(child.selectedLevel.title)")
                        }
                        Spacer()
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white.opacity(0.72)))
                }

                if !points.isEmpty {
                    SimpleBarChartView(points: points)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Последние занятия").font(.title3.bold())
                    ForEach(childResults.prefix(10)) { result in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(result.operation.title).font(.headline)
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
                        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white.opacity(0.72)))
                    }
                }

                Section {
                    NavigationLink {
                        ParentSettingsView()
                    } label: {
                        BigMenuCard(emoji: "🛡️", title: "PIN и защита", subtitle: "Сменить PIN-код и закрыть доступ")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .background(KidBackgroundView())
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
