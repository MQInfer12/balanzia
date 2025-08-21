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

  @Published var categories: [Category]? = nil
  @Published var accounts: [Account]? = nil

  private var isActivated = false

  @Published var isSyncing = false
  @Published var isSyncingError = false

  var isDataAvailable: Bool {
    return accounts != nil && categories != nil
  }

  private override init() {
    super.init()
    setupWCSession()
    loadPersistedData()
  }

  private func setupWCSession() {
    guard WCSession.isSupported() else { return }

    let session = WCSession.default
    session.delegate = self
    session.activate()
  }

  private func loadPersistedData() {
    if let savedAccounts = JSONPersistenceManager.load(
      [Account].self,
      from: JSONPersistenceManager.accountsURL
    ) {
      self.accounts = savedAccounts
    }

    if let savedCategories = JSONPersistenceManager.load(
      [Category].self,
      from: JSONPersistenceManager.categoriesURL
    ) {
      self.categories = savedCategories
    }
  }

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    DispatchQueue.main.async {
      if activationState == .activated {
        self.isActivated = true
        print("🟢 Watch WC Session activated")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
          self.requestInitialDataIfNeeded()
        }
      } else if let error = error {
        print("🔴 Watch WC activation error: \(error)")
      }
    }
  }

  func requestInitialDataIfNeeded() {
    guard !isDataAvailable else {
      return
    }

    isSyncing = true
    print("🔄 Syncing initial data with iPhone...")
    WCSession.default.sendMessage(
      ["request": "initialData"],
      replyHandler: { [weak self] response in
        print("📥 Received initial data from iOS")
        DispatchQueue.main.async {
          self?.handleContext(response)
          self?.isSyncing = false
          self?.isSyncingError = false
        }
      },
      errorHandler: { [weak self] error in
        print("🔴 Error requesting initial data: \(error)")
        DispatchQueue.main.async {
          self?.isSyncing = false
          self?.isSyncingError = true
        }
      }
    )
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
    if let json = context["accounts"] as? [Any],
      let data = try? JSONSerialization.data(withJSONObject: json),
      let decoded = try? JSONDecoder().decode([Account].self, from: data)
    {
      print("🟢 Accounts decoded successfully")
      DispatchQueue.main.async {
        self.accounts = decoded
        JSONPersistenceManager.save(
          decoded,
          to: JSONPersistenceManager.accountsURL
        )
      }
    }

    if let json = context["categories"] as? [Any],
      let data = try? JSONSerialization.data(withJSONObject: json),
      let decoded = try? JSONDecoder().decode([Category].self, from: data)
    {
      print("🟢 Categories decoded successfully")
      DispatchQueue.main.async {
        self.categories = decoded
        JSONPersistenceManager.save(
          decoded,
          to: JSONPersistenceManager.categoriesURL
        )
      }
    }
  }
}
