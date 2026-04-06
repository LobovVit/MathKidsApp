import SwiftUI

struct ParentDashboardView: View {
    @EnvironmentObject private var profileStore: ProfileStore
    @EnvironmentObject private var statsStore: StatsStore
    @EnvironmentObject private var router: AppRouter

    @State private var showPinSettings = false

    private var selectedChildName: String {
        profileStore.profile.name
    }

    private var resultsForSelectedChild: [SessionResult] {
        statsStore.results.filter { $0.childID == profileStore.profile.id }
    }

    private var totalSessions: Int {
        resultsForSelectedChild.count
    }

    private var totalCorrect: Int {
        resultsForSelectedChild.reduce(0) { $0 + $1.correctAnswers }
    }

    private var totalQuestions: Int {
        resultsForSelectedChild.reduce(0) { $0 + $1.totalQuestions }
    }

    private var accuracyText: String {
        guard totalQuestions > 0 else { return "—" }
        let value = Int((Double(totalCorrect) / Double(totalQuestions)) * 100)
        return "\(value)%"
    }

    var body: some View {
        ZStack {
            KidBackgroundView()

            ScrollView {
                VStack(spacing: 18) {
                    HeaderBackView(title: "Родительский экран").padding(26)

                    VStack(spacing: 16) {
                        dashboardCard(
                            title: "Ребёнок",
                            rows: [
                                ("Имя", selectedChildName)
                            ]
                        )

                        dashboardCard(
                            title: "Статистика",
                            rows: [
                                ("Занятий", "\(totalSessions)"),
                                ("Правильных ответов", "\(totalCorrect)"),
                                ("Всего вопросов", "\(totalQuestions)"),
                                ("Точность", accuracyText)
                            ]
                        )

                        VStack(spacing: 12) {
                            Button("Изменить PIN-код") {
                                showPinSettings = true
                            }
                            .buttonStyle(.borderedProminent)

                            Button("На главный экран") {
                                router.goHome()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .frame(maxWidth: 700)
                    .padding(.horizontal)
                }
                .padding(.vertical, 16)
            }
        }
        .sheet(isPresented: $showPinSettings) {
            ParentSettingsView()
                .environmentObject(profileStore)
                .environmentObject(statsStore)
                .environmentObject(router)
        }
    }

    private func dashboardCard(title: String, rows: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.title3.bold())

            ForEach(0..<rows.count, id: \.self) { index in
                HStack {
                    Text(rows[index].0)
                    Spacer()
                    Text(rows[index].1)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.9))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.black.opacity(0.06), lineWidth: 1)
        )
    }
}
