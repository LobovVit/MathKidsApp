//
//  MathKidsAppApp.swift
//  MathKidsApp
//
//  Created by Lobov Vitaliy on 11.03.2026.
//

import SwiftUI
import CoreData

@main
struct MathKidsAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
