//
//  BalanziaApp.swift
//  Balanzia
//
//  Created by Mauricio Molina on 09/08/2025.
//

import SwiftData
import SwiftUI

@main
struct BalanziaApp: App {
  let persistenceController = PersistenceController.shared

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
    .modelContainer(for: [Account.self, Category.self, Movement.self])
  }
}
