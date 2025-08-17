//
//  +Color.swift
//  Balanzia
//
//  Created by Mauricio Molina on 09/08/2025.
//

import SwiftUI

extension Color {
  // Primary scale
  static let primary50 = Color(hex: "#f0f8fe")
  static let primary100 = Color(hex: "#deeefb")
  static let primary200 = Color(hex: "#c4e4f9")
  static let primary300 = Color(hex: "#9bd3f5")
  static let primary400 = Color(hex: "#6bbaef")
  static let primary500 = Color(hex: "#499de8")
  static let primary600 = Color(hex: "#2a7cdb")
  static let primary700 = Color(hex: "#2b6cca")
  static let primary800 = Color(hex: "#2958a4")
  static let primary900 = Color(hex: "#264c82")
  static let primary950 = Color(hex: "#1b2f50")

  // Alto scale
  static let alto50 = Color(hex: "#f7f7f7")
  static let alto100 = Color(hex: "#ededed")
  static let alto200 = Color(hex: "#d9d9d9")
  static let alto300 = Color(hex: "#c8c8c8")
  static let alto400 = Color(hex: "#adadad")
  static let alto500 = Color(hex: "#999999")
  static let alto600 = Color(hex: "#888888")
  static let alto700 = Color(hex: "#7b7b7b")
  static let alto800 = Color(hex: "#676767")
  static let alto900 = Color(hex: "#545454")
  static let alto950 = Color(hex: "#363636")
  static let alto1000 = Color(hex: "#242424")

  // Semantic colors
  static let danger = Color(hex: "#f43f5e")
  static let success = Color(hex: "#10b981")
  static let warning = Color(hex: "#eab308")
}

extension Color {
  init(hex: String) {
    let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    var int: UInt64 = 0
    Scanner(string: hex).scanHexInt64(&int)
    let r: UInt64
    let g: UInt64
    let b: UInt64
    switch hex.count {
    case 6:  // RGB (no alpha)
      (r, g, b) = ((int >> 16) & 0xff, (int >> 8) & 0xff, int & 0xff)
    default:
      (r, g, b) = (0, 0, 0)
    }
    self.init(
      .sRGB,
      red: Double(r) / 255,
      green: Double(g) / 255,
      blue: Double(b) / 255,
      opacity: 1
    )
  }
}
