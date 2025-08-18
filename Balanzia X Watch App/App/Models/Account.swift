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
  var type: String
  var amount: Double
  var createdAt: Date
  var updatedAt: Date
}
