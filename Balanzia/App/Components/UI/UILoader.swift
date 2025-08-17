//
//  UILoader.swift
//  Balanzia
//
//  Created by Mauricio Molina on 15/08/2025.
//

import SwiftUI

struct Loader: View {
  let text: String
  let foregroundColor: Color

  init(text: String = "Cargando...", foregroundColor: Color = .black) {
    self.text = text
    self.foregroundColor = foregroundColor
  }

  var body: some View {
    VStack(spacing: 24) {
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: foregroundColor))
        .scaleEffect(2)
      Text(text)
        .font(.caption)
        .foregroundColor(foregroundColor)
    }
  }
}
