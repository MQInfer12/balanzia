//
//  ContentView.swift
//  Balanzia
//
//  Created by Mauricio Molina on 09/08/2025.
//

import SwiftUI

struct ContentView: View {
  init() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor(Color.white)

    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
  }

  var body: some View {
    NavigationStack {
      TabView {
        MovementsView()
          .tabItem {
            Label("Movimientos", systemImage: "creditcard")
          }

        ConfigView()
          .tabItem {
            Label("Configuración", systemImage: "gearshape")
          }
      }
    }
  }
}

#Preview {
  ContentView()
}
