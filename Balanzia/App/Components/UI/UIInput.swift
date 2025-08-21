//
//  UIInput.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import SwiftUI

struct UIInput: View {
  enum InputType {
    case normal
    case numeric
    case emoji
  }

  var title: String
  @Binding var value: String
  var type: InputType = .normal

  @FocusState private var isFocused: Bool

  var body: some View {
    VStack {
      Text(title)
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundColor(Color.alto400)
        .frame(maxWidth: .infinity, alignment: .leading)

      TextField("", text: $value)
        .keyboardType(keyboardType(for: type))
        .onChange(of: value) { _, newValue in
          switch type {
          case .numeric:
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            var filtered = ""
            var separatorUsed = false
            var decimalCount = 0

            for char in newValue {
              if char.isNumber {
                if separatorUsed {
                  if decimalCount < 2 {
                    filtered.append(char)
                    decimalCount += 1
                  }
                } else {
                  filtered.append(char)
                }
              } else if String(char) == decimalSeparator && !separatorUsed {
                filtered.append(char)
                separatorUsed = true
              }
            }

            value = filtered

          case .emoji:
            if let lastEmoji = newValue.filter({ $0.isEmoji }).last {
              value = String(lastEmoji)
            }

          case .normal:
            break
          }
        }
        .padding()
        .background(Color.white)
        .focused($isFocused)
        .onTapGesture {
          isFocused = true
        }
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.alto200, lineWidth: 1)
        )
    }
  }

  private func keyboardType(for type: InputType) -> UIKeyboardType {
    switch type {
    case .numeric: return .decimalPad
    default: return .default
    }
  }
}

// Extensión para detectar emojis
extension Character {
  var isEmoji: Bool {
    unicodeScalars.contains {
      $0.properties.isEmoji
        && ($0.value > 0x238C || $0.value == 0x00A9 || $0.value == 0x00AE)
    }
  }
}
