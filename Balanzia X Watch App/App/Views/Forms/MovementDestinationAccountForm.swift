//
//  MovementOriginAccountForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementDestinationAccountForm: View {
  @StateObject private var wcManager = WatchWCManager.shared

  @EnvironmentObject var form: MovementFormState

  var body: some View {
    Group {
      if let accounts = wcManager.accounts, accounts.isEmpty {
        VStack {
          Text("Registra cuentas en el iPhone")
            .font(.caption2)
            .opacity(0.6)
            .multilineTextAlignment(.center)
        }
      } else {
        ScrollView(.vertical, showsIndicators: true) {
          MovementDestinationAccountFormList()
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        NavigationLink(value: "movement_comment_form") {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
        .disabled(form.destinationAccount == nil)
      }
    }
    .navigationTitle {
      Text("Destino")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}

struct MovementDestinationAccountFormList: View {
  @StateObject private var wcManager = WatchWCManager.shared

  @EnvironmentObject var form: MovementFormState

  var body: some View {
    if let accounts = wcManager.accounts {
      Text("Cuenta de destino")
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)

      VStack {
        ForEach(accounts) { account in
          let active = account.id == form.destinationAccount?.id

          UINavigationLink(
            iconName: account.icon,
            title: account.name,
            active: active,
            value: "movement_comment_form"
          ) {
            form.destinationAccount = account
          }
        }
      }
    }
  }
}
