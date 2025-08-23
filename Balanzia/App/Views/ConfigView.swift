//
//  ConfigView.swift
//  Balanzia
//
//  Created by Mauricio Molina on 09/08/2025.
//

import SwiftData
import SwiftUI

// MARK: - CONFIG VIEW
enum TabType {
  case cuentas, categorias
}

struct ConfigView: View {
  @Query private var accounts: [Account]
  @Query private var categories: [Category]

  @State private var selectedTab: TabType = .cuentas
  @Namespace private var animation

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
    VStack {
      HStack {
        ZStack(alignment: .topLeading) {
          HStack(spacing: 8) {
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

          Text("Configuración")
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
        ScrollView(.horizontal) {
          HStack {
            TabButton(
              title: "Cuentas",
              isSelected: selectedTab == .cuentas,
              namespace: animation
            ) {
              withAnimation(.easeInOut) {
                selectedTab = .cuentas
              }
            }
            TabButton(
              title: "Categorías",
              isSelected: selectedTab == .categorias,
              namespace: animation
            ) {
              withAnimation(.easeInOut) {
                selectedTab = .categorias
              }
            }
          }
          .padding(.horizontal)
        }

        ZStack {
          Group {
            if selectedTab == .cuentas {
              AccountCardList(accounts: accounts)
            } else {
              CategoryCardList(categories: categories)
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity)

          NavigationLink(destination: {
            if selectedTab == .cuentas {
              AccountForm()
                .navigationTitle("Añadir cuenta")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.alto100, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            } else {
              CategoryForm()
                .navigationTitle("Añadir categoría")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.alto100, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
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
    .onAppear {
      WCManager.shared.sync(accounts: accounts, categories: categories)
    }
  }
}

// MARK: - TAB BUTTON
struct TabButton: View {
  let title: String
  let isSelected: Bool
  let namespace: Namespace.ID
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      VStack {
        Text(title)
          .font(.subheadline)
          .foregroundColor(isSelected ? .primary600 : .alto400)
          .padding(.horizontal)
          .padding(.top)
          .padding(.bottom, 4)
        ZStack {
          if isSelected {
            Rectangle()
              .fill(Color.primary600)
              .matchedGeometryEffect(id: "underline", in: namespace)
              .frame(height: 2)
          } else {
            Color.clear.frame(height: 2)
          }
        }
      }
    }
  }
}
