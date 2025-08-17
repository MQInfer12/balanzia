//
//  ConfigCardList.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import SwiftData
import SwiftUI

struct AccountCardList: View {
  @Query private var accounts: [Account]

  var body: some View {
    if accounts.isEmpty {
      Text("No tienes cuentas registradas aún")
        .font(.caption)
        .opacity(0.6)
    } else {
      ScrollView(.vertical) {
        VStack(spacing: 12) {
          ForEach(accounts) { account in
            AccountCard(account: account)
          }
        }
        .padding()
        .padding(.bottom, 72)
      }
    }
  }
}
