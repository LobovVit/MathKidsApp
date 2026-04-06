import SceneKit

final class GameSceneController {
    let scene = SCNScene()
    private let cameraController = CameraController()

    func rebuild(from world: VoxelWorld) {
        scene.rootNode.childNodes.forEach { $0.removeFromParentNode() }

        let cameraTarget = SCNNode()
        cameraTarget.name = "cameraTarget"
        cameraTarget.position = SCNVector3(7.5, 2.5, 7.5)
        scene.rootNode.addChildNode(cameraTarget)

        let cameraNode = cameraController.makeCameraNode(target: cameraTarget)
        scene.rootNode.addChildNode(cameraNode)
        scene.background.contents = [
            UIColor(red: 0.54, green: 0.84, blue: 1.0, alpha: 1),
            UIColor(red: 0.88, green: 0.96, blue: 1.0, alpha: 1)
        ]

        let sun = SCNLight()
        sun.type = .directional
        sun.intensity = 1600
        sun.castsShadow = true
        let sunNode = SCNNode()
        sunNode.light = sun
        sunNode.eulerAngles = SCNVector3(-0.9, 0.6, 0)
        sunNode.position = SCNVector3(10, 18, 10)
        scene.rootNode.addChildNode(sunNode)

        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 700
        let ambientNode = SCNNode()
        ambientNode.light = ambient
        scene.rootNode.addChildNode(ambientNode)

        let floor = SCNFloor()
        let floorMaterial = SCNMaterial()
        floorMaterial.diffuse.contents = UIColor(red: 0.70, green: 0.92, blue: 0.70, alpha: 0.35)
        floorMaterial.roughness.contents = 1.0
        floor.materials = [floorMaterial]
        let floorNode = SCNNode(geometry: floor)
        floorNode.position = SCNVector3(7.5, -0.52, 7.5)
        scene.rootNode.addChildNode(floorNode)

        scene.rootNode.addChildNode(makeSunNode())
        for cloudNode in makeCloudNodes() {
            scene.rootNode.addChildNode(cloudNode)
        }

        for (coord, block) in world.allBlocks() {
            let node = BlockNodeFactory.makeNode(for: block, at: coord)
            scene.rootNode.addChildNode(node)
        }
    }

    func updateBlock(at coord: VoxelCoord, block: Block?) {
        let name = BlockNodeFactory.nodeName(for: coord)
        scene.rootNode.childNode(withName: name, recursively: false)?.removeFromParentNode()

        if let block {
            scene.rootNode.addChildNode(BlockNodeFactory.makeNode(for: block, at: coord))
        }
    }

    private func makeSunNode() -> SCNNode {
        let geometry = SCNSphere(radius: 1.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor(red: 1.0, green: 0.88, blue: 0.36, alpha: 1)
        material.emission.contents = UIColor(red: 0.9, green: 0.7, blue: 0.2, alpha: 1)
        geometry.materials = [material]

        let node = SCNNode(geometry: geometry)
        node.position = SCNVector3(2, 15, -8)
        return node
    }

    private func makeCloudNodes() -> [SCNNode] {
        [
            makeCloudNode(position: SCNVector3(4, 11, -4), scale: 1.0),
            makeCloudNode(position: SCNVector3(12, 12, 0), scale: 0.8)
        ]
    }

    private func makeCloudNode(position: SCNVector3, scale: Float) -> SCNNode {
        let container = SCNNode()
        container.position = position

        let offsets: [SCNVector3] = [
            SCNVector3(-0.9, 0, 0),
            SCNVector3(0, 0.2, 0),
            SCNVector3(0.9, 0, 0)
        ]

        for offset in offsets {
            let sphere = SCNSphere(radius: CGFloat(0.75 * scale))
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.white.withAlphaComponent(0.95)
            material.lightingModel = .physicallyBased
            sphere.materials = [material]

            let node = SCNNode(geometry: sphere)
            node.position = offset
            container.addChildNode(node)
        }

        return container
    }
}
