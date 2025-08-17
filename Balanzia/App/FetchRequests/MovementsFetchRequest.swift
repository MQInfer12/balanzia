//
//  MovementsFetchRequest.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import CoreData
import SwiftUI

@propertyWrapper
struct MovementsFetchRequest: DynamicProperty {
  @FetchRequest private var movements: FetchedResults<Movement>

  init(
    sortDescriptors: [NSSortDescriptor] = [
      NSSortDescriptor(keyPath: \Movement.date, ascending: false),
      NSSortDescriptor(keyPath: \Movement.createdAt, ascending: false)
    ],
    animation: Animation? = .default
  ) {
    _movements = FetchRequest(
      sortDescriptors: sortDescriptors,
      animation: animation
    )
  }

  var wrappedValue: FetchedResults<Movement> {
    movements
  }
}
