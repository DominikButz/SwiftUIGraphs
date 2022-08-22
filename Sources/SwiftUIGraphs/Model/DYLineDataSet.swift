//
//  File.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import Foundation
import SwiftUI

public struct DYLineDataSet: Identifiable {
    
    public var id: UUID
    var dataPoints: [DYDataPoint]
    @Binding var selectedIndex: Int
    var labelView: ((DYDataPoint)->AnyView?)?
    var pointView: ((DYDataPoint)-> AnyView)?
    var colorPerLineSegment: ((DYDataPoint)->Color)?
    var settings: DYLineSettings
    
    public init(id: UUID = UUID(), dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, labelView: ((DYDataPoint)->AnyView?)? = nil, pointView: ((DYDataPoint)-> AnyView)? = nil, colorPerLineSegment: ((DYDataPoint)->Color)? = nil, settings: DYLineSettings = DYLineSettings()) {
        self.id = id
        self.dataPoints = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self._selectedIndex = selectedIndex
        self.labelView = labelView
        self.pointView = pointView
        self.colorPerLineSegment = colorPerLineSegment
        self.settings = settings
        
    }
    

    
    
    
}
