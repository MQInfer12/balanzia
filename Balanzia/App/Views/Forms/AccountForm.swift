//
//  AccountForm.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import SwiftUI

struct AccountForm: View {
  @Environment(\.managedObjectContext) private var viewContext
  @Environment(\.dismiss) private var dismiss

  @StateObject private var alertManager = AlertManager()

  var account: Account?
  @State private var isEditing = false

  @State private var name: String = ""
  @State private var type: String? = nil
  @State private var amount: String = ""

  var body: some View {
    VStack {
      ScrollView(.vertical) {
        VStack(spacing: 16) {
          UIInput(
            title: "NOMBRE *",
            value: $name
          )
          UISelect(
            title: "TIPO DE CUENTA *",
            placeholder: "Seleccionar...",
            options: AccountType.allCases.map { $0.rawValue },
            label: { $0 },
            value: $type
          )
          UIInput(
            title: "MONTO INICIAL",
            value: $amount,
            type: .numeric
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
        UIButton(title: !isEditing ? "Añadir cuenta" : "Guardar cambios") {
          save()
        }
      }
      .padding()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.alto100)
    .onAppear {
      guard let account = account else { return }
      isEditing = true

      name = account.name
      type = account.type

      let decimalSeparator = Locale.current.decimalSeparator ?? "."
      amount = String(account.amount).replacingOccurrences(
        of: ".", with: decimalSeparator
      )
    }
    .toolbar {
      if isEditing {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            deleteAccount()
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

    let targetAccount = account ?? Account(context: viewContext)

    // Campos básicos
    targetAccount.name = name
    targetAccount.type = type ?? ""

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

    targetAccount.amount =
      Double(
        calculatedAmount.replacingOccurrences(of: decimalSeparator, with: ".")
      ) ?? 0.0

    // Fechas
    targetAccount.updatedAt = Date()

    do {
      try viewContext.save()
      dismiss()
    } catch {
      print("Error al guardar cambios: \(error.localizedDescription)")
    }
  }

  private func deleteAccount() {
    guard let account = account else { return }

    let movementCount =
      account.originMovements.count + account.destinationMovements.count

    alertManager.show(
      title: "Eliminar cuenta",
      message:
        "¿Seguro que quieres eliminar la cuenta \"\(account.name)\"?"
        + (movementCount > 0
          ? " Tiene \(movementCount) movimientos asociados que también se eliminarán."
          : ""),
      buttons: [
        .destructive(Text("Eliminar")) {
          viewContext.delete(account)
          try? viewContext.save()
          dismiss()
        },
        .cancel(Text("Cancelar")),
      ]
    )
  }
}
