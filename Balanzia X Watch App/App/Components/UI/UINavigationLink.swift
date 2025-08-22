//
//  UINavigationLink.swift
//  Balanzia
//
//  Created by Mauricio Molina on 17/08/2025.
//

import SwiftUI

struct UINavigationLink: View {
  let iconName: String?
  let emoji: String?
  let title: String
  let active: Bool?
  let value: String
  let action: (() -> Void)?

  @State private var isActive = false

  init(
    iconName: String? = nil,
    emoji: String? = nil,
    title: String,
    active: Bool? = nil,
    value: String,
    action: (() -> Void)? = nil,
  ) {
    self.iconName = iconName
    self.emoji = emoji
    self.title = title
    self.active = active
    self.value = value
    self.action = action
  }

  var body: some View {
    NavigationLink(value: value) {
      HStack {
        if let emoji = emoji {
          Text(emoji)
            .font(.system(size: 20))
            .foregroundColor(.white)
        }

        if let iconName = iconName {
          Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.primary600)
            .frame(width: 24, height: 24)
        }

        Text(title)
          .font(.caption2)
          .foregroundColor(.white)
          .lineLimit(1)
          .truncationMode(.tail)

        Spacer()

        if let active = active, active {
          Image(systemName: "checkmark.circle")
            .font(.headline)
            .foregroundColor(Color.primary600)
            .frame(width: 24, height: 24)
        }
      }
      .padding()
      .frame(maxWidth: .infinity)
      .background(Color.gray.opacity(0.25))
      .cornerRadius(12)
      .overlay(
        RoundedRectangle(cornerRadius: 12)
          .stroke(active == true ? Color.primary600 : Color.clear, lineWidth: 2)
      )
    }
    .buttonStyle(PlainButtonStyle())
    .simultaneousGesture(
      TapGesture().onEnded {
        action?()
      }
    )
  }
}
