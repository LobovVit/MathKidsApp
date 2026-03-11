import Foundation

struct ChildProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var age: Int
    var avatar: String
    var selectedLevel: DifficultyLevel
    var accentSeed: Int

    init(
        id: UUID = UUID(),
        name: String = "Ребёнок",
        age: Int = 6,
        avatar: String = "🦊",
        selectedLevel: DifficultyLevel = .easy,
        accentSeed: Int = Int.random(in: 0...1000)
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.avatar = avatar
        self.selectedLevel = selectedLevel
        self.accentSeed = accentSeed
    }
}
