//
//  File.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

public extension Color {
    
    static func random()->Color {
        let red = drand48()
        let green = drand48()
        let blue = drand48()
        return Color(.displayP3, red: red, green: green, blue: blue, opacity: 1)
    }
}
