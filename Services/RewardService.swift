import Foundation

struct RewardService {
    func reward(for result: SessionResult) -> RewardSummary {
        let percent = Int(result.accuracy * 100)

        switch percent {
        case 100:
            return RewardSummary(stars: 3, title: "Супер!", message: "Все ответы правильные!")
        case 80...99:
            return RewardSummary(stars: 2, title: "Отлично!", message: "Очень хороший результат!")
        default:
            return RewardSummary(stars: 1, title: "Молодец!", message: "Продолжай, и будет ещё лучше!")
        }
    }
}
