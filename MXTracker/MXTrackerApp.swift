//
//  MXTrackerApp.swift
//  MXTracker
//
//  Created by Kevin Johnston on 10/19/23.
//

import SwiftUI

@main
struct MXTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(locationDataManager: LocationDataManager())
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
