import Foundation

struct VoxelCoord: Hashable, Codable {
    let x: Int
    let y: Int
    let z: Int

    func offset(dx: Int = 0, dy: Int = 0, dz: Int = 0) -> VoxelCoord {
        VoxelCoord(x: x + dx, y: y + dy, z: z + dz)
    }
}
