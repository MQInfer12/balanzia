//
//  CategoryCard.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import SwiftUI

struct CategoryCard: View {
  @ObservedObject var category: Category

  private var shouldShow: Bool {
    guard
      !category.isDeleted,
      let context = category.managedObjectContext
    else { return false }
    return context.registeredObjects.contains(category)
  }

  var body: some View {
    if !shouldShow {
      EmptyView()
    } else {
      NavigationLink(
        destination: CategoryForm(category: category)
          .navigationTitle("Editar categoría")
          .navigationBarTitleDisplayMode(.inline)
          .toolbarBackground(Color.alto100, for: .navigationBar)
          .toolbarBackground(.visible, for: .navigationBar)
      ) {
        HStack {
          ZStack {
            Color.white
            Text(category.emoji)
              .font(.system(size: 24))
          }
          .aspectRatio(1, contentMode: .fit)
          .frame(maxHeight: .infinity)
          .cornerRadius(16)

          VStack(spacing: 4) {
            Text(category.name)
              .frame(maxWidth: .infinity, alignment: .leading)
              .fontWeight(.semibold)
              .font(.headline)
              .lineLimit(1)
              .truncationMode(.tail)

            HStack {
              Text(category.type)
                .opacity(0.6)
                .font(.subheadline)

              Spacer()
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
}
