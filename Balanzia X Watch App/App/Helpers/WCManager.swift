//
//  WCManager.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import Foundation
import WatchConnectivity

class WatchWCManager: NSObject, ObservableObject, WCSessionDelegate {
  static let shared = WatchWCManager()

  @Published var categories: [Category] = []
  @Published var accounts: [Account] = []

  private override init() {
    super.init()
    if WCSession.isSupported() {
      WCSession.default.delegate = self
      WCSession.default.activate()
    }

    let context = WCSession.default.receivedApplicationContext as [String: Any]
    handleContext(context)
  }

  func session(
    _ session: WCSession,
    didReceiveApplicationContext applicationContext: [String: Any]
  ) {
    print("📥 Application context received")
    handleContext(applicationContext)
  }

  func session(
    _ session: WCSession,
    didReceiveUserInfo userInfo: [String: Any] = [:]
  ) {
    print("📥 User info received")
    handleContext(userInfo)
  }

  private func handleContext(_ context: [String: Any]) {
    if let json = context["categories"] as? [Any],
      let data = try? JSONSerialization.data(withJSONObject: json),
      let decoded = try? JSONDecoder().decode([Category].self, from: data)
    {
      print("✅ Categories decoded successfully")
      DispatchQueue.main.async {
        self.categories = decoded
      }
    } else {
      print("❌ Error decoding categories")
    }

    if let json = context["accounts"] as? [Any],
      let data = try? JSONSerialization.data(withJSONObject: json),
      let decoded = try? JSONDecoder().decode([Account].self, from: data)
    {
      print("✅ Accounts decoded successfully")
      DispatchQueue.main.async {
        self.accounts = decoded
      }
    } else {
      print("❌ Error decoding accounts")
    }
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {}
}
