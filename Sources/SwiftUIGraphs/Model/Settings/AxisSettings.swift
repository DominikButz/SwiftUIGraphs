//
//  AxisSettings.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI




public struct YAxisSettingsNew {
    
    var showYAxis: Bool
    var yAxisPosition: Edge.Set
    var yAxisViewWidth: CGFloat
    var showYAxisGridLines: Bool
    var yAxisGridLinesStrokeStyle: StrokeStyle
    var yAxisGridLineColor: Color
    var yAxisZeroGridLineStrokeStyle: StrokeStyle?
    var yAxisZeroGridLineColor: Color?
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
    ///   - yAxisGridLineColor: color of the y-axis grid lines.
    ///   - yAxisZeroGridLineStrokeStyle: overrides the yAxisGridLineStrokeStyle only for the 0-line. Default is nil (no override).
    ///   - yAxisZeroGridLineColor: overrides the yAxisGridLineColor only for the 0-line. Default is nil (no override).
    ///  - yAxisFontSize: font size of the y-axis marker labels.
    ///  - yAxisMinMaxOverride: override the max and min values of the y-axis. if not set, the min and max value will be calculated automatically.
    ///  - yAxisIntervalOverride: override the interval of the y-axis values. If not set, the interval will be calculated automatically.
    public init(showYAxis: Bool = true, yAxisPosition: Edge.Set = .leading, yAxisViewWidth: CGFloat = 35, showYAxisGridLines: Bool = true, yAxisGridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), yAxisGridLineColor: Color = Color.secondary.opacity(0.5), yAxisZeroGridLineStrokeStyle: StrokeStyle? = nil, yAxisZeroGridLineColor: Color? = nil, yAxisFontSize: CGFloat = 8, yAxisMinMaxOverride: (min:Double?, max:Double?)? = nil, yAxisIntervalOverride: Double? = nil) {
        
        self.showYAxis = showYAxis
        self.yAxisPosition = yAxisPosition
        self.yAxisViewWidth = yAxisViewWidth
        self.showYAxisGridLines = showYAxisGridLines
        self.yAxisGridLinesStrokeStyle = yAxisGridLineStrokeStyle
        self.yAxisGridLineColor = yAxisGridLineColor
        self.yAxisZeroGridLineStrokeStyle = yAxisZeroGridLineStrokeStyle
        self.yAxisZeroGridLineColor = yAxisZeroGridLineColor
        self.yAxisFontSize = yAxisFontSize
        self.yAxisMinMaxOverride = yAxisMinMaxOverride
        self.yAxisIntervalOverride = yAxisIntervalOverride
        
    }
}

public protocol XAxisSettings {
    var showXAxis: Bool {get set}
    var labelFontSize: CGFloat {get set}
    var xAxisViewHeight: CGFloat {get set}
}
 
public struct DYLineChartXAxisSettingsNew: XAxisSettings {

    public var showXAxis: Bool
    public var xAxisViewHeight: CGFloat
    var showXAxisGridLines: Bool
    var xAxisGridLineStrokeStyle: StrokeStyle
    var xAxisGridLineColor: Color
    public var labelFontSize: CGFloat
    //var xAxisInterval: Double
    var minMaxOverride: (min:Double?, max:Double?)?
    var intervalOverride: Double?

    /// DYLineChartXAxisSettings initializer.
    /// - Parameters:
    ///   - showXAxis: determines if the x axis should be shown.
    ///   - xAxisViewHeight: height of the xAxis view.
    ///   - showXAxisGridLines: determines if the x axis grid lines should be shown (vertical lines).
    ///   - xAxisGridLineStrokeStyle: stroke style of the vertical x axis grid lines.
    ///   - xAxisGridLineColor: color of the xAxis grid lines.
    ///   - xAxisFontSize: font size of the x axis marker labels.
    ///   - minMaxOverride: override the max and min values of the x-axis. if not set, the min and max value will be calculated automatically.
    ///   - intervalOverride: override the interval of the x-axis values. If not set, the interval will be calculated automatically.
    public init(showXAxis: Bool = true, xAxisViewHeight: CGFloat = 20, showXAxisGridLines: Bool = true, xAxisGridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), xAxisGridLineColor: Color = Color.secondary.opacity(0.5), xAxisFontSize: CGFloat = 8, minMaxOverride: (min:Double?, max:Double?)? = nil, intervalOverride: Double? = nil ) {
        
        self.showXAxis = showXAxis
        self.xAxisViewHeight = xAxisViewHeight
        self.showXAxisGridLines = showXAxisGridLines
        self.xAxisGridLineStrokeStyle = xAxisGridLineStrokeStyle
        self.xAxisGridLineColor = xAxisGridLineColor
        self.labelFontSize = xAxisFontSize
        self.minMaxOverride = minMaxOverride
        self.intervalOverride = intervalOverride
    }
}




/// Bar chart x-axis settings
public struct DYBarChartXAxisSettings: XAxisSettings {
    
   public var showXAxis: Bool
   public var xAxisViewHeight: CGFloat
   public var labelFontSize: CGFloat
    
    /// DYBarChartXAxisSettings
    /// - Parameters:
    ///   - showXAxis: determines if the x-axis should be shown.
    ///   - xAxisViewHeight: height of the xAxis view.
    ///   - xAxisFontSize: font size of the x-axis marker labels.
    public init(showXAxis: Bool = true, xAxisViewHeight:CGFloat = 20,  xAxisFontSize: CGFloat = 8) {
        
        self.showXAxis = showXAxis
        self.xAxisViewHeight = xAxisViewHeight
        self.labelFontSize = xAxisFontSize
    }
}





