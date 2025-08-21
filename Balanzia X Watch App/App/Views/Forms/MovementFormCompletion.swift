//
//  MovementFormCompletion.swift
//  Balanzia
//
//  Created by Mauricio Molina on 20/08/2025.
//

import SwiftUI

struct MovementFormCompletion: View {
  @EnvironmentObject var form: MovementFormState

  var body: some View {
    Group {
      if let completeStatus = form.completeStatus,
        let status = completeStatus["status"],
        let message = completeStatus["message"]
      {
        let isSuccess = status == "success"

        VStack {
          Image(systemName: isSuccess ? "checkmark.circle" : "multiply.circle")
            .resizable()
            .frame(width: 48, height: 48)
            .foregroundColor(isSuccess ? Color.success : Color.danger)

          Text(isSuccess ? "Completado" : "Error")
            .font(.headline)
            .fontWeight(.bold)
            .padding(.top, 12)

          Text(message)
            .font(.caption2)
            .opacity(0.6)
            .multilineTextAlignment(.center)
            .padding(.top, 4)
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .cancellationAction) {
        Button {
        } label: {
          Image(systemName: "house")
            .font(.headline)
        }
      }

      ToolbarItem(placement: .confirmationAction) {
        Button {
        } label: {
          Image(systemName: "goforward.plus")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
  }
}
