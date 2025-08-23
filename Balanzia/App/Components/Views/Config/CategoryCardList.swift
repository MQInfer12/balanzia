//
//  CategoryCardList.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import SwiftData
import SwiftUI

struct CategoryCardList: View {
  let categories: [Category]

  var body: some View {
    Group {
      if categories.isEmpty {
        Text("No tienes categorías registradas aún")
          .font(.caption)
          .opacity(0.6)
      } else {
        ScrollView(.vertical) {
          VStack(spacing: 12) {
            ForEach(CategoryType.allCases, id: \.self) { type in
              let filteredCategories = categories.filter { $0.typeEnum == type }

              if !filteredCategories.isEmpty {
                Text(type.rawValue)
                  .font(.caption)
                  .fontWeight(.medium)
                  .opacity(0.5)
                  .frame(maxWidth: .infinity, alignment: .leading)

                ForEach(filteredCategories) { category in
                  CategoryCard(category: category)
                }
              }
            }
          }
          .padding()
          .padding(.bottom, 72)
        }
      }
    }
  }
}
