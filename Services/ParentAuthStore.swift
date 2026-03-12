import Foundation
import Combine

final class ParentAuthStore: ObservableObject {
    @Published var pinCode: String { didSet { UserDefaults.standard.set(pinCode, forKey: key) } }
    @Published var enteredPin: String = ""
    @Published var isUnlocked: Bool = false
    @Published var errorMessage: String?
    private let key = "mathkids.parent.pin"

    init() { pinCode = UserDefaults.standard.string(forKey: key) ?? "0000" }

    func unlock() {
        if enteredPin == pinCode { isUnlocked = true; errorMessage = nil; enteredPin = "" }
        else { errorMessage = "Неверный PIN" }
    }
    func lock() { isUnlocked = false; enteredPin = "" }
    func updatePin(to newPin: String) { guard newPin.count == 4, newPin.allSatisfy({ $0.isNumber }) else { return }; pinCode = newPin }
}
