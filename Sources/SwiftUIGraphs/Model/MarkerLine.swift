//
//  File.swift
//  
//
//  Created by Dominik Butz on 26/10/2022.
//

import Foundation
import SwiftUI

/// A struct representing a marker or target line in a coordinate system with either vertical or horizonatal orientation
internal struct MarkerLine: Identifiable {

    let id: UUID
    let color: Color
    let strokeStyle: StrokeStyle
    let orientation: Orientation
    let coordinate: Double
    
    /// MarkerLine initialiser
    /// - Parameters:
    ///   - id: a UUID
    ///   - color: color of the line view
    ///   - strokeStyle: stroke style of the line view
    ///   - orientation: orientation of thel line view
    ///   - coordinate: coordinate of the line view (horizontal or vertical). If the orientation is horizontal, the coordinate represents the the y-coordinate, otherwise, it represents the x-coordinate.
    init(id: UUID = UUID(), coordinate: Double, color: Color, strokeStyle: StrokeStyle, orientation: Orientation) {
        self.id = id
        self.color = color
        self.strokeStyle = strokeStyle
        self.orientation = orientation
        self.coordinate = coordinate
    }
    
    
}

public enum Orientation {
    case horizontal, vertical
}



