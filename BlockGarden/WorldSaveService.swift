import Foundation

final class WorldSaveService {
    private let filename = "block-garden-save.json"

    func save(world: VoxelWorld, selectedBlock: BlockType) throws {
        let items = world.allBlocks().map { coord, block in
            SavedBlock(x: coord.x, y: coord.y, z: coord.z, type: block.type)
        }
        let file = SaveFile(blocks: items, selectedBlock: selectedBlock)
        let data = try JSONEncoder().encode(file)
        try data.write(to: fileURL(), options: .atomic)
    }

    func load() throws -> SaveFile {
        let data = try Data(contentsOf: fileURL())
        return try JSONDecoder().decode(SaveFile.self, from: data)
    }

    private func fileURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
    }
}
