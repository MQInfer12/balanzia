//
//  HomeView.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct HomeView: View {
  var body: some View {
    NavigationStack {
      ScrollView(.vertical, showsIndicators: true) {
        VStack {
          Text("Balanzia")
            .font(.title2)
            .foregroundColor(Color.primary600)
            .frame(maxWidth: .infinity, alignment: .leading)

          VStack {
            UINavigationLink(
              iconName: "plus",
              title: "Añadir movimiento"
            ) {
              MovementAmountForm()
            }
          }
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
  }
}
