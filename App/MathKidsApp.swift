import SwiftUI

@main
struct MathKidsApp: App {
    @StateObject private var settingsStore = SettingsStore()
    @StateObject private var statsStore = StatsStore()
    @StateObject private var profileStore = ProfileStore()
    @StateObject private var router = AppRouter()
    @StateObject private var parentAuthStore = ParentAuthStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsStore)
                .environmentObject(statsStore)
                .environmentObject(profileStore)
                .environmentObject(router)
                .environmentObject(parentAuthStore)
        }
    }
}
