//
//  AccountCard.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import SwiftUI

struct AccountCard: View {
  var account: Account

  var body: some View {
    NavigationLink(
      destination: AccountForm(account: account)
        .navigationTitle("Editar cuenta")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.alto100, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    ) {
      HStack {
        ZStack {
          Color.white
          Image(systemName: account.icon)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(.primary500)
        }
        .aspectRatio(1, contentMode: .fit)
        .frame(maxHeight: .infinity)
        .cornerRadius(16)

        VStack(spacing: 4) {
          Text(account.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .fontWeight(.semibold)
            .font(.headline)
            .lineLimit(1)
            .truncationMode(.tail)

          HStack {
            Text(account.type)
              .opacity(0.6)
              .font(.subheadline)

            Spacer()

            Text(account.balance.formattedAsMoney())
              .foregroundColor(Color.primary600)
              .fontWeight(.semibold)
              .font(.subheadline)
          }
        }
        .padding(.horizontal, 16)
      }
      .frame(maxWidth: .infinity)
      .background(Color.alto50)
      .cornerRadius(16)
      .frame(height: 80)
      .shadow(
        color: Color.black.opacity(0.02), radius: 2, x: 0, y: 2
      )
      .foregroundColor(Color.black)
    }
  }
}
