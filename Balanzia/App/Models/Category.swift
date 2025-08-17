//
//  Category.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import Foundation
import SwiftData

@Model
class Category {
  @Attribute(.unique) var id: UUID
  var name: String
  var type: String
  var emoji: String
  var createdAt: Date
  var updatedAt: Date

  @Relationship(deleteRule: .cascade, inverse: \Movement.category)
  var movements: [Movement] = []

  var typeEnum: CategoryType {
    get { CategoryType(rawValue: type) ?? .income }
    set { type = newValue.rawValue }
  }

  init(
    name: String,
    type: String,
    emoji: String
  ) {
    self.id = UUID()
    self.name = name
    self.type = type
    self.emoji = emoji
    self.createdAt = Date()
    self.updatedAt = Date()
  }
}

extension Category {
  func update(name: String? = nil, type: String? = nil, emoji: String? = nil) {
    if let name = name { self.name = name }
    if let type = type { self.type = type }
    if let emoji = emoji { self.emoji = emoji }
    self.updatedAt = Date()
  }
}

public enum CategoryType: String, CaseIterable, Codable {
  case income = "Ingreso"
  case expense = "Gasto"
  case transfer = "Transferencia"
}
