//
//  PersistenceController.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import CoreData

struct PersistenceController {
  static let shared = PersistenceController()

  let container: NSPersistentContainer

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "BalanziaModel")
    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(
        fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { (_, error) in
      if let error = error as NSError? {
        fatalError("Error al cargar Core Data: \(error), \(error.userInfo)")
      }
    }
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
  }
}
