import Foundation

struct RewardService { func reward(for result: SessionResult) -> RewardSummary { let p = Int(result.accuracy * 100); switch p { case 100: return .init(stars: 3, title: "Супер!", message: "Все ответы правильные!"); case 80...99: return .init(stars: 2, title: "Отлично!", message: "Очень хороший результат!"); default: return .init(stars: 1, title: "Молодец!", message: "Продолжай, и будет ещё лучше!") } } }
