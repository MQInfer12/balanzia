//
//  MovementCategoryForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementCategoryForm: View {
  @StateObject private var wcManager = WatchWCManager.shared

  @EnvironmentObject var form: MovementFormState

  var body: some View {
    Group {
      if let categories = wcManager.categories, categories.isEmpty {
        VStack {
          Text("Registra categorías en el iPhone")
            .font(.caption2)
            .opacity(0.6)
            .multilineTextAlignment(.center)
        }
      } else {
        ScrollView(.vertical, showsIndicators: true) {
          MovementCategoryFormList()
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        NavigationLink(destination: {
          if form.category?.type == .expense || form.category?.type == .transfer
          {
            MovementOriginAccountForm()
          } else if form.category?.type == .income {
            MovementDestinationAccountForm()
          }
        }) {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
        .disabled(form.category == nil)
      }
    }
    .navigationTitle {
      Text("Categoría")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}

struct MovementCategoryFormList: View {
  @StateObject private var wcManager = WatchWCManager.shared

  @EnvironmentObject var form: MovementFormState

  var body: some View {
    if let categories = wcManager.categories {
      VStack {
        Text("Categoría")
          .font(.caption2)
          .fontWeight(.semibold)
          .foregroundColor(.gray)
          .frame(maxWidth: .infinity, alignment: .leading)

        ForEach(categories) { category in
          let active = category.id == form.category?.id

          UINavigationLink(
            emoji: category.emoji,
            title: category.name,
            active: active
          ) {
            if category.type == .expense || category.type == .transfer {
              MovementOriginAccountForm()
            } else if category.type == .income {
              MovementDestinationAccountForm()
            }
          } action: {
            if category.type != .expense && category.type != .transfer {
              form.originAccount = nil
            }
            if category.type != .income && category.type != .transfer {
              form.destinationAccount = nil
            }
            form.category = category
          }
        }
      }
    }
  }
}
