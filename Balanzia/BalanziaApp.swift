//
//  BalanziaApp.swift
//  Balanzia
//
//  Created by Mauricio Molina on 09/08/2025.
//

import SwiftUI

@main
struct BalanziaApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(
          \.managedObjectContext,
          persistenceController.container.viewContext
        )
    }
  }
}
