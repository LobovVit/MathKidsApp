//
//  ParentAuthStore.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import Foundation
import Combine
import SwiftUI

final class ParentAuthStore: ObservableObject {
    @Published var pinCode: String {
        didSet { UserDefaults.standard.set(pinCode, forKey: key) }
    }

    @Published var isUnlocked: Bool = false

    private let key = "mathkids.v4.parent.pin"

    init() {
        pinCode = UserDefaults.standard.string(forKey: key) ?? "1234"
    }

    func unlock(with attempt: String) -> Bool {
        let success = attempt == pinCode
        isUnlocked = success
        return success
    }

    func lock() {
        isUnlocked = false
    }
}
