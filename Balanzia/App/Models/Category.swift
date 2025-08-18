//
//  Category.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import Foundation
import SwiftData

@Model
class Category: Codable {
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

  enum CodingKeys: String, CodingKey {
    case id, name, type, emoji, createdAt, updatedAt
  }

  required convenience init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let name = try container.decode(String.self, forKey: .name)
    let type = try container.decode(String.self, forKey: .type)
    let emoji = try container.decode(String.self, forKey: .emoji)
    self.init(name: name, type: type, emoji: emoji)
    self.id = try container.decode(UUID.self, forKey: .id)
    self.createdAt = try container.decode(Date.self, forKey: .createdAt)
    self.updatedAt = try container.decode(Date.self, forKey: .updatedAt)
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(name, forKey: .name)
    try container.encode(type, forKey: .type)
    try container.encode(emoji, forKey: .emoji)
    try container.encode(createdAt, forKey: .createdAt)
    try container.encode(updatedAt, forKey: .updatedAt)
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
