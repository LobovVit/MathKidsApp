import SceneKit
import UIKit

enum BlockNodeFactory {
    static func makeNode(for block: Block, at coord: VoxelCoord) -> SCNNode {
        let geometry = SCNBox(width: 0.96, height: 0.96, length: 0.96, chamferRadius: 0.04)
        geometry.materials = materials(for: block.type)

        let node = SCNNode(geometry: geometry)
        node.position = SCNVector3(Float(coord.x), Float(coord.y), Float(coord.z))
        node.name = nodeName(for: coord)
        node.castsShadow = true
        return node
    }

    static func nodeName(for coord: VoxelCoord) -> String {
        "block_\(coord.x)_\(coord.y)_\(coord.z)"
    }

    private static func materials(for type: BlockType) -> [SCNMaterial] {
        let top = material(color: topColor(for: type), emission: emissionColor(for: type))
        let side = material(color: sideColor(for: type), emission: emissionColor(for: type))
        let bottom = material(color: bottomColor(for: type))
        return [side, side, top, bottom, side, side]
    }

    private static func material(color: UIColor, emission: UIColor = .black) -> SCNMaterial {
        let material = SCNMaterial()
        material.diffuse.contents = color
        material.emission.contents = emission
        material.specular.contents = UIColor.white.withAlphaComponent(0.18)
        material.lightingModel = .blinn
        material.isDoubleSided = false
        return material
    }

    private static func topColor(for type: BlockType) -> UIColor {
        switch type {
        case .grass: return .systemGreen
        case .dirt: return .brown
        case .sand: return .systemYellow
        case .stone: return .gray
        case .wood: return UIColor(red: 0.58, green: 0.38, blue: 0.20, alpha: 1)
        case .leaf: return UIColor(red: 0.18, green: 0.62, blue: 0.25, alpha: 1)
        case .pinkBrick: return .systemPink
        case .blueBrick: return .systemBlue
        case .flower: return UIColor(red: 0.94, green: 0.36, blue: 0.64, alpha: 1)
        case .glowBlock: return .systemTeal
        }
    }

    private static func sideColor(for type: BlockType) -> UIColor {
        switch type {
        case .grass:
            return UIColor(red: 0.36, green: 0.69, blue: 0.25, alpha: 1)
        case .wood:
            return UIColor(red: 0.50, green: 0.31, blue: 0.16, alpha: 1)
        default:
            return topColor(for: type)
        }
    }

    private static func bottomColor(for type: BlockType) -> UIColor {
        switch type {
        case .grass:
            return .brown
        case .sand:
            return UIColor(red: 0.86, green: 0.77, blue: 0.43, alpha: 1)
        default:
            return sideColor(for: type)
        }
    }

    private static func emissionColor(for type: BlockType) -> UIColor {
        switch type {
        case .glowBlock:
            return UIColor(red: 0.15, green: 0.55, blue: 0.52, alpha: 1)
        default:
            return .black
        }
    }
}
