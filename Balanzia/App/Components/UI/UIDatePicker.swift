//
//  UIDateInput.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import SwiftUI

struct UIDateInput: View {
  var title: String
  @Binding var value: Date
  var displayedComponents: DatePickerComponents = .date
  var disabled: Bool = false

  @State private var showingPicker = false

  private var formattedDate: String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter.string(from: value)
  }

  var body: some View {
    VStack {
      Text(title)
        .font(.caption)
        .fontWeight(.semibold)
        .foregroundColor(Color.alto400)
        .frame(maxWidth: .infinity, alignment: .leading)

      Button {
        showingPicker = true
      } label: {
        HStack {
          Text(formattedDate)
            .foregroundColor(disabled ? .gray : .black)
          Spacer()
          Image(systemName: "calendar")
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
      .sheet(isPresented: $showingPicker) {
        DatePicker(
          "",
          selection: $value,
          displayedComponents: displayedComponents
        )
        .labelsHidden()
        .clipped()
        .datePickerStyle(.wheel)
        .presentationDetents([.fraction(0.3)])
      }
    }
  }
}
