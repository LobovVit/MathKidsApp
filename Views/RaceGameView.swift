import SwiftUI

struct RaceGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = RaceGameViewModel()
    @State private var started = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.14),
                        Color.gray.opacity(0.08),
                        Color.purple.opacity(0.10)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 14) {
#if os(macOS)
                    HStack {
                        Button("← Назад") {
                            router.goHome()
                        }
                        .buttonStyle(.bordered)

                        Spacer()

                        Text("Гонки")
                            .font(.headline)

                        Spacer()

                        Color.clear.frame(width: 80, height: 1)
                    }
                    .padding(.horizontal)
#endif

                    header

                    ZStack {
                        roadBackground(height: geo.size.height)

                        ForEach(viewModel.items) { item in
                            Text(item.emoji)
                                .font(.system(size: 34))
                                .position(x: item.x, y: item.y)
                        }

                        Text("🚗")
                            .font(.system(size: 42))
                            .position(x: viewModel.carX, y: geo.size.height - 110)
                    }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                viewModel.moveCar(to: value.location.x)
                            }
                    )
                }
                .padding()

                if viewModel.isFinished {
                    resultOverlay(width: geo.size.width, height: geo.size.height)
                }
            }
            .onAppear {
                guard !started else { return }
                started = true
                viewModel.start(in: geo.size.width, height: geo.size.height)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 12) {
            Text("⏰ \(viewModel.timeLeft) сек")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.88)))

            Spacer()

            Text("🏁 \(viewModel.score)")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.88)))
        }
    }

    private func roadBackground(height: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.black.opacity(0.78))

            VStack(spacing: 14) {
                ForEach(0..<14, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.85))
                        .frame(width: 8, height: 26)
                }
            }

            HStack {
                Rectangle()
                    .fill(Color.white.opacity(0.45))
                    .frame(width: 4)
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.45))
                    .frame(width: 4)
            }
            .padding(.horizontal, 22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func resultOverlay(width: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 16) {
            Text("Финиш! 🏁")
                .font(.largeTitle.bold())

            Text("Ты набрал: \(viewModel.score)")
                .font(.title2.bold())

            Text("Лучший результат: \(viewModel.bestScore)")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
                Button("Ещё раз") {
                    viewModel.restart(in: width, height: height)
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
