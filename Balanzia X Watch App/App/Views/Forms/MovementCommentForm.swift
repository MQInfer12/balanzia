//
//  MovementCommentForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 18/08/2025.
//

import SwiftUI

struct MovementCommentForm: View {
  @EnvironmentObject var form: MovementFormState

  var body: some View {
    VStack {
      UIInput(title: "Comentario", value: $form.comment)
      Spacer()
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        Button {
          form.save()
        } label: {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
      }
    }
    .navigationTitle {
      Text("Comentario")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}
