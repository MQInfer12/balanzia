//
//  MovementOriginAccountForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementOriginAccountForm: View {
  @StateObject private var wcManager = WatchWCManager.shared

  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack {
        ForEach(wcManager.accounts) { account in
          UINavigationLink(
            iconName: "plus",
            title: account.name
          ) {

          }
        }
      }
    }
    .navigationTitle {
      Text("Origen")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}
