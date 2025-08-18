//
//  Category.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import Foundation

struct Category: Codable, Identifiable {
  var id: UUID
  var name: String
  var type: CategoryType
  var emoji: String
  var createdAt: Date
  var updatedAt: Date
}

public enum CategoryType: String, CaseIterable, Codable {
  case income = "Ingreso"
  case expense = "Gasto"
  case transfer = "Transferencia"
}
