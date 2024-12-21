//
//  Proyecto_DAMApp.swift
//  Proyecto_DAM
//
//  Created by DAMII on 14/12/24.
//

import SwiftUI

@main
struct Proyecto_DAMApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
