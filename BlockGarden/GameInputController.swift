import SceneKit

final class GameInputController {
    private let raycaster = SceneRaycaster()
    private let placementService = PlacementService()

    func selectedBlock(in scnView: SCNView, at point: CGPoint) -> (coord: VoxelCoord, faceNormal: SCNVector3)? {
        raycaster.hitTestBlock(in: scnView, at: point) ??
        raycaster.hitTestBlock(in: scnView, at: CGPoint(x: scnView.bounds.midX, y: scnView.bounds.midY))
    }

    func placementCoord(from coord: VoxelCoord, faceNormal: SCNVector3) -> VoxelCoord {
        placementService.placementCoordinate(from: coord, faceNormal: faceNormal)
    }
}
