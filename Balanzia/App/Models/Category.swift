//
//  Category.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import CoreData
import Foundation

@objc(Category)
public class Category: NSManagedObject {
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

extension Category: Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
    return NSFetchRequest<Category>(entityName: "Category")
  }

  @NSManaged public var id: UUID
  @NSManaged public var name: String
  @NSManaged public var type: String
  @NSManaged public var emoji: String
  @NSManaged public var createdAt: Date
  @NSManaged public var updatedAt: Date

  @NSManaged public var movements: Set<Movement>
}

extension Category {
  public var typeEnum: CategoryType {
    get {
      return CategoryType(rawValue: type) ?? .income
    }
    set {
      type = newValue.rawValue
    }
  }
}

public enum CategoryType: String, CaseIterable, Codable {
  case income = "Ingreso"
  case expense = "Gasto"
  case transfer = "Transferencia"
}
