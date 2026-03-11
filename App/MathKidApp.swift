import SwiftUI

@main
struct MathKidApp: App {
    @StateObject private var settingsStore = SettingsStore()
    @StateObject private var statsStore = StatsStore()
    @StateObject private var profileStore = ProfileStore()
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settingsStore)
                .environmentObject(statsStore)
                .environmentObject(profileStore)
                .environmentObject(router)
        }
    }
}
