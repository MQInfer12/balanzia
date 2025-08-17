//
//  MovementForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementAmountForm: View {
  @State var date = Date()
  @State var amount = 0.0

  var body: some View {
    VStack {
      UINumericPicker(title: "Monto", value: $amount)
      UIDatePicker(title: "Fecha", value: $date)
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        NavigationLink(destination: MovementCategoryForm()) {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
      }
    }
    .navigationTitle {
      Text("Monto")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}
