//
//  Account.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import CoreData
import Foundation

@objc(Account)
public class Account: NSManagedObject {
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    id = UUID()
    createdAt = Date()
    updatedAt = Date()
  }

  public override func willSave() {
    super.willSave()
    let keysChanged = changedValues().keys.filter { $0 != "updatedAt" }
    if !keysChanged.isEmpty {
      setPrimitiveValue(Date(), forKey: "updatedAt")
    }
  }
}

extension Account: Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Account> {
    return NSFetchRequest<Account>(entityName: "Account")
  }

  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var type: String
  @NSManaged public var amount: Double
  @NSManaged public var createdAt: Date
  @NSManaged public var updatedAt: Date

  @NSManaged public var originMovements: Set<Movement>
  @NSManaged public var destinationMovements: Set<Movement>
}

extension Account {
  public var total: Double {
    var calc = amount
    calc -= originMovements.reduce(0) { $0 + $1.amount }
    calc += destinationMovements.reduce(0) { $0 + $1.amount }
    return calc
  }

  public var typeEnum: AccountType {
    get {
      return AccountType(rawValue: type) ?? .cash
    }
    set {
      type = newValue.rawValue
    }
  }

  var icon: String {
    switch typeEnum {
    case .cash:
      return "dollarsign.circle.fill"
    case .bank:
      return "building.columns.fill"
    case .receivable:
      return "arrow.up.right.circle.fill"
    case .payable:
      return "arrow.down.left.circle.fill"
    }
  }
}

public enum AccountType: String, CaseIterable, Codable {
  case cash = "Efectivo"
  case bank = "Banco"
  case receivable = "Por cobrar"
  case payable = "Por pagar"
}
