import SceneKit

final class CameraController {
    func makeCameraNode(target: SCNNode) -> SCNNode {
        let camera = SCNCamera()
        camera.fieldOfView = 58
        camera.zNear = 0.1
        camera.zFar = 200

        let node = SCNNode()
        node.camera = camera
        node.name = "mainCamera"
        node.position = SCNVector3(7.5, 14, 24)
        let lookAt = SCNLookAtConstraint(target: target)
        lookAt.isGimbalLockEnabled = true
        node.constraints = [lookAt]
        return node
    }
}
