//
//  MovementCard.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import SwiftUI

public struct MovementCard: View {
  var movement: Movement

  public var body: some View {
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
          .foregroundColor(
            movement.category.typeEnum == .income
              ? .success
              : movement.category.typeEnum == .expense
                ? .danger
                : .warning
          )

        VStack {
          HStack {
            HStack {
              Text(movement.category.emoji)
                .font(.system(size: 12))

              Text(movement.category.name.uppercased())
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

          Text(movement.category.name)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.headline)
            .fontWeight(.bold)
            .padding(.top, 4)
            .padding(.bottom, 1)
            .lineLimit(1)
            .truncationMode(.tail)

          HStack(alignment: .bottom) {
            VStack(alignment: .leading) {
              if let originAccount = movement.originAccount {
                HStack(spacing: 4) {
                  Text("Origen")
                    .font(.caption)
                    .opacity(0.6)
                    .fontWeight(.semibold)

                  Text(originAccount.name)
                    .font(.caption)
                    .opacity(0.8)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                }
              }
              if let destinationAccount = movement.destinationAccount {
                HStack(spacing: 4) {
                  Text("Destino")
                    .font(.caption)
                    .opacity(0.6)
                    .fontWeight(.semibold)

                  Text(destinationAccount.name)
                    .font(.caption)
                    .opacity(0.8)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .truncationMode(.tail)
                }
              }
            }

            Spacer()

            Text(movement.amount.formattedAsMoney())
              .foregroundColor(
                movement.category.typeEnum == .income
                  ? .success
                  : movement.category.typeEnum == .expense
                    ? .danger
                    : .warning
              )
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
