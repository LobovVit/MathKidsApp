import Foundation

struct ChildProfile: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var age: Int
    var avatar: String
    var selectedLevel: DifficultyLevel
    var playTimeSeconds: Int

    // Персональные учебные настройки ребёнка
    var answerMode: AnswerMode
    var divisionOnlyIntegers: Bool
    var allowNegativeSubtraction: Bool

    init(
        id: UUID = UUID(),
        name: String = "Ребёнок",
        age: Int = 6,
        avatar: String = "🦊",
        selectedLevel: DifficultyLevel = .easy,
        playTimeSeconds: Int = 0,
        answerMode: AnswerMode = .multipleChoice,
        divisionOnlyIntegers: Bool = true,
        allowNegativeSubtraction: Bool = false
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.avatar = avatar
        self.selectedLevel = selectedLevel
        self.playTimeSeconds = playTimeSeconds
        self.answerMode = answerMode
        self.divisionOnlyIntegers = divisionOnlyIntegers
        self.allowNegativeSubtraction = allowNegativeSubtraction
    }

    var formattedPlayTime: String {
        let minutes = playTimeSeconds / 60
        let seconds = playTimeSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case age
        case avatar
        case selectedLevel
        case playTimeSeconds
        case answerMode
        case divisionOnlyIntegers
        case allowNegativeSubtraction
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        avatar = try container.decode(String.self, forKey: .avatar)
        selectedLevel = try container.decode(DifficultyLevel.self, forKey: .selectedLevel)
        playTimeSeconds = try container.decodeIfPresent(Int.self, forKey: .playTimeSeconds) ?? 0
        answerMode = try container.decode(AnswerMode.self, forKey: .answerMode)
        divisionOnlyIntegers = try container.decode(Bool.self, forKey: .divisionOnlyIntegers)
        allowNegativeSubtraction = try container.decode(Bool.self, forKey: .allowNegativeSubtraction)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(age, forKey: .age)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(selectedLevel, forKey: .selectedLevel)
        try container.encode(playTimeSeconds, forKey: .playTimeSeconds)
        try container.encode(answerMode, forKey: .answerMode)
        try container.encode(divisionOnlyIntegers, forKey: .divisionOnlyIntegers)
        try container.encode(allowNegativeSubtraction, forKey: .allowNegativeSubtraction)
    }
}
