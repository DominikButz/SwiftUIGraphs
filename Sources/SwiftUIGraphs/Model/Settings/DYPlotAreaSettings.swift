//
//  File.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import Foundation
import SwiftUI

public struct DYPlotAreaSettings {

    
    var plotAreaBackgroundGradient: LinearGradient
    var xAxisSettings: DYLineChartXAxisSettingsNew
    var yAxisSettings: YAxisSettingsNew
    var selectorLineWidth: CGFloat
    var selectorLineColor: Color
    var allowUserInteraction: Bool
    
    public init(plotAreaBackgroundGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemBackground)]), startPoint: .top, endPoint: .bottom), xAxisSettings: DYLineChartXAxisSettingsNew = DYLineChartXAxisSettingsNew(), yAxisSettings: YAxisSettingsNew = YAxisSettingsNew(), selectorLineWidth: CGFloat = 2, selectorLineColor: Color = .red, allowUserInteraction: Bool = true) {
        self.plotAreaBackgroundGradient = plotAreaBackgroundGradient
        self.xAxisSettings = xAxisSettings
        self.yAxisSettings = yAxisSettings
        self.selectorLineWidth = selectorLineWidth
        self.selectorLineColor = selectorLineColor
        self.allowUserInteraction = allowUserInteraction
        
    }
    
    
}


public struct DYLineChartXAxisSettingsNew {
    
    var showXAxis: Bool
    var showXAxisGridLines: Bool
    var xAxisLineStrokeStyle: StrokeStyle
    var xAxisInterval: Double
    var xAxisFontSize: CGFloat
    

    /// DYLineChartXAxisSettings initializer.
    /// - Parameters:
    ///   - showXAxis: determines if the x axis should be shown.
    ///   - showXAxisGridLines: determines if the x axis grid lines should be shown (vertical lines).
    ///   - xAxisGridLineStrokeStyle: stroke style of the vertical x axis grid lines.
    ///   - xAxisInterval: interval of the x-axis markers. It is recommended to override the default if required.
    ///   - xAxisFontSize: font size of the x axis marker labels.
    public init(showXAxis: Bool = true, showXAxisGridLines: Bool = true, xAxisGridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]),  xAxisInterval:Double = 100, xAxisFontSize: CGFloat = 8) {
        
        self.showXAxis = showXAxis
        self.showXAxisGridLines = showXAxisGridLines
        self.xAxisLineStrokeStyle = xAxisGridLineStrokeStyle
        self.xAxisInterval = xAxisInterval
        self.xAxisFontSize = xAxisFontSize
        
    }
}

public struct YAxisSettingsNew {
    
    var showYAxis: Bool
    var yAxisPosition: Edge.Set
    var yAxisViewWidth: CGFloat
    var showYAxisGridLines: Bool
    var yAxisGridLinesStrokeStyle: StrokeStyle

    var yAxisFontSize: CGFloat
    var yAxisMinMaxOverride: (min:Double?, max:Double?)?
    var yAxisIntervalOverride: Double?
    
    /// YAxisSettings
    /// - Parameters:
    ///   - showYAxis: determines if the y-axis should be shown.
    ///   - yAxisPosition: y-axis position. can be leading or trailing.
    ///   - yAxisViewWidth: width of the y-axis view. Adjust if the y-axis labels don't fit.
    ///   - showYAxisGridLines: determines if the (horizontal) y-axis grid lines should be shown.
    ///   - yAxisGridLineStrokeStyle: stroke style of the y-axis grid lines.
    ///  - yAxisFontSize: font size of the y-axis marker labels.
    ///  - yAxisMinMaxOverride: override the max and min values of the y-axis. if not set, the min and max value will be calculated automatically.
    ///  - yAxisIntervalOverride: override the interval of the y-axis values. If not set, the interval will be calculated automatically.
    public init(showYAxis: Bool = true, yAxisPosition: Edge.Set = .leading, yAxisViewWidth: CGFloat = 35, showYAxisGridLines: Bool = true, yAxisGridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]),  yAxisFontSize: CGFloat = 8, yAxisMinMaxOverride: (min:Double?, max:Double?)? = nil, yAxisIntervalOverride: Double? = nil) {
        
        self.showYAxis = showYAxis
        self.yAxisPosition = yAxisPosition
        self.yAxisViewWidth = yAxisViewWidth
        self.showYAxisGridLines = showYAxisGridLines
        self.yAxisGridLinesStrokeStyle = yAxisGridLineStrokeStyle
        self.yAxisFontSize = yAxisFontSize
        self.yAxisMinMaxOverride = yAxisMinMaxOverride
        self.yAxisIntervalOverride = yAxisIntervalOverride
        
    }
}
