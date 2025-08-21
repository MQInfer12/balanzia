//
//  ContentView.swift
//  Balanzia X Watch App
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct ContentView: View {
  @StateObject private var wcManager = WatchWCManager.shared
  @StateObject private var movementFormState = MovementFormState()

  var body: some View {
    NavigationStack {
      if wcManager.isDataAvailable {
        HomeView()
      } else {
        SyncView()
      }
    }
    .environmentObject(movementFormState)
  }
}
