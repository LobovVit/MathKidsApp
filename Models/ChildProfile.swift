import Foundation

struct ChildProfile: Identifiable, Codable {
    let id: UUID
    var name: String
    var age: Int
    var avatar: String
    var selectedLevel: DifficultyLevel

    init(
        id: UUID = UUID(),
        name: String = "Ребёнок",
        age: Int = 6,
        avatar: String = "🦊",
        selectedLevel: DifficultyLevel = .easy
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.avatar = avatar
        self.selectedLevel = selectedLevel
    }
}
