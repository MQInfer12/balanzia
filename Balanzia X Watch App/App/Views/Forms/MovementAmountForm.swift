//
//  MovementForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementAmountForm: View {
  @EnvironmentObject var form: MovementFormState
  @Environment(\.dismiss) private var dismiss

  var body: some View {
    VStack {
      UINumericPicker(title: "Monto", value: $form.amount)
      UIDatePicker(title: "Fecha", value: $form.date)
    }
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button {
          dismiss()
          form.reset()
        } label: {
          Image(systemName: "xmark")
            .font(.headline)
        }
      }

      ToolbarItem(placement: .confirmationAction) {
        NavigationLink(destination: MovementCategoryForm()) {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .navigationTitle {
      Text("Monto")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}
