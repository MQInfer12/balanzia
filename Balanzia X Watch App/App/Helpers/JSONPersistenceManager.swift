//
//  JSONPersistenceManager.swift
//  Balanzia
//
//  Created by Mauricio Molina on 18/08/2025.
//

import Foundation

struct JSONPersistenceManager {
  static let categoriesURL = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  )[0].appendingPathComponent("categories.json")
  static let accountsURL = FileManager.default.urls(
    for: .documentDirectory,
    in: .userDomainMask
  )[0].appendingPathComponent("accounts.json")

  static func save<T: Encodable>(_ value: T, to url: URL) {
    do {
      let data = try JSONEncoder().encode(value)
      try data.write(to: url, options: .atomic)
      print("🔵 Saved to \(url.lastPathComponent)")
    } catch {
      print("🔴 Error saving \(url.lastPathComponent): \(error)")
    }
  }

  static func load<T: Decodable>(_ type: T.Type, from url: URL) -> T? {
    do {
      let data = try Data(contentsOf: url)
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      print("🟡 No persisted data found for \(url.lastPathComponent)")
      return nil
    }
  }
}
