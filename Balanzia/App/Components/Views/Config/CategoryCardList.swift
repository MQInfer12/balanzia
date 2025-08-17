//
//  CategoryCardList.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import SwiftUI

struct CategoryCardList: View {
  @CategoriesFetchRequest private var categories

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
