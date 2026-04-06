import Foundation

final class VoxelWorld {
    let xRange = 0...15
    let yRange = 0...10
    let zRange = 0...15

    private(set) var blocks: [VoxelCoord: Block] = [:]

    func block(at coord: VoxelCoord) -> Block? {
        blocks[coord]
    }

    func setBlock(_ block: Block, at coord: VoxelCoord) {
        blocks[coord] = block
    }

    func removeBlock(at coord: VoxelCoord) {
        blocks.removeValue(forKey: coord)
    }

    func canPlaceBlock(at coord: VoxelCoord) -> Bool {
        isInsidePlayableArea(coord) && blocks[coord] == nil
    }

    func canRemoveBlock(at coord: VoxelCoord) -> Bool {
        coord.y > 0 && blocks[coord] != nil
    }

    func isInsidePlayableArea(_ coord: VoxelCoord) -> Bool {
        xRange.contains(coord.x) &&
        yRange.contains(coord.y) &&
        zRange.contains(coord.z)
    }

    func allBlocks() -> [VoxelCoord: Block] {
        blocks
    }

    func replaceAll(with blocks: [VoxelCoord: Block]) {
        self.blocks = blocks
    }

    func topBlock(atX x: Int, z: Int) -> (coord: VoxelCoord, block: Block)? {
        blocks
            .filter { $0.key.x == x && $0.key.z == z }
            .max { $0.key.y < $1.key.y }
            .map { ($0.key, $0.value) }
    }
}
