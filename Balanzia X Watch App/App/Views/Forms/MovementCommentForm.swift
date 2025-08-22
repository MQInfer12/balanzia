//
//  MovementCommentForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 18/08/2025.
//

import SwiftUI

struct MovementCommentForm: View {
  @EnvironmentObject var form: MovementFormState
  @Environment(\.dismiss) private var dismiss
  @EnvironmentObject var navState: NavigationState

  @State var isLoading = false

  var body: some View {
    VStack {
      if isLoading {
        ProgressView("Guardando movimiento...")
          .font(.caption2)
          .opacity(0.6)
          .multilineTextAlignment(.center)
      } else {
        UIInput(title: "Comentario", value: $form.comment)
        Spacer()
      }
    }
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button {
          dismiss()
        } label: {
          Image(systemName: "chevron.left")
            .font(.headline)
        }
        .disabled(isLoading)
      }

      ToolbarItem(placement: .confirmationAction) {
        Button {
          isLoading = true
          form.save { reply in
            DispatchQueue.main.async {
              form.completeStatus = reply
              navState.path.append("movement_form_completion")
            }
          }
        } label: {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
        .disabled(isLoading)
      }
    }
    .navigationBarBackButtonHidden(true)
    .navigationTitle {
      Text("Comentario")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}
