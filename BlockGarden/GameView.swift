import SwiftUI

struct GameView: View {
    @EnvironmentObject private var router: AppRouter
    @EnvironmentObject private var profileStore: ProfileStore
    @StateObject private var viewModel = GameViewModel()
    @StateObject private var playTimeSession = PlayTimeSession()
    @State private var started = false

    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.98, blue: 1.0)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                HStack {
                    Button("← Домой") {
                        router.goHome()
                    }
                    .buttonStyle(.bordered)

                    Spacer()
                }
                .padding(.horizontal)

                VStack(spacing: 8) {
                    Text("BlockGarden")
                        .font(.title.bold())

                    Text(viewModel.statusText)
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)

                    Text("Осталось времени: \(playTimeSession.formattedTime)")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text("Тапни по клетке, чтобы строить или убирать верхний блок.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.white.opacity(0.9), in: RoundedRectangle(cornerRadius: 22))
                .padding(.horizontal)

                ToolBarView(
                    selectedTool: $viewModel.selectedTool,
                    saveAction: viewModel.save,
                    resetAction: viewModel.resetWorld
                )

                BlockGardenBoardView(viewModel: viewModel)
                    .frame(maxWidth: 620)
                    .padding(.horizontal)

                BlockPaletteView(selectedBlock: $viewModel.selectedBlock)
                    .background(Color.white.opacity(0.86), in: RoundedRectangle(cornerRadius: 22))
                    .padding(.horizontal)

                Spacer()
            }
            .padding(.vertical, 18)
            .onAppear {
                guard !started else { return }
                started = true
                playTimeSession.start(profileStore: profileStore) {
                    viewModel.save()
                    router.goHome()
                }
            }
            .onDisappear {
                playTimeSession.stop()
            }

            VStack {
                Spacer()

                if let reward = viewModel.rewardText {
                    RewardBannerView(text: reward)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: viewModel.rewardText)
        }
    }
}

private struct BlockGardenBoardView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            let boardSize = min(geometry.size.width, geometry.size.height)
            let cellSize = boardSize / CGFloat(max(viewModel.boardColumns.count, 1))

            VStack(spacing: 12) {
                VStack(spacing: 2) {
                    ForEach(viewModel.boardRows.reversed(), id: \.self) { z in
                        HStack(spacing: 2) {
                            ForEach(viewModel.boardColumns, id: \.self) { x in
                                let topBlock = viewModel.topBlock(atX: x, z: z)
                                Button {
                                    viewModel.handleBoardTap(x: x, z: z)
                                } label: {
                                    ZStack(alignment: .topTrailing) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(topBlock == nil ? Color.white : Color.white.opacity(0.98))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(
                                                        topBlock == nil ? Color.black.opacity(0.08) : Color.blue.opacity(0.12),
                                                        lineWidth: 1
                                                    )
                                            )

                                        if let topBlock {
                                            VStack(spacing: 1) {
                                                Text(topBlock.block.type.icon)
                                                    .font(.system(size: cellSize * 0.45))

                                                Text("\(topBlock.coord.y + 1)")
                                                    .font(.system(size: 9, weight: .bold))
                                                    .foregroundColor(.black.opacity(0.65))
                                            }
                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        }
                                    }
                                    .frame(width: cellSize, height: cellSize)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.92))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(Color.blue.opacity(0.08), lineWidth: 1)
                )

                Text("Тапни по клетке, чтобы поставить сверху кубик или убрать верхний.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
