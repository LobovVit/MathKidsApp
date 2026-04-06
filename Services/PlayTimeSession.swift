import Foundation
import Combine

@MainActor
final class PlayTimeSession: ObservableObject {
    @Published private(set) var remainingSeconds: Int = 0

    private weak var profileStore: ProfileStore?
    private var timer: Timer?
    private var onExpire: (() -> Void)?
    private var trackedProfileID: UUID?

    var formattedTime: String {
        let minutes = remainingSeconds / 60
        let seconds = remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func start(profileStore: ProfileStore, onExpire: @escaping () -> Void) {
        stop()
        self.profileStore = profileStore
        self.onExpire = onExpire
        trackedProfileID = profileStore.selectedProfileID
        remainingSeconds = profileStore.profile.playTimeSeconds

        guard remainingSeconds > 0 else {
            onExpire()
            return
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self, let profileStore = self.profileStore else { return }
                self.remainingSeconds = profileStore.consumePlaySeconds(1, from: self.trackedProfileID)
                if self.remainingSeconds <= 0 {
                    self.stop()
                    self.onExpire?()
                }
            }
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        timer?.invalidate()
    }
}
