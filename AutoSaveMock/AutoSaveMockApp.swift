//
//  AutoSaveMockApp.swift
//  AutoSaveMock
//
//  Created by Asia Michelle Serrano on 3/1/23.
//

import SwiftUI

@main
struct AutoSaveMockApp: App {
    let persistenceController: PersistenceController = PersistenceController.shared
    let alertObject: AlertObject = AlertObjectKey.defaultValue

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(alertObject)
        }
    }
}
