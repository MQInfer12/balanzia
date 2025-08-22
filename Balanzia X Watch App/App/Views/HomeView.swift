//
//  HomeView.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

class NavigationState: ObservableObject {
  @Published var path = NavigationPath()
}

struct HomeView: View {
  @StateObject var navState = NavigationState()

  var body: some View {
    NavigationStack(path: $navState.path) {
      ScrollView(.vertical, showsIndicators: true) {
        VStack {
          Text("Balanzia")
            .font(.title2)
            .foregroundColor(Color.primary600)
            .frame(maxWidth: .infinity, alignment: .leading)

          VStack {
            UINavigationLink(
              iconName: "plus",
              title: "Añadir movimiento",
              value: "movement_amount_form"
            )
          }
        }
      }
      .navigationDestination(for: String.self) { route in
        switch route {
        case "movement_amount_form":
          MovementAmountForm()
        case "movement_category_form":
          MovementCategoryForm()
        case "movement_origin_account_form":
          MovementOriginAccountForm()
        case "movement_destination_account_form":
          MovementDestinationAccountForm()
        case "movement_comment_form":
          MovementCommentForm()
        case "movement_form_completion":
          MovementFormCompletion()
        default:
          EmptyView()
        }
      }
      .toolbar {
        ToolbarItem(placement: .confirmationAction) {
          NavigationLink(destination: MovementAmountForm()) {
            Image(systemName: "plus")
              .font(.headline)
              .foregroundColor(Color.primary600)
          }
        }
      }
    }
    .environmentObject(navState)
  }
}
