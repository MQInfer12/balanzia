//
//  MovementsView.swift
//  Balanzia
//
//  Created by Mauricio Molina on 09/08/2025.
//

import SwiftData
import SwiftUI

struct MovementsView: View {
  @Query private var accounts: [Account]

  var available: Double {
    let incomes =
      accounts
      .filter { $0.typeEnum == .cash || $0.typeEnum == .bank }
      .reduce(0.0) { $0 + $1.balance }
    return incomes
  }

  var net: Double {
    let incomes =
      accounts
      .filter {
        $0.typeEnum == .cash
          || $0.typeEnum == .bank
          || $0.typeEnum == .receivable
      }
      .reduce(0.0) { $0 + $1.balance }
    let debts =
      accounts
      .filter {
        $0.typeEnum == .payable
      }
      .reduce(0.0) { $0 + $1.balance }
    return incomes - debts
  }

  var body: some View {
    NavigationView {
      VStack {
        HStack {
          ZStack(alignment: .topLeading) {
            HStack(alignment: .center, spacing: 8) {
              Image("AppIcon")
                .resizable()
                .frame(width: 24, height: 24)
                .cornerRadius(4)
              Text("Balanzia")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
            }
            .padding(.top, 8)
            .padding(.leading, 16)

            Text("Movimientos")
              .font(.title2)
              .fontWeight(.bold)
              .foregroundStyle(.white)
              .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .center
              )
          }
        }
        .frame(height: 144)
        .frame(maxWidth: .infinity)
        .background(Color.primary500.gradient)

        ZStack {
          HStack {
            VStack {
              Text(available.formattedAsMoney())
                .fontWeight(.bold)
              Text("Disponible")
                .opacity(0.6)
                .font(.caption)
            }

            Spacer()

            VStack {
              Text(net.formattedAsMoney())
                .fontWeight(.bold)
              Text("Neto")
                .opacity(0.6)
                .font(.caption)
            }
          }
          .frame(maxWidth: .infinity)
          .padding()
          .padding(.horizontal, 24)
          .background(Color.white)
          .cornerRadius(16)
          .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 2)
        }
        .padding(.horizontal, 32)
        .frame(height: 0)
        .zIndex(10)

        VStack(spacing: 0) {
          ZStack {
            Group {
              MovementCardList()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            NavigationLink(destination: {
              MovementForm()
                .navigationTitle("Añadir movimiento")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.alto100, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }) {
              Image(systemName: "plus")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 56, height: 56)
                .background(Color.primary600)
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding()
            .frame(
              maxWidth: .infinity,
              maxHeight: .infinity,
              alignment: .bottomTrailing
            )
          }
        }
        .padding(.top, 40)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.alto100.ignoresSafeArea())
    }
  }
}
