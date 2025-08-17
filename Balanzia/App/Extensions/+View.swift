//
//  +View.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import SwiftUI

struct DisableSwipeBackModifier: UIViewControllerRepresentable {
  var disabled: Bool

  func makeUIViewController(context: Context) -> UIViewController {
    let controller = UIViewController()
    DispatchQueue.main.async {
      if let navigationController = controller.navigationController {
        navigationController.interactivePopGestureRecognizer?.isEnabled =
          !disabled
      }
    }
    return controller
  }

  func updateUIViewController(
    _ uiViewController: UIViewController, context: Context
  ) {
    if let navigationController = uiViewController.navigationController {
      navigationController.interactivePopGestureRecognizer?.isEnabled =
        !disabled
    }
  }
}

extension View {
  func disableSwipeBack(_ disabled: Bool) -> some View {
    background(DisableSwipeBackModifier(disabled: disabled))
  }
}
