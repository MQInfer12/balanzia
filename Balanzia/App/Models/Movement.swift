//
//  Movement.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import CoreData
import Foundation

@objc(Movement)
public class Movement: NSManagedObject {
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

extension Movement: Identifiable {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<Movement> {
    return NSFetchRequest<Movement>(entityName: "Movement")
  }

  @NSManaged public var id: UUID
  @NSManaged public var amount: Double
  @NSManaged public var date: Date
  @NSManaged public var comment: String
  @NSManaged public var createdAt: Date
  @NSManaged public var updatedAt: Date

  @NSManaged public var category: Category
  @NSManaged public var originAccount: Account?
  @NSManaged public var destinationAccount: Account?
}
