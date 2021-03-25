//
//  File.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

public struct LineChartXAxisSettings: XAxisSettings {
    
   public var showXAxis: Bool
   public var xAxisFontSize: CGFloat
    
    var showXAxisLines: Bool
    var xAxisLineStrokeStyle: StrokeStyle
    var xAxisInterval: Double
 
    
    public init(showXAxis: Bool = true, showXAxisLines: Bool = true, xAxisLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), xAxisInterval:Double = 100, xAxisFontSize: CGFloat = 8) {
        
        self.showXAxis = showXAxis
        self.showXAxisLines = showXAxisLines
        self.xAxisLineStrokeStyle = xAxisLineStrokeStyle
        self.xAxisInterval = xAxisInterval
        self.xAxisFontSize = xAxisFontSize
        
        
    }
}

public struct BarChartXAxisSettings: XAxisSettings {
    
   public var showXAxis: Bool
   public var xAxisFontSize: CGFloat
    
    public init(showXAxis: Bool = true, xAxisFontSize: CGFloat = 8) {
        
        self.showXAxis = showXAxis
        self.xAxisFontSize = xAxisFontSize
    }
}

public protocol XAxisSettings {
    var showXAxis: Bool {get set}
    var xAxisFontSize: CGFloat {get set}
    
}

public struct YAxisSettings {
    
    var showYAxis: Bool
    var yAxisPosition: Edge.Set
    var yAxisViewWidth: CGFloat
    var showYAxisLines: Bool
    var yAxisLineStrokeStyle: StrokeStyle
    var yAxisFontSize: CGFloat
    var yAxisMinMaxOverride: (min:Double?, max:Double?)?
    var yAxisIntervalOverride: Double?
    
    public init(showYAxis: Bool = true, yAxisPosition: Edge.Set = .leading, yAxisViewWidth: CGFloat = 35, showYAxisLines: Bool = true, yAxisLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), yAxisFontSize: CGFloat = 8, yAxisMinMaxOverride: (min:Double?, max:Double?)? = nil, yAxisIntervalOverride: Double? = nil) {
        
        self.showYAxis = showYAxis
        self.yAxisPosition = yAxisPosition
        self.yAxisViewWidth = yAxisViewWidth
        self.showYAxisLines = showYAxisLines
        self.yAxisLineStrokeStyle = yAxisLineStrokeStyle
        self.yAxisFontSize = yAxisFontSize
        self.yAxisMinMaxOverride = yAxisMinMaxOverride
        self.yAxisIntervalOverride = yAxisIntervalOverride
    }
}


