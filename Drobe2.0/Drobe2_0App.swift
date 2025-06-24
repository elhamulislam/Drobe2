//
//  Drobe2_0App.swift
//  Drobe2.0
//
//  Created by Elham on 2025-06-09.
//

import SwiftUI

@main
struct Drobe2_0App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
