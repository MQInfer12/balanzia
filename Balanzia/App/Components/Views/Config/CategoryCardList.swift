//
//  CategoryCardList.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import SwiftData
import SwiftUI

struct CategoryCardList: View {
  @Query private var categories: [Category]

  var body: some View {
    if categories.isEmpty {
      Text("No tienes categorías registradas aún")
        .font(.caption)
        .opacity(0.6)
    } else {
      ScrollView(.vertical) {
        VStack(spacing: 12) {
          ForEach(categories) { category in
            CategoryCard(category: category)
          }
        }
        .padding()
        .padding(.bottom, 72)
      }
    }
  }
}
