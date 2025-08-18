//
//  Account.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import Foundation
import SwiftData

@Model
class Account: Codable {
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

  enum CodingKeys: String, CodingKey {
    case id, name, type, amount, createdAt, updatedAt
  }

  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let name = try container.decode(String.self, forKey: .name)
    let type = try container.decode(String.self, forKey: .type)
    let amount = try container.decode(Double.self, forKey: .amount)
    self.init(name: name, type: type, amount: amount)
    self.id = try container.decode(UUID.self, forKey: .id)
    self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(type, forKey: .type)
    try container.encode(amount, forKey: .amount)
    try container.encode(createdAt, forKey: .createdAt)
    try container.encode(updatedAt, forKey: .updatedAt)
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
