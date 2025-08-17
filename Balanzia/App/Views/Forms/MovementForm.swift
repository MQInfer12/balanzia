//
//  MovementForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import SwiftUI

struct MovementForm: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss

  @StateObject private var alertManager = AlertManager()

  @AccountsFetchRequest private var accounts
  @CategoriesFetchRequest private var categories

  var movement: Movement?
  @State private var isEditing = false

  @State private var amount: String = ""
  @State private var date = Date()
  @State private var comment: String = ""
  @State private var category: Category? = nil
  @State private var originAccount: Account? = nil
  @State private var destinationAccount: Account? = nil

  var body: some View {
    VStack {
      ScrollView(.vertical) {
        VStack(spacing: 16) {
          UIDateInput(
            title: "FECHA *",
            value: $date
          )
          UIInput(
            title: "MONTO *",
            value: $amount,
            type: .numeric
          )
          UISelect(
            title: "CATEGORÍA *",
            placeholder: "Seleccionar...",
            options: categories.map { $0 },
            label: { $0.emoji + " " + $0.name },
            value: $category,
            onChange: { newCategory in
              if newCategory.typeEnum != .expense
                && newCategory.typeEnum != .transfer
              {
                originAccount = nil
              }

              if newCategory.typeEnum != .income
                && newCategory.typeEnum != .transfer
              {
                destinationAccount = nil
              }
            }
          )

          if category?.typeEnum == .expense || category?.typeEnum == .transfer {
            UISelect(
              title: "CUENTA DE ORIGEN *",
              placeholder: "Seleccionar...",
              options: accounts.map { $0 },
              label: { $0.name },
              value: $originAccount
            )
          }
          if category?.typeEnum == .income || category?.typeEnum == .transfer {
            UISelect(
              title: "CUENTA DE DESTINO *",
              placeholder: "Seleccionar...",
              options: accounts.map { $0 },
              label: { $0.name },
              value: $destinationAccount
            )
          }

          UIInput(
            title: "COMENTARIO",
            value: $comment
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
          title: !isEditing ? "Añadir movimiento" : "Guardar cambios"
        ) {
          save()
        }
      }
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.alto100)
    .onAppear {
      guard let movement = movement else { return }
      isEditing = true

      let decimalSeparator = Locale.current.decimalSeparator ?? "."
      amount = String(movement.amount).replacingOccurrences(
        of: ".", with: decimalSeparator
      )

      date = movement.date
      comment = movement.comment
      category = movement.category
      originAccount = movement.originAccount
      destinationAccount = movement.destinationAccount
    }
    .toolbar {
      if isEditing {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            deleteMovement()
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
    if amount.isEmpty {
      return "Ingresa un monto."
    }
    guard let category = category else {
      return "Ingresa una categoría para el movimiento."
    }
    if (category.typeEnum == .expense || category.typeEnum == .transfer)
      && originAccount == nil
    {
      return "Selecciona una cuenta de origen."
    }
    if (category.typeEnum == .income || category.typeEnum == .transfer)
      && destinationAccount == nil
    {
      return "Selecciona una cuenta de destino."
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

    let targetMovement = movement ?? Movement(context: viewContext)

    // Parseo seguro de monto
    var calculatedAmount = amount
    let decimalSeparator = Locale.current.decimalSeparator ?? "."

    if amount.hasPrefix(decimalSeparator) {
      calculatedAmount = "0" + amount
    }
    if amount.hasSuffix(decimalSeparator) {
      calculatedAmount = amount.replacingOccurrences(
        of: decimalSeparator, with: "")
    }

    targetMovement.amount =
      Double(
        calculatedAmount.replacingOccurrences(of: decimalSeparator, with: ".")
      ) ?? 0.0

    // Campos básicos
    targetMovement.date = date
    targetMovement.comment = comment
    targetMovement.category = category!
    targetMovement.originAccount = originAccount
    targetMovement.destinationAccount = destinationAccount

    do {
      try viewContext.save()
      dismiss()
    } catch {
      print("Error al guardar cambios: \(error.localizedDescription)")
    }
  }

  private func deleteMovement() {
    guard let movement = movement else { return }
    alertManager.show(
      title: "Eliminar movimiento",
      message: "¿Seguro que quieres eliminar este movimiento?",
      buttons: [
        .destructive(Text("Eliminar")) {
          viewContext.delete(movement)
          try? viewContext.save()
          dismiss()
        },
        .cancel(Text("Cancelar")),
      ]
    )
  }
}
