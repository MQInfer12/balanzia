//
//  MovementOriginAccountForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct MovementOriginAccountForm: View {
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
          MovementOriginAccountFormList()
        }
      }
    }
    .toolbar {
      ToolbarItem(placement: .confirmationAction) {
        NavigationLink(
          value: form.category?.type == .transfer
            ? "movement_destination_account_form" : "movement_comment_form"
        ) {
          Image(systemName: "checkmark")
            .font(.headline)
            .foregroundColor(Color.primary600)
        }
        .disabled(form.originAccount == nil)
      }
    }
    .navigationTitle {
      Text("Origen")
        .foregroundColor(Color.primary600)
        .font(.caption2)
    }
  }
}

struct MovementOriginAccountFormList: View {
  @StateObject private var wcManager = WatchWCManager.shared

  @EnvironmentObject var form: MovementFormState

  var body: some View {
    if let accounts = wcManager.accounts {
      Text("Cuenta de origen")
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)

      VStack {
        ForEach(accounts) { account in
          UINavigationLink(
            iconName: account.icon,
            title: account.name,
            value: form.category?.type == .transfer
              ? "movement_destination_account_form" : "movement_comment_form"
          ) {
            form.originAccount = account
          }
        }
      }
    }
  }
}
