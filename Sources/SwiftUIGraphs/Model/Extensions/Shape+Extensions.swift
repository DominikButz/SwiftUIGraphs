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
            self      //, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0
            .stroke(style: StrokeStyle(lineWidth: 2))
            .foregroundColor(color)
            .frame(width: edgeLength, height: edgeLength, alignment: .center)
        
          
    }
}
