import Combine
import Foundation
import SwiftUI

typealias ProfileStore = ProfilesStore

final class ProfilesStore: ObservableObject {
    @Published var profiles: [ChildProfile] {
        didSet { persist() }
    }

    @Published var selectedProfileID: UUID {
        didSet { persist() }
    }

    private let profilesKey = "mathkids.v4.profiles"
    private let selectedIDKey = "mathkids.v4.selectedProfileID"

    init() {
        let fallback = [
            ChildProfile(name: "Маша", age: 6, avatar: "🦊", selectedLevel: .easy),
            ChildProfile(name: "Петя", age: 8, avatar: "🐼", selectedLevel: .medium)
        ]

        let initialProfiles: [ChildProfile]

        if let localData = UserDefaults.standard.data(forKey: profilesKey),
           let decoded = try? JSONDecoder().decode([ChildProfile].self, from: localData),
           !decoded.isEmpty {
            initialProfiles = decoded
        } else if let cloud: [ChildProfile] = ICloudKeyValueSync.shared.pull([ChildProfile].self, forKey: profilesKey), !cloud.isEmpty {
            initialProfiles = cloud
        } else {
            initialProfiles = fallback
        }

        profiles = initialProfiles

        if let stored = UserDefaults.standard.string(forKey: selectedIDKey),
           let uuid = UUID(uuidString: stored),
           initialProfiles.contains(where: { $0.id == uuid }) {
            selectedProfileID = uuid
        } else {
            selectedProfileID = initialProfiles.first?.id ?? UUID()
        }
    }

    var selectedProfile: ChildProfile {
        get {
            profiles.first(where: { $0.id == selectedProfileID }) ?? profiles[0]
        }
        set {
            guard let index = profiles.firstIndex(where: { $0.id == newValue.id }) else { return }
            profiles[index] = newValue
        }
    }

    var profile: ChildProfile {
        get { selectedProfile }
        set { selectedProfile = newValue }
    }

    func addProfile() {
        let newProfile = ChildProfile(name: "Новый ребёнок", age: 6, avatar: "🐱", selectedLevel: .easy)
        profiles.append(newProfile)
        selectedProfileID = newProfile.id
    }

    func deleteProfile(_ profile: ChildProfile) {
        guard profiles.count > 1 else { return }
        profiles.removeAll { $0.id == profile.id }
        if selectedProfileID == profile.id, let first = profiles.first {
            selectedProfileID = first.id
        }
    }

    private func persist() {
        guard let data = try? JSONEncoder().encode(profiles) else { return }
        UserDefaults.standard.set(data, forKey: profilesKey)
        UserDefaults.standard.set(selectedProfileID.uuidString, forKey: selectedIDKey)
        let syncEnabled = true
        ICloudKeyValueSync.shared.push(profiles, forKey: profilesKey, enabled: syncEnabled)
    }
}
