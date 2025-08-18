//
//  MovementCategoryForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementCategoryForm: View {
  @StateObject private var wcManager = WatchWCManager.shared

  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack {
        ForEach(wcManager.categories) { category in
          UINavigationLink(
            emoji: category.emoji,
            title: category.name
          ) {
            if category.type == .expense || category.type == .transfer {
              MovementOriginAccountForm()
            } else if category.type == .income {
              MovementDestinationAccountForm()
            }
          }
        }
      }
    }
    .navigationTitle {
      Text("Categoría")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}
