import Foundation

struct SavedBlock: Codable {
    let x: Int
    let y: Int
    let z: Int
    let type: BlockType
}

struct SaveFile: Codable {
    let blocks: [SavedBlock]
    let selectedBlock: BlockType
}
