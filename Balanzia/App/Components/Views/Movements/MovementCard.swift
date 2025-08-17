//
//  MovementCard.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import SwiftUI

public struct MovementCard: View {
  var movement: Movement

  var accentColor: Color {
    guard let category = movement.category else {
      return .primary600
    }
    switch category.typeEnum {
    case .income: return .success
    case .expense: return .danger
    case .transfer: return .warning
    }
  }

  public var body: some View {
    if let category = movement.category {
      NavigationLink(
        destination: MovementForm(movement: movement)
          .navigationTitle("Editar movimiento")
          .navigationBarTitleDisplayMode(.inline)
          .toolbarBackground(Color.alto100, for: .navigationBar)
          .toolbarBackground(.visible, for: .navigationBar)
      ) {
        HStack {
          Rectangle()
            .frame(maxHeight: .infinity)
            .frame(width: 8)
            .foregroundColor(accentColor)

          VStack {
            HStack {
              HStack {
                Text(category.emoji)
                  .font(.system(size: 12))

                Text(category.name.uppercased())
                  .font(.caption)
                  .fontWeight(.bold)
                  .opacity(0.6)
              }

              Spacer()

              Text(
                movement.date,
                format: .dateTime.month(.abbreviated).day().year()
              )
              .font(.caption)
              .fontWeight(.bold)
              .opacity(0.6)
            }

            Text(category.name)
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(.headline)
              .fontWeight(.bold)
              .padding(.top, 4)
              .padding(.bottom, 1)
              .lineLimit(1)
              .truncationMode(.tail)

            HStack(alignment: .bottom) {
              VStack(alignment: .leading) {
                AccountText(
                  title: "Origen",
                  account: movement.originAccount
                )
                AccountText(
                  title: "Destino",
                  account: movement.destinationAccount
                )
              }

              Spacer()

              Text(movement.amount.formattedAsMoney())
                .foregroundColor(accentColor)
                .fontWeight(.semibold)
                .font(.subheadline)
            }

            if !movement.comment.isEmpty {
              Text(movement.comment)
                .font(.caption)
                .opacity(0.8)
                .padding(.top, 3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
            }
          }
          .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.alto50)
        .cornerRadius(16)
        .shadow(
          color: Color.black.opacity(0.02), radius: 2, x: 0, y: 2
        )
        .foregroundColor(Color.black)
      }
    }
  }
}

// MARK: - ACCOUNT TEXT
struct AccountText: View {
  let title: String
  let account: Account?

  var body: some View {
    if let account = account {
      HStack(spacing: 4) {
        Text(title)
          .font(.caption)
          .opacity(0.6)
          .fontWeight(.semibold)

        Text(account.name)
          .font(.caption)
          .opacity(0.8)
          .fontWeight(.bold)
          .lineLimit(1)
          .truncationMode(.tail)
      }
    }
  }
}
