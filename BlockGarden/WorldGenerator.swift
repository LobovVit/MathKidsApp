import Foundation

enum WorldGenerator {
    static func makeStarterWorld() -> [VoxelCoord: Block] {
        var result: [VoxelCoord: Block] = [:]
        let shorelineByZ = [9, 10, 10, 11, 10, 9, 8, 8, 9, 10, 11, 10, 9, 8, 9, 10]

        for z in 0..<16 {
            let shoreline = shorelineByZ[z]

            for x in 0..<16 {
                let groundType: BlockType
                if x >= shoreline {
                    groundType = .blueBrick
                } else if x >= shoreline - 1 {
                    groundType = .sand
                } else {
                    groundType = .grass
                }

                result[VoxelCoord(x: x, y: 0, z: z)] = Block(type: groundType)
            }
        }

        let stoneCoords = [
            VoxelCoord(x: 2, y: 1, z: 3),
            VoxelCoord(x: 3, y: 1, z: 3),
            VoxelCoord(x: 3, y: 1, z: 4),
            VoxelCoord(x: 5, y: 1, z: 8),
            VoxelCoord(x: 5, y: 1, z: 9),
            VoxelCoord(x: 6, y: 1, z: 9),
            VoxelCoord(x: 4, y: 1, z: 12),
            VoxelCoord(x: 5, y: 1, z: 12)
        ]
        for coord in stoneCoords {
            result[coord] = Block(type: .stone)
        }

        for y in 1...3 {
            result[VoxelCoord(x: 4, y: y, z: 4)] = Block(type: .wood)
        }
        let leaves = [
            VoxelCoord(x: 4, y: 4, z: 4),
            VoxelCoord(x: 5, y: 4, z: 4),
            VoxelCoord(x: 3, y: 4, z: 4),
            VoxelCoord(x: 4, y: 4, z: 5),
            VoxelCoord(x: 4, y: 4, z: 3),
            VoxelCoord(x: 4, y: 5, z: 4),
        ]
        for c in leaves {
            result[c] = Block(type: .leaf)
        }

        result[VoxelCoord(x: 2, y: 1, z: 10)] = Block(type: .flower)
        result[VoxelCoord(x: 6, y: 1, z: 6)] = Block(type: .flower)
        result[VoxelCoord(x: 7, y: 1, z: 13)] = Block(type: .glowBlock)
        result[VoxelCoord(x: 11, y: 1, z: 4)] = Block(type: .blueBrick)
        result[VoxelCoord(x: 12, y: 1, z: 10)] = Block(type: .blueBrick)

        return result
    }
}
