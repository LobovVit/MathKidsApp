import Foundation
import Combine
import SceneKit

@MainActor
final class GameViewModel: ObservableObject {
    @Published var selectedBlock: BlockType = .grass
    @Published var selectedTool: PlayerTool = .place
    @Published var rewardText: String?
    @Published var statusText = "Поставь блок на свободное место или убери лишний."

    let world = VoxelWorld()
    let sceneController = GameSceneController()

    private let saveService = WorldSaveService()
    private let autosave = AutosaveController()
    private let inputController = GameInputController()
    private var lastEditedSignature: EditSignature?

    init() {
        loadOrCreateWorld()
    }

    func scene() -> SCNScene {
        sceneController.scene
    }

    var boardColumns: [Int] {
        Array(world.xRange)
    }

    var boardRows: [Int] {
        Array(world.zRange)
    }

    func topBlock(atX x: Int, z: Int) -> (coord: VoxelCoord, block: Block)? {
        world.topBlock(atX: x, z: z)
    }

    func handleBoardTap(x: Int, z: Int) {
        switch selectedTool {
        case .remove:
            guard let topBlock = world.topBlock(atX: x, z: z) else {
                showMessage("Здесь нечего убирать.")
                return
            }
            guard world.canRemoveBlock(at: topBlock.coord) else {
                showMessage("Основание мира оставляем, чтобы поле не исчезло.")
                return
            }
            world.removeBlock(at: topBlock.coord)
            sceneController.rebuild(from: world)
            showMessage("Убрали верхний кубик.")

        case .place:
            let nextY = (world.topBlock(atX: x, z: z)?.coord.y ?? -1) + 1
            let coord = VoxelCoord(x: x, y: nextY, z: z)
            guard world.canPlaceBlock(at: coord) else {
                showMessage("Эта башенка уже слишком высокая.")
                return
            }
            let block = Block(type: selectedBlock)
            world.setBlock(block, at: coord)
            sceneController.rebuild(from: world)
            showMessage("Поставили \(selectedBlock.displayName.lowercased()).")
        }

        autosave.schedule { [weak self] in
            self?.save()
        }
    }

    func handleTap(in scnView: SCNView, at point: CGPoint) {
        guard let hit = inputController.selectedBlock(in: scnView, at: point) else {
            showMessage("Нажми на кубик, чтобы строить рядом с ним.")
            return
        }

        switch selectedTool {
        case .remove:
            guard world.canRemoveBlock(at: hit.coord) else {
                showMessage("Основание мира оставляем, чтобы остров не развалился.")
                return
            }
            let signature = EditSignature(tool: .remove, coord: hit.coord, block: selectedBlock)
            guard lastEditedSignature != signature else { return }
            world.removeBlock(at: hit.coord)
            sceneController.rebuild(from: world)
            lastEditedSignature = signature
            showMessage("Кубик убран. Освобождаем место для новой идеи.")

        case .place:
            let target = inputController.placementCoord(from: hit.coord, faceNormal: hit.faceNormal)
            guard world.canPlaceBlock(at: target) else {
                showMessage("Тут строить нельзя. Попробуй соседнюю грань внутри поля.")
                return
            }
            let signature = EditSignature(tool: .place, coord: target, block: selectedBlock)
            guard lastEditedSignature != signature else { return }
            let block = Block(type: selectedBlock)
            world.setBlock(block, at: target)
            sceneController.rebuild(from: world)
            lastEditedSignature = signature
            showMessage("Готово! Добавили \(selectedBlock.displayName.lowercased()).")
        }
        autosave.schedule { [weak self] in
            self?.save()
        }
    }

    func finishInteraction() {
        lastEditedSignature = nil
    }

    func save() {
        try? saveService.save(world: world, selectedBlock: selectedBlock)
        showMessage("Мир сохранён.")
    }

    func resetWorld() {
        world.replaceAll(with: WorldGenerator.makeStarterWorld())
        sceneController.rebuild(from: world)
        selectedBlock = .grass
        selectedTool = .place
        lastEditedSignature = nil
        showMessage("Создали новый мир. Можно строить заново!")
    }

    private func loadOrCreateWorld() {
        if let loaded = try? saveService.load() {
            var map: [VoxelCoord: Block] = [:]
            for item in loaded.blocks {
                map[VoxelCoord(x: item.x, y: item.y, z: item.z)] = Block(type: item.type)
            }
            world.replaceAll(with: map)
            selectedBlock = loaded.selectedBlock
            statusText = "Мир загружен. Продолжай строить."
        } else {
            world.replaceAll(with: WorldGenerator.makeStarterWorld())
            statusText = "Добро пожаловать в BlockGarden. Построй дом, башню или сад!"
        }

        sceneController.rebuild(from: world)
    }

    private func showMessage(_ text: String) {
        statusText = text
        rewardText = text
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) { [weak self] in
            guard self?.rewardText == text else { return }
            self?.rewardText = nil
        }
    }
}

private struct EditSignature: Equatable {
    let tool: PlayerTool
    let coord: VoxelCoord
    let block: BlockType
}
