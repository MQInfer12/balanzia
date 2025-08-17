//
//  Button.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import SwiftUI

enum UIButtonType {
  case normal, danger
}

struct UIButton: View {
  var title: String
  var action: () -> Void
  var type: UIButtonType = .normal

  var body: some View {
    Button(action: action) {
      Text(title)
        .font(.subheadline)
        .foregroundColor(.white)
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [
              type == .danger
                ? Color.danger.opacity(0.8) : Color.primary600.opacity(0.8),
              type == .danger
                ? Color.danger.opacity(1) : Color.primary600.opacity(1),
            ]),
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .cornerRadius(12)
    }
  }
}
