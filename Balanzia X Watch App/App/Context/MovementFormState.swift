//
//  MovementFormState.swift
//  Balanzia
//
//  Created by Mauricio Molina on 18/08/2025.
//

import SwiftUI
import WatchConnectivity

class MovementFormState: ObservableObject {
  @Published var date: Date = Date()
  @Published var amount: Double = 0.0
  @Published var category: Category? = nil
  @Published var originAccount: Account? = nil
  @Published var destinationAccount: Account? = nil
  @Published var comment: String = ""

  func save() {
    if category == nil {
      print("🔴 Category not selected for some reason")
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

    WCSession.default.transferUserInfo(["movement": movementInfo])
    print("📤 Movement enqueued with transferUserInfo")

    /*if WCSession.default.isReachable {
      WCSession.default.sendMessage(["movement": movementInfo]) { reply in
        print("🟢 Movement sended: \(reply)")
        completion(true)
      } errorHandler: { error in
        print("🔴 Error sending movement: \(error)")
        completion(false)
      }
    } else {
      WCSession.default.transferUserInfo(["movement": movementInfo])
      print("📤 Queue movement using transferUserInfo")
      completion(true)
    }*/
  }

  func reset() {
    date = Date()
    amount = 0.0
    category = nil
    originAccount = nil
    destinationAccount = nil
    comment = ""
  }
}
