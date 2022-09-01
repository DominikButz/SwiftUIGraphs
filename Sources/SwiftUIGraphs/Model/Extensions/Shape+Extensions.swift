//
//  File.swift
//  
//
//  Created by Dominik Butz on 1/9/2022.
//

import Foundation
import SwiftUI

public extension Shape {
    func pointStyle(color: Color, edgeLength: CGFloat)-> some View {
            self
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
            .foregroundColor(color)
            .frame(width: edgeLength, height: edgeLength, alignment: .center)
            .background(Color(.systemBackground))
          
    }
}
