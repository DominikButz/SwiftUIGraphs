//
//  File.swift
//  
//
//  Created by Dominik Butz on 1/9/2022.
//

import Foundation
import SwiftUI


extension Shape {
    func fill<S:ShapeStyle>(_ fillContent: S, opacity: Double, strokeWidth: CGFloat, strokeColor: S) -> some View {
            ZStack {
                self.fill(fillContent).opacity(opacity)
                self.stroke(strokeColor, lineWidth: strokeWidth)
            }
    }
}

internal struct PieChartSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
   func path(in rect: CGRect) -> Path {
        let center = CGPoint.init(x: (rect.origin.x + rect.width)/2, y: (rect.origin.y + rect.height)/2)
        let radius = min(center.x, center.y)
            let path = Path { p in
                p.addArc(center: center,
                         radius: radius,
                         startAngle: startAngle,
                         endAngle: endAngle,
                         clockwise: true)
                p.addLine(to: center)
            
            }
            return path
   }
}

public struct Triangle: Shape {
    
    public init() {
        
    }
    
   public func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.width / 2, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
            
        }
    }
    
    
    
}
