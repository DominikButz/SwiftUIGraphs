//
//  File.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

/// Line chart x-axis settings.
public struct DYLineChartXAxisSettings: XAxisSettings {
    
   public var showXAxis: Bool
   public var xAxisFontSize: CGFloat
    
    var showXAxisLines: Bool
    var xAxisLineStrokeStyle: StrokeStyle
    var xAxisInterval: Double
 
    
    /// DYLineChartXAxisSettings initializer.
    /// - Parameters:
    ///   - showXAxis: determines if the x axis should be shown.
    ///   - showXAxisLines: determines if the x axis grid lines should be shown (vertical lines).
    ///   - xAxisLineStrokeStyle: stroke style of the vertical x axis grid lines.
    ///   - xAxisInterval: interval of the x-axis markers. It is recommended to override the default if required.
    ///   - xAxisFontSize: font size of the x axis marker labels.
    public init(showXAxis: Bool = true, showXAxisLines: Bool = true, xAxisLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), xAxisInterval:Double = 100, xAxisFontSize: CGFloat = 8) {
        
        self.showXAxis = showXAxis
        self.showXAxisLines = showXAxisLines
        self.xAxisLineStrokeStyle = xAxisLineStrokeStyle
        self.xAxisInterval = xAxisInterval
        self.xAxisFontSize = xAxisFontSize
        
        
    }
}

/// Bar chart x-axis settings
public struct DYBarChartXAxisSettings: XAxisSettings {
    
   public var showXAxis: Bool
   public var xAxisFontSize: CGFloat
    
    /// DYBarChartXAxisSettings
    /// - Parameters:
    ///   - showXAxis: determines if the x-axis should be shown.
    ///   - xAxisFontSize: font size of the x-axis marker labels.
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
    
    /// YAxisSettings
    /// - Parameters:
    ///   - showYAxis: determines if the y-axis should be shown.
    ///   - yAxisPosition: y-axis position. can be leading or trailing.
    ///   - yAxisViewWidth: width of the y-axis view. Adjust if the y-axis labels don't fit.
    ///   - showYAxisLines: determines if the (horizontal) y-axis grid lines should be shown.
    ///   - yAxisLineStrokeStyle: stroke style of the y-axis grid lines.
    ///   - yAxisFontSize: font size of the y-axis marker labels.
    ///   - yAxisMinMaxOverride: override the max and min values of the y-axis. if not set, the min and max value will be calculated automatically.
    ///   - yAxisIntervalOverride: override the interval of the y-axis values. If not set, the interval will be calculated automatically.
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


