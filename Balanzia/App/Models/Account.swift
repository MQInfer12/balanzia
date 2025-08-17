//
//  Account.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import Foundation
import SwiftData

@Model
class Account {
  @Attribute(.unique) var id: UUID
  var name: String
  var type: String
  var amount: Double
  var createdAt: Date
  var updatedAt: Date

  @Relationship(deleteRule: .cascade, inverse: \Movement.originAccount)
  var originMovements: [Movement] = []
  @Relationship(deleteRule: .cascade, inverse: \Movement.destinationAccount)
  var destinationMovements: [Movement] = []

  var balance: Double {
    var calc = amount
    calc -= originMovements.reduce(0) { $0 + $1.amount }
    calc += destinationMovements.reduce(0) { $0 + $1.amount }
    return calc
  }

  var typeEnum: AccountType {
    get { AccountType(rawValue: type) ?? .cash }
    set { type = newValue.rawValue }
  }

  var icon: String {
    switch typeEnum {
    case .cash: return "dollarsign.circle.fill"
    case .bank: return "building.columns.fill"
    case .receivable: return "arrow.up.right.circle.fill"
    case .payable: return "arrow.down.left.circle.fill"
    }
  }

  init(
    name: String,
    type: String,
    amount: Double
  ) {
    self.id = UUID()
    self.name = name
    self.type = type
    self.amount = amount
    self.createdAt = Date()
    self.updatedAt = Date()
  }
}

extension Account {
  func update(name: String? = nil, type: String? = nil, amount: Double? = nil) {
    if let name = name { self.name = name }
    if let type = type { self.type = type }
    if let amount = amount { self.amount = amount }
    self.updatedAt = Date()
  }
}

public enum AccountType: String, CaseIterable, Codable {
  case cash = "Efectivo"
  case bank = "Banco"
  case receivable = "Por cobrar"
  case payable = "Por pagar"
}
