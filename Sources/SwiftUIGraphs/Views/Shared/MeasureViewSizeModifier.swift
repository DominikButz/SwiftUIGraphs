//
//  MeasureViewSizeModifier.swift
//  Source: https://swiftuirecipes.com/blog/getting-size-of-a-view-in-swiftui
//
//

import Foundation
import SwiftUI

struct SizePreferenceKey: PreferenceKey {
    
  static var defaultValue: CGSize = .zero

  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
    value = nextValue()
  }
}

struct MeasureSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content.background(GeometryReader { geometry in
        Color.clear.preference(key: SizePreferenceKey.self,
                             value: geometry.size)
    })
  }
}

extension View {
  func measureSize(perform action: @escaping (CGSize) -> Void) -> some View {
    self.modifier(MeasureSizeModifier())
      .onPreferenceChange(SizePreferenceKey.self, perform: action)
  }
}
