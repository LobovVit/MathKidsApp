import SwiftUI

struct RewardGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = RewardGameViewModel()
    @State private var started = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                KidBackgroundView()

                VStack(spacing: 16) {
#if os(macOS)
                    HStack {
                        Button("← Назад") {
                            router.goHome()
                        }
                        .buttonStyle(.bordered)

                        Spacer()

                        Text("Бонусная игра")
                            .font(.headline)

                        Spacer()

                        Color.clear.frame(width: 80, height: 1)
                    }
                    .padding(.horizontal)
#else
                    EmptyView()
#endif

                    header

                    Spacer()

                    ZStack {
                        ForEach(viewModel.items) { item in
                            Button {
                                viewModel.tap(item: item)
                            } label: {
                                Text(item.emoji)
                                    .font(.system(size: 38))
                            }
                            .buttonStyle(.plain)
                            .position(x: item.x, y: item.y)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    Spacer()
                }
                .padding()

                if viewModel.isFinished {
                    resultOverlay(width: geo.size.width)
                }
            }
            .onAppear {
                guard !started else { return }
                started = true
                viewModel.start(in: geo.size.width)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Text("⏰ \(viewModel.timeLeft) сек")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.85)))

            Spacer()

            Text("⭐️ \(viewModel.score)")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.85)))
        }
    }

    private func resultOverlay(width: CGFloat) -> some View {
        VStack(spacing: 16) {
            Text("Супер! 🎉")
                .font(.largeTitle.bold())

            Text("Ты собрал: \(viewModel.score)")
                .font(.title2.bold())

            Text("Лучший результат: \(viewModel.bestScore)")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Button("Ещё раз") {
                    viewModel.restart(in: width)
                }
                .buttonStyle(.borderedProminent)

#if os(macOS)
                Button("На главную") {
                    router.goHome()
                }
                .buttonStyle(.bordered)
#else
                Button("Готово") {
                    dismiss()
                }
                .buttonStyle(.bordered)
#endif
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.white.opacity(0.94))
        )
        .padding()
    }
}
