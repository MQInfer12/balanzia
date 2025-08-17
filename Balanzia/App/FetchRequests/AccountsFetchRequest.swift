//
//  AccountFetchRequest.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import CoreData
import SwiftUI

@propertyWrapper
struct AccountsFetchRequest: DynamicProperty {
  @FetchRequest private var accounts: FetchedResults<Account>

  init(
    sortDescriptors: [NSSortDescriptor] = [
      NSSortDescriptor(keyPath: \Account.createdAt, ascending: true)
    ],
    animation: Animation? = .default
  ) {
    _accounts = FetchRequest(
      sortDescriptors: sortDescriptors,
      animation: animation
    )
  }

  var wrappedValue: FetchedResults<Account> {
    accounts
  }
}
