//
//  SyncView.swift
//  Balanzia
//
//  Created by Mauricio Molina on 19/08/2025.
//

import SwiftUI

struct SyncView: View {
  @StateObject private var wcManager = WatchWCManager.shared

  var body: some View {
    if wcManager.isSyncing {
      ProgressView("Sincronizando datos con el iPhone...")
        .font(.caption2)
        .opacity(0.6)
        .multilineTextAlignment(.center)
    } else if wcManager.isSyncingError {
      VStack(spacing: 12) {
        Text("No se pudo establecer conexión con tu iPhone")
          .font(.caption2)
          .opacity(0.6)
          .multilineTextAlignment(.center)
        Button("Reintentar") {
          wcManager.requestInitialDataIfNeeded()
        }
      }
    } else {
      Image("AppIcon")
        .resizable()
        .frame(width: 48, height: 48)
        .cornerRadius(8)
    }
  }
}
