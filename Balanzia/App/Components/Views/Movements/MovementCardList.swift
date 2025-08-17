//
//  MovementCardList.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import SwiftUI

struct MovementCardList: View {
  @MovementsFetchRequest private var movements

  var body: some View {
    if movements.isEmpty {
      Text("No tienes movimientos registrados aún")
        .font(.caption)
        .opacity(0.6)
    } else {
      ScrollView(.vertical) {
        VStack(spacing: 12) {
          ForEach(movements) { movement in
            MovementCard(movement: movement)
          }
        }
        .padding()
        .padding(.bottom, 72)
      }
    }
  }
}
