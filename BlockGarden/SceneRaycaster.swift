import SceneKit

final class SceneRaycaster {
    func hitTestBlock(in scnView: SCNView, at point: CGPoint) -> (coord: VoxelCoord, faceNormal: SCNVector3)? {
        let hits = scnView.hitTest(point, options: [:])

        guard let first = hits.first,
              let name = first.node.name,
              name.starts(with: "block_") else {
            return nil
        }

        let parts = name.replacingOccurrences(of: "block_", with: "").split(separator: "_")
        guard parts.count == 3,
              let x = Int(parts[0]),
              let y = Int(parts[1]),
              let z = Int(parts[2]) else {
            return nil
        }

        return (VoxelCoord(x: x, y: y, z: z), first.localNormal)
    }
}
