import Foundation
import Combine

final class ProfileStore: ObservableObject {
    @Published var profiles: [ChildProfile] {
        didSet { save() }
    }

    @Published var selectedProfileID: UUID? {
        didSet { saveSelectedProfile() }
    }

    private let profilesKey = "mathkids.child.profiles"
    private let selectedKey = "mathkids.selected.child"

    init() {
        if let data = UserDefaults.standard.data(forKey: profilesKey),
           let decoded = try? JSONDecoder().decode([ChildProfile].self, from: data),
           !decoded.isEmpty {
            profiles = decoded
        } else {
            profiles = [ChildProfile()]
        }

        selectedProfileID = UserDefaults.standard.string(forKey: selectedKey).flatMap(UUID.init(uuidString:))
        if selectedProfileID == nil {
            selectedProfileID = profiles.first?.id
        }
    }

    var profile: ChildProfile {
        get {
            profiles.first(where: { $0.id == selectedProfileID }) ?? profiles[0]
        }
        set {
            guard let index = profiles.firstIndex(where: { $0.id == newValue.id }) else { return }
            profiles[index] = newValue
        }
    }

    func addProfile() {
        let newProfile = ChildProfile(name: "Новый ребёнок", age: 6, avatar: "🐼", selectedLevel: .easy)
        profiles.append(newProfile)
        selectedProfileID = newProfile.id
    }

    func deleteProfile(_ profile: ChildProfile) {
        guard profiles.count > 1 else { return }
        profiles.removeAll { $0.id == profile.id }
        if selectedProfileID == profile.id {
            selectedProfileID = profiles.first?.id
        }
    }

    func selectProfile(_ profile: ChildProfile) {
        selectedProfileID = profile.id
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(profiles) else { return }
        UserDefaults.standard.set(data, forKey: profilesKey)
    }

    private func saveSelectedProfile() {
        UserDefaults.standard.set(selectedProfileID?.uuidString, forKey: selectedKey)
    }
}
