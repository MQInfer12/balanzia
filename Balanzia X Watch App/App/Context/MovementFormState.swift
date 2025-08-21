//
//  MovementFormState.swift
//  Balanzia
//
//  Created by Mauricio Molina on 18/08/2025.
//

import SwiftUI
import WatchConnectivity

enum MovementFormStep {
  case amount
  case category
  case originAccount
  case destinationAccount
  case comment
  case completion
}

class MovementFormState: ObservableObject {
  @Published var step: MovementFormStep = .amount

  @Published var date: Date = Date()
  @Published var amount: Double = 0.0
  @Published var category: Category? = nil
  @Published var originAccount: Account? = nil
  @Published var destinationAccount: Account? = nil
  @Published var comment: String = ""

  @Published var completeStatus: [String: String]? = nil

  func save(completion: @escaping (_ response: [String: String]) -> Void) {
    if category == nil {
      completion([
        "status": "error",
        "message": "Category not selected",
      ])
      return
    }

    let movementInfo: [String: Any] = {
      let dateFormatter = DateFormatter()
      dateFormatter.calendar = Calendar(identifier: .gregorian)
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "yyyy-MM-dd"

      var dict: [String: Any] = [
        "amount": amount,
        "date": dateFormatter.string(from: date),
        "comment": comment,
      ]
      if let categoryId = category?.id.uuidString {
        dict["categoryId"] = categoryId
      }
      if let originAccountId = originAccount?.id.uuidString {
        dict["originAccountId"] = originAccountId
      }
      if let destinationAccountId = destinationAccount?.id.uuidString {
        dict["destinationAccountId"] = destinationAccountId
      }
      return dict
    }()

    if WCSession.default.isReachable {
      print("🟡 iPhone reachable, sending movement")
      WCSession.default.sendMessage(["movement": movementInfo]) { reply in
        let status = reply["status"] as? String ?? "error"
        let message = reply["message"] as? String ?? "Error desconocido"
        completion(["status": status, "message": message])
      } errorHandler: { error in
        completion([
          "status": "error",
          "message": "Error al enviar el movimiento",
        ])
      }
    } else {
      print("📤 Movement enqueued")
      WCSession.default.transferUserInfo(["movement": movementInfo])
      completion([
        "status": "success",
        "message":
          "El movimiento se enviará cuando se recupere la conexión con tu iPhone",
      ])
    }
  }

  func reset() {
    date = Date()
    amount = 0.0
    category = nil
    originAccount = nil
    destinationAccount = nil
    comment = ""
    completeStatus = nil
  }
}
