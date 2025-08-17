//
//  MovementCategoryForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementCategoryForm: View {
  @State var date = Date()
  @State var amount = 0.0
  

  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack {
        UINavigationLink(
          emoji: "🍕",
          title: "Alimentación"
        ) {

        }
        UINavigationLink(
          emoji: "💵",
          title: "Salario"
        ) {

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
