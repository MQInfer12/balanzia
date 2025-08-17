//
//  CategoryForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 14/08/2025.
//

import SwiftUI

struct CategoryForm: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss

  @StateObject private var alertManager = AlertManager()

  var category: Category?
  @State private var isEditing = false

  @State private var name: String = ""
  @State private var type: String? = nil
  @State private var emoji: String = ""

  var body: some View {
    VStack {
      ScrollView(.vertical) {
        VStack(spacing: 16) {
          UIInput(
            title: "NOMBRE *",
            value: $name
          )
          UISelect(
            title: "TIPO DE CATEGORÍA *",
            placeholder: "Seleccionar...",
            options: CategoryType.allCases.map { $0.rawValue },
            label: { $0 },
            value: $type
          )
          UIInput(
            title: "EMOJI *",
            value: $emoji,
            type: .emoji
          )
        }
        .padding()
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .padding()
      }

      Spacer()

      VStack {
        UIButton(
          title: !isEditing ? "Añadir categoría" : "Guardar cambios"
        ) {
          save()
        }
      }
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.alto100)
    .onAppear {
      guard let category = category else { return }
      isEditing = true

      name = category.name
      type = category.type
      emoji = category.emoji
    }
    .toolbar {
      if isEditing {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            deleteCategory()
          } label: {
            Image(systemName: "trash")
              .foregroundColor(.red)
          }
        }
      }
    }
    .managedAlert(using: alertManager)
  }

  private func validate() -> String? {
    if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return "Ingresa un nombre de cuenta."
    }
    if type == nil {
      return "Ingresa un tipo de cuenta."
    }
    if emoji.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      return "Ingresa un emoji."
    }
    return nil
  }

  private func save() {
    if let error = validate() {
      alertManager.show(
        title: "Error de validación",
        message: error
      )
      return
    }

    let targetAccount = category ?? Category(context: viewContext)

    // Campos básicos
    targetAccount.name = name
    targetAccount.type = type ?? ""
    targetAccount.emoji = emoji

    do {
      try viewContext.save()
      dismiss()
    } catch {
      print("Error al guardar cambios: \(error.localizedDescription)")
    }
  }

  private func deleteCategory() {
    guard let category = category else { return }

    let movementCount = category.movements.count

    alertManager.show(
      title: "Eliminar categoría",
      message: "¿Seguro que quieres eliminar \"\(category.name)\"?"
        + (movementCount > 0
          ? " Tiene \(movementCount) movimientos asociados que también se eliminarán."
          : ""),
      buttons: [
        .destructive(Text("Eliminar")) {
          viewContext.delete(category)
          try? viewContext.save()
          dismiss()
        },
        .cancel(Text("Cancelar")),
      ]
    )
  }
}
