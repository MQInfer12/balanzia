//
//  AlertManager.swift
//  Balanzia
//
//  Created by Mauricio Molina on 11/08/2025.
//

import SwiftUI

class AlertManager: ObservableObject {
  @Published var isPresented: Bool = false
  var title: String = ""
  var message: String = ""
  var buttons: [Alert.Button] = []

  func show(
    title: String,
    message: String,
    buttons: [Alert.Button] = [.default(Text("Entendido"))]
  ) {
    self.title = title
    self.message = message
    self.buttons = buttons
    self.isPresented = true
  }
}

struct ManagedAlertModifier: ViewModifier {
  @ObservedObject var alertManager: AlertManager

  func body(content: Content) -> some View {
    content.alert(isPresented: $alertManager.isPresented) {
      if alertManager.buttons.count == 2 {
        return Alert(
          title: Text(alertManager.title),
          message: Text(alertManager.message),
          primaryButton: alertManager.buttons[0],
          secondaryButton: alertManager.buttons[1]
        )
      } else {
        return Alert(
          title: Text(alertManager.title),
          message: Text(alertManager.message),
          dismissButton: alertManager.buttons.first
        )
      }
    }
  }
}

extension View {
  func managedAlert(using alertManager: AlertManager) -> some View {
    self.modifier(ManagedAlertModifier(alertManager: alertManager))
  }
}
