//
//  UISelect.swift
//  Balanzia
//
//  Created by Mauricio Molina on 10/08/2025.
//

import SwiftUI

struct UISelect<T: Hashable>: View {
  var title: String
  var placeholder: String
  var options: [T]
  var label: (T) -> String
  @Binding var value: T?
  var disabled: Bool = false
  var onChange: ((T) -> Void)? = nil

  var body: some View {
    VStack {
      Text(title)
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundColor(Color.alto400)
        .frame(maxWidth: .infinity, alignment: .leading)

      Menu {
        ForEach(options, id: \.self) { option in
          Button(label(option)) {
            value = option
            onChange?(option)
          }
        }
      } label: {
        HStack {
          if let value = value {
            Text(label(value))
              .foregroundColor(disabled ? .gray : .black)
          } else {
            Text(placeholder)
              .foregroundColor(disabled ? .gray : Color.alto300)
          }
          Spacer()
          Image(systemName: "chevron.down")
            .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .overlay(
          RoundedRectangle(cornerRadius: 8)
            .stroke(Color.alto200, lineWidth: 1)
        )
      }
      .disabled(disabled)
    }
  }
}
