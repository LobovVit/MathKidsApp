import SceneKit

final class PlacementService {
    func placementCoordinate(from selected: VoxelCoord, faceNormal: SCNVector3) -> VoxelCoord {
        let axis = dominantAxis(for: faceNormal)
        let dx = axis == .x ? signedUnit(faceNormal.x) : 0
        let dy = axis == .y ? signedUnit(faceNormal.y) : 0
        let dz = axis == .z ? signedUnit(faceNormal.z) : 0
        return selected.offset(dx: dx, dy: dy, dz: dz)
    }

    private func dominantAxis(for normal: SCNVector3) -> Axis {
        let x = abs(normal.x)
        let y = abs(normal.y)
        let z = abs(normal.z)

        if y >= x && y >= z {
            return .y
        } else if x >= z {
            return .x
        } else {
            return .z
        }
    }

    private func signedUnit(_ value: Float) -> Int {
        value >= 0 ? 1 : -1
    }
}

private enum Axis {
    case x
    case y
    case z
}
