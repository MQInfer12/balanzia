//
//  Movement.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import Foundation
import SwiftData

@Model
class Movement {
  @Attribute(.unique) var id: UUID
  var amount: Double
  var date: Date
  var comment: String
  var createdAt: Date
  var updatedAt: Date

  var category: Category
  var originAccount: Account?
  var destinationAccount: Account?

  init(
    amount: Double,
    date: Date,
    comment: String = "",
    category: Category,
    originAccount: Account? = nil,
    destinationAccount: Account? = nil
  ) {
    self.id = UUID()
    self.amount = amount
    self.date = date
    self.comment = comment
    self.createdAt = Date()
    self.updatedAt = Date()
    self.category = category
    self.originAccount = originAccount
    self.destinationAccount = destinationAccount
  }
}

extension Movement {
  func update(
    amount: Double? = nil,
    date: Date? = nil,
    comment: String? = nil,
    category: Category? = nil,
    originAccount: Account? = nil,
    destinationAccount: Account? = nil
  ) {
    if let amount = amount { self.amount = amount }
    if let date = date { self.date = date }
    if let comment = comment { self.comment = comment }
    if let category = category { self.category = category }
    if let originAccount = originAccount {
      self.originAccount = originAccount
    }
    if let destinationAccount = destinationAccount {
      self.destinationAccount = destinationAccount
    }
    self.updatedAt = Date()
  }
}
