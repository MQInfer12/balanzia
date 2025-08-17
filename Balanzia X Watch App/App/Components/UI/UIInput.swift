//
//  UIInput.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct UIInput: View {
  enum InputType {
    case normal
  }

  var title: String
  @Binding var value: String
  var type: InputType = .normal

  var body: some View {
    VStack {
      Text(title)
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)

      TextField("", text: $value)
        .onChange(of: value) { _, newValue in
          switch type {
          case .normal:
            break
          }
        }
    }
    .padding(.vertical, 4)
  }
}
