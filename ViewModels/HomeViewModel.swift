import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    let operations = MathOperation.allCases
}
