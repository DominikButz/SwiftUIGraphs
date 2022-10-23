//
//  File.swift
//  
//
//  Created by Dominik Butz on 1/9/2022.
//

import Foundation
import SwiftUI

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
