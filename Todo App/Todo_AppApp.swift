//
//  Todo_AppApp.swift
//  Todo App
//
//  Created by Labhesh Dudi on 15/02/26.
//

import SwiftUI
import CoreData

@main
struct Todo_AppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
