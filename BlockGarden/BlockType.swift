import Foundation
import SwiftUI

enum BlockType: String, Codable, CaseIterable, Identifiable {
    case grass, dirt, sand, stone, wood, leaf, pinkBrick, blueBrick, flower, glowBlock

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .grass: return "Трава"
        case .dirt: return "Земля"
        case .sand: return "Песок"
        case .stone: return "Камень"
        case .wood: return "Дерево"
        case .leaf: return "Листья"
        case .pinkBrick: return "Слон"
        case .blueBrick: return "Вода"
        case .flower: return "Цветок"
        case .glowBlock: return "Свет"
        }
    }

    var icon: String {
        switch self {
        case .grass: return "🌿"
        case .dirt: return "🟫"
        case .sand: return "🏖️"
        case .stone: return "🪨"
        case .wood: return "🪵"
        case .leaf: return "🍃"
        case .pinkBrick: return "🐘"
        case .blueBrick: return "💧"
        case .flower: return "🌸"
        case .glowBlock: return "✨"
        }
    }

    var color: Color {
        switch self {
        case .grass: return .green
        case .dirt: return .brown
        case .sand: return .yellow
        case .stone: return .gray
        case .wood: return Color(red: 0.58, green: 0.38, blue: 0.20)
        case .leaf: return Color(red: 0.18, green: 0.62, blue: 0.25)
        case .pinkBrick: return .pink
        case .blueBrick: return .blue
        case .flower: return Color(red: 0.94, green: 0.36, blue: 0.64)
        case .glowBlock: return .teal
        }
    }
}
