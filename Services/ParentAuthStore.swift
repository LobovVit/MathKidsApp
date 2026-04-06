import Foundation
import Combine

final class ParentAuthStore: ObservableObject {
    @Published var enteredPin: String = ""
    @Published var isUnlocked: Bool = false
    @Published var errorMessage: String?

    func reset() {
        enteredPin = ""
        isUnlocked = false
        errorMessage = nil
    }
}
