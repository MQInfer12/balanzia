//
//  CategoriesFetchRequest.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import CoreData
import SwiftUI

@propertyWrapper
struct CategoriesFetchRequest: DynamicProperty {
  @FetchRequest private var categories: FetchedResults<Category>

  init(
    sortDescriptors: [NSSortDescriptor] = [
      NSSortDescriptor(keyPath: \Category.createdAt, ascending: true)
    ],
    animation: Animation? = .default
  ) {
    _categories = FetchRequest(
      sortDescriptors: sortDescriptors,
      animation: animation
    )
  }

  var wrappedValue: FetchedResults<Category> {
    categories
  }
}
