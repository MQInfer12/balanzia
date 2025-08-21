//
//  Account.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import Foundation

struct Account: Codable, Identifiable {
  var id: UUID
  var name: String
  var type: AccountType
  var amount: Double
  var createdAt: Date
  var updatedAt: Date

  var icon: String {
    switch type {
    case .cash: return "dollarsign.circle.fill"
    case .bank: return "building.columns.fill"
    case .receivable: return "arrow.up.right.circle.fill"
    case .payable: return "arrow.down.left.circle.fill"
    }
  }
}

public enum AccountType: String, CaseIterable, Codable {
  case cash = "Efectivo"
  case bank = "Banco"
  case receivable = "Por cobrar"
  case payable = "Por pagar"
}
