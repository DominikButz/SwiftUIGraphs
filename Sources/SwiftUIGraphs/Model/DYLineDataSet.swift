//
//  File.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import Foundation
import SwiftUI

public struct DYLineDataSet: Identifiable, Equatable {
    public static func == (lhs: DYLineDataSet, rhs: DYLineDataSet) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id: UUID
    public var dataPoints: [DYDataPoint]
//    @Binding var selectedIndex: Int
    var pointView: ((DYDataPoint)-> AnyView)?
    var labelView: ((DYDataPoint)->AnyView?)?
    var colorPerLineSegment: ((DYDataPoint)->Color)?
    var selectorView: AnyView?
    var settings: DYLineSettings
    
    public init(id: UUID = UUID(), dataPoints: [DYDataPoint], pointView: ((DYDataPoint)-> AnyView)? = nil, labelView: ((DYDataPoint)->AnyView?)? = nil, colorPerLineSegment: ((DYDataPoint)->Color)? = nil, selectorView: AnyView? = nil, settings: DYLineSettings = DYLineSettings()) {
        self.id = id
        self.dataPoints = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        //self._selectedIndex = selectedIndex
        self.labelView = labelView
        self.pointView = pointView
        self.colorPerLineSegment = colorPerLineSegment
        self.selectorView = selectorView
        self.settings = settings
        
    }
    
    var xValuesMinMax: (min: Double, max: Double) {
        let xValues = dataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        return (minX, maxX)
    }
    
    
    
}
