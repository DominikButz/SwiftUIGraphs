//
//  Line.swift
//  
//
//  Created by Dominik Butz on 29/3/2021.
//

import Foundation
import SwiftUI
// implemented for placeholder grid.
internal struct Line: Shape {
    var horizontal: Bool = true
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: horizontal ? rect.width : 0, y: horizontal ? 0 : rect.height))
        return path
    }
}
