import Foundation

final class AutosaveController {
    private var workItem: DispatchWorkItem?

    func schedule(after delay: TimeInterval = 1.2, action: @escaping () -> Void) {
        workItem?.cancel()
        let item = DispatchWorkItem(block: action)
        workItem = item
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: item)
    }
}
