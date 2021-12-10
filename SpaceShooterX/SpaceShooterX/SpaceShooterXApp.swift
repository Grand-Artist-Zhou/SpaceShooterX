//
//  SpaceShooterXApp.swift
//  SpaceShooterX
//
//  Created by Yizhou Li on 10/26/21.
//

import SwiftUI

@main
struct SpaceShooterXApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject var model = Model()
    @StateObject var viewManager = ViewManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
                .environmentObject(viewManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
