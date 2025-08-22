//
//  MovementReceiver.swift
//  Balanzia
//
//  Created by Mauricio Molina on 21/08/2025.
//

import SwiftData
import SwiftUI

class MovementReceiver {
  static func receive(modelContext: ModelContext?, from data: [String: Any])
    -> [String: Any]
  {
    guard let context = modelContext else {
      return [
        "status": "error",
        "message": "No deberías poder ver esto",
      ]
    }

    let amount = data["amount"] as? Double ?? 0.0
    let comment = data["comment"] as? String ?? ""

    let date: Date
    if let dateString = data["date"] as? String {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      date = formatter.date(from: dateString) ?? Date()
    } else {
      date = Date()
    }

    guard
      let categoryIdStr = data["categoryId"] as? String,
      let categoryId = UUID(uuidString: categoryIdStr),
      let category = try? context.fetch(
        FetchDescriptor<Category>(
          predicate: #Predicate { $0.id == categoryId }
        )
      ).first
    else {
      return [
        "status": "error",
        "message": "No se encontró la categoría",
      ]
    }

    var originAccount: Account?
    if let originIdStr = data["originAccountId"] as? String,
      let originId = UUID(uuidString: originIdStr)
    {
      guard
        let account = try? context.fetch(
          FetchDescriptor<Account>(
            predicate: #Predicate { $0.id == originId }
          )
        ).first
      else {
        return [
          "status": "error",
          "message": "No se encontró la cuenta de origen",
        ]
      }
      originAccount = account
    }

    var destinationAccount: Account?
    if let destinationIdStr = data["destinationAccountId"] as? String,
      let destinationId = UUID(uuidString: destinationIdStr)
    {
      guard
        let account = try? context.fetch(
          FetchDescriptor<Account>(
            predicate: #Predicate { $0.id == destinationId }
          )
        ).first
      else {
        return [
          "status": "error",
          "message": "No se encontró la cuenta de destino",
        ]
      }
      destinationAccount = account
    }

    let movement = Movement(
      amount: amount,
      date: date,
      comment: comment,
      category: category,
      originAccount: originAccount,
      destinationAccount: destinationAccount
    )

    context.insert(movement)

    do {
      try context.save()
      return [
        "status": "success",
        "message": "Se guardó el movimiento",
      ]
    } catch {
      return [
        "status": "error",
        "message": "Error al guardar el movimiento",
      ]
    }
  }
}
