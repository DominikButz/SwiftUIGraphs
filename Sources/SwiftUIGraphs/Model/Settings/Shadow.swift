//
//  File.swift
//  
//
//  Created by Dominik Butz on 24/10/2022.
//

import Foundation
import SwiftUI

public struct Shadow {
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
    
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}
