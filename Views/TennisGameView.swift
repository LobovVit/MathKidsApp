import SwiftUI

struct TennisGameView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: AppRouter
    @StateObject private var viewModel = TennisGameViewModel()
    @State private var started = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.green.opacity(0.18),
                        Color.blue.opacity(0.10),
                        Color.yellow.opacity(0.08)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 14) {
#if os(macOS)
                    HStack {
                        Button("← Назад") {
                            router.goToRewardGamePicker()
                        }
                        .buttonStyle(.bordered)

                        Spacer()

                        Text("Теннис")
                            .font(.headline)

                        Spacer()

                        Color.clear.frame(width: 80, height: 1)
                    }
                    .padding(.horizontal)
#endif

                    header

                    ZStack {
                        tennisCourt(size: geo.size)

                        ForEach(viewModel.bonuses) { bonus in
                            Text(bonus.emoji)
                                .font(.system(size: 30))
                                .position(x: bonus.x, y: bonus.y)
                        }

                        Circle()
                            .fill(viewModel.bounceFlash ? Color.yellow : Color.white)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.black.opacity(0.15), lineWidth: 1)
                            )
                            .position(x: viewModel.ballX, y: viewModel.ballY)
                            .shadow(radius: 2)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue.opacity(0.85))
                            .frame(width: 96, height: 16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.6), lineWidth: 1)
                            )
                            .position(x: viewModel.paddleX, y: geo.size.height - 110)
                    }
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                viewModel.movePaddle(to: value.location.x)
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

            Text("🎾 \(viewModel.score)")
                .font(.headline)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Capsule().fill(Color.white.opacity(0.88)))
        }
    }

    private func tennisCourt(size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.green.opacity(0.72))

            RoundedRectangle(cornerRadius: 28)
                .stroke(Color.white.opacity(0.9), lineWidth: 4)

            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.85))
                    .frame(height: 4)
                Spacer()
            }

            HStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(Color.white.opacity(0.85))
                    .frame(width: 4)
                Spacer()
            }

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.65))
                .frame(width: size.width * 0.78, height: 3)
                .position(x: size.width / 2, y: size.height - 132)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }

    private func resultOverlay(width: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 16) {
            Text("Супер! 🎉")
                .font(.largeTitle.bold())

            Text("Ты набрал: \(viewModel.score)")
                .font(.title2.bold())

            Text("Лучший результат: \(viewModel.bestScore)")
                .font(.headline)
                .foregroundColor(.secondary)

            HStack(spacing: 12) {
#if os(macOS)
                Button("К играм") {
                    router.goToRewardGamePicker()
                }
                .buttonStyle(.borderedProminent)

                Button("На главную") {
                    router.goHome()
                }
                .buttonStyle(.bordered)
#else
                Button("К играм") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)

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
