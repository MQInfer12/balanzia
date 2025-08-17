//
//  DatePicker.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct UIDatePicker: View {
  var title: String
  @Binding var value: Date

  var body: some View {
    VStack {
      Text(title)
        .font(.caption2)
        .fontWeight(.semibold)
        .foregroundColor(.gray)
        .frame(maxWidth: .infinity, alignment: .leading)

      DatePicker(
        "Fecha",
        selection: $value,
        displayedComponents: [.date]
      )
      .labelsHidden()
    }
  }
}

private let dateFormatter: DateFormatter = {
  let formatter = DateFormatter()
  formatter.dateStyle = .medium
  return formatter
}()
