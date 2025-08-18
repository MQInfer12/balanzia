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

  private override init() {
    super.init()
    if WCSession.isSupported() {
      WCSession.default.delegate = self
      WCSession.default.activate()
    }
  }

  func syncAccounts(_ accounts: [Account]) {
    let encoder = JSONEncoder()
    guard
      let data = try? encoder.encode(accounts),
      let json = try? JSONSerialization.jsonObject(with: data) as? [Any]
    else { return }

    var context = WCSession.default.applicationContext
    context["accounts"] = json

    do {
      try WCSession.default.updateApplicationContext(context)
      print("✅ Accounts context updated")
    } catch {
      print("❌ Error saving accounts context: \(error)")
    }

    guard WCSession.default.isPaired && WCSession.default.isWatchAppInstalled
    else { return }
    let userInfo: [String: Any] = ["accounts": json]
    WCSession.default.transferUserInfo(userInfo)
    print("📤 Accounts sent")
  }

  func syncCategories(_ categories: [Category]) {
    let encoder = JSONEncoder()
    guard
      let data = try? encoder.encode(categories),
      let json = try? JSONSerialization.jsonObject(with: data) as? [Any]
    else { return }

    var context = WCSession.default.applicationContext
    context["categories"] = json

    do {
      try WCSession.default.updateApplicationContext(context)
      print("✅ Categories context updated")
    } catch {
      print("❌ Error saving categories context: \(error)")
    }

    guard WCSession.default.isPaired && WCSession.default.isWatchAppInstalled
    else { return }
    let userInfo: [String: Any] = ["categories": json]
    WCSession.default.transferUserInfo(userInfo)
    print("📤 Categories sent")
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {}
  func sessionDidBecomeInactive(_ session: WCSession) {}
  func sessionDidDeactivate(_ session: WCSession) {}
}
