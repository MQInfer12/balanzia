//
//  WCManager.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import Foundation
import SwiftData
import WatchConnectivity

class WCManager: NSObject, WCSessionDelegate {
  static let shared = WCManager()
  var modelContext: ModelContext?
  private var isActivated = false

  private override init() {
    super.init()
    setupWCSession()
  }

  private func setupWCSession() {
    guard WCSession.isSupported() else { return }

    let session = WCSession.default
    session.delegate = self
    session.activate()
  }

  func configure(context: ModelContext) {
    self.modelContext = context
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    DispatchQueue.main.async {
      if activationState == .activated {
        self.isActivated = true
        print("🟢 iOS WC Session activated")
      } else if let error = error {
        print("🔴 iOS WC activation error: \(error)")
      }
    }
  }

  func fetchData() -> ([Account], [Category]) {
    guard let context = modelContext else { return ([], []) }

    let accounts = (try? context.fetch(FetchDescriptor<Account>())) ?? []
    let categories = (try? context.fetch(FetchDescriptor<Category>())) ?? []

    return (accounts, categories)
  }

  func sync(accounts: [Account], categories: [Category]) {
    let encoder = JSONEncoder()
    print(accounts.count, categories.count)

    guard
      let accountsData = try? encoder.encode(accounts),
      let accountsJSON = try? JSONSerialization.jsonObject(with: accountsData)
        as? [Any]
    else {
      print("🔴 Error encoding accounts")
      return
    }

    guard
      let categoriesData = try? encoder.encode(categories),
      let categoriesJSON = try? JSONSerialization.jsonObject(
        with: categoriesData
      ) as? [Any]
    else {
      print("🔴 Error encoding categories")
      return
    }

    var context = WCSession.default.applicationContext
    context["accounts"] = accountsJSON
    context["categories"] = categoriesJSON

    if WCSession.default.isReachable {
      do {
        try WCSession.default.updateApplicationContext(context)
        print("🟢 Context updated")
      } catch {
        print("🔴 Error saving context: \(error)")
      }
    } else {
      print("🟡 Apple Watch not reachable")
      WCSession.default.transferUserInfo(context)
    }
  }

  func session(
    _ session: WCSession,
    didReceiveUserInfo userInfo: [String: Any] = [:]
  ) {
    if let movementInfo = userInfo["movement"] as? [String: Any] {
      let _ = MovementReceiver.receive(
        modelContext: modelContext,
        from: movementInfo
      )
    }
  }

  func session(
    _ session: WCSession,
    didReceiveMessage message: [String: Any],
    replyHandler: @escaping ([String: Any]) -> Void
  ) {
    if let movementInfo = message["movement"] as? [String: Any] {
      let result = MovementReceiver.receive(
        modelContext: modelContext,
        from: movementInfo
      )
      replyHandler(result)
    }

    if message["request"] as? String == "initialData" {
      let (accounts, categories) = fetchData()

      let encoder = JSONEncoder()
      guard
        let accountsData = try? encoder.encode(accounts),
        let accountsJSON = try? JSONSerialization.jsonObject(with: accountsData)
          as? [Any],
        let categoriesData = try? encoder.encode(categories),
        let categoriesJSON = try? JSONSerialization.jsonObject(
          with: categoriesData
        ) as? [Any]
      else {
        replyHandler([:])
        return
      }

      replyHandler(["accounts": accountsJSON, "categories": categoriesJSON])
    }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}
  func sessionDidDeactivate(_ session: WCSession) {}
}
