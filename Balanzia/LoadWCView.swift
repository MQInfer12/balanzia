//
//  LoadWCView.swift
//  Balanzia
//
//  Created by Mauricio Molina on 19/08/2025.
//

import SwiftUI

struct LoadWCView: View {
  @Environment(\.modelContext) private var modelContext

  var body: some View {
    ContentView()
      .onAppear {
        _ = WCManager.shared
        WCManager.shared.configure(context: modelContext)
      }
  }
}
