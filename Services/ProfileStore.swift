import Foundation
import Combine
import SwiftUI

final class ProfileStore: ObservableObject {
    @Published var profile: ChildProfile {
        didSet { save() }
    }

    private let key = "mathkid.child.profile"

    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode(ChildProfile.self, from: data) {
            self.profile = decoded
        } else {
            self.profile = ChildProfile()
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(profile) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }
}
