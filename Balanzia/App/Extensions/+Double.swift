//
//  +Double.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import Foundation

extension Double {
  func formattedAsMoney() -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.currencySymbol = "Bs "
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.locale = Locale(identifier: "es_BO")
    return formatter.string(from: NSNumber(value: self)) ?? "Bs 0,00"
  }
}
