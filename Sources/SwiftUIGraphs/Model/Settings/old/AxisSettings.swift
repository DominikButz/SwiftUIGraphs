//
//  AxisSettings.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

/// Line chart x-axis settings.
//public struct DYLineChartXAxisSettings: XAxisSettings {
//
//   public var showXAxis: Bool
//   public var labelFontSize: CGFloat
//   public var xAxisViewHeight: CGFloat
//    var showXAxisGridLines: Bool
//    var xAxisLineStrokeStyle: StrokeStyle
//    var xAxisInterval: Double
//
//    var showXAxisDataPointLines: Bool
//    var xAxisDataPointLinesStrokeStyle: StrokeStyle
//    var xAxisDataPointLinesColor: Color
//
//    var showXAxisSelectedDataPointLine: Bool
//    var xAxisSelectedDataPointLineStrokeStyle: StrokeStyle
//    var xAxisSelectedDataPointLineColor: Color
//
//
//    /// DYLineChartXAxisSettings initializer.
//    /// - Parameters:
//    ///   - showXAxis: determines if the x axis should be shown.
//    ///   - showXAxisGridLines: determines if the x axis grid lines should be shown (vertical lines).
//    ///   - xAxisGridLineStrokeStyle: stroke style of the vertical x axis grid lines.
//    ///   - showXAxisDataPointLines: determines if the there should be vertical marker lines from each data point down to the x-axis. Default: false.
//    ///   - xAxisDataPointLinesStrokeStyle: if showXAxisDataPointLines is set to true, set the lines stroke style here.
//    ///   - xAxisDataPointLinesColor. if showXAxisDataPointLines is set to true, this value sets the data points lines' color.
//    ///   - showXAxisSelectedDataPointLine: if set to true, there will be a line drawn from the selected point vertically to the x-axis. Default is false.
//    ///   - xAxisSelectedDataPointLineStrokeStyle: if showXAxisSelectedDataPointLine set to true, this value sets the line stroke style.
//    ///  - xAxisSelectedDataPointLineColor: if showXAxisSelectedDataPointLine set to true, this value sets the line color.
//    ///   - xAxisInterval: interval of the x-axis markers. It is recommended to override the default if required.
//    ///   - xAxisFontSize: font size of the x axis marker labels.
//    public init(showXAxis: Bool = true, xAxisViewHeight: CGFloat = 20, showXAxisGridLines: Bool = true, xAxisGridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), showXAxisDataPointLines: Bool = false, xAxisDataPointLinesStrokeStyle: StrokeStyle =  StrokeStyle(lineWidth: 1, dash: [3]),  xAxisDataPointLinesColor: Color = .green, showXAxisSelectedDataPointLine: Bool = false, xAxisSelectedDataPointLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, dash: [3]),  xAxisSelectedDataPointLineColor: Color = Color.orange,  xAxisInterval:Double = 100, xAxisFontSize: CGFloat = 8) {
//
//        self.showXAxis = showXAxis
//        self.xAxisViewHeight = xAxisViewHeight
//        self.showXAxisGridLines = showXAxisGridLines
//        self.xAxisLineStrokeStyle = xAxisGridLineStrokeStyle
//        self.showXAxisDataPointLines = showXAxisDataPointLines
//        self.xAxisDataPointLinesStrokeStyle = xAxisDataPointLinesStrokeStyle
//        self.xAxisDataPointLinesColor = xAxisDataPointLinesColor
//
//        self.showXAxisSelectedDataPointLine = showXAxisSelectedDataPointLine
//        self.xAxisSelectedDataPointLineStrokeStyle = xAxisSelectedDataPointLineStrokeStyle
//        self.xAxisSelectedDataPointLineColor = xAxisSelectedDataPointLineColor
//
//        self.xAxisInterval = xAxisInterval
//        self.labelFontSize = xAxisFontSize
//
//    }
//}

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

public protocol XAxisSettings {
    var showXAxis: Bool {get set}
    var labelFontSize: CGFloat {get set}
    var xAxisViewHeight: CGFloat {get set}
}



public struct YAxisSettings {
    
    var showYAxis: Bool
    var yAxisPosition: Edge.Set
    var yAxisViewWidth: CGFloat
    var showYAxisGridLines: Bool
    var yAxisGridLinesStrokeStyle: StrokeStyle
    
    var showYAxisDataPointLines: Bool
    var yAxisDataPointLinesStrokeStyle: StrokeStyle
    var yAxisDataPointLinesColor: Color
    
    var showYAxisSelectedDataPointLine: Bool
    var yAxisSelectedDataPointLineStrokeStyle: StrokeStyle
    var yAxisSelectedDataPointLineColor: Color

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
    ///   - showYAxisDataPointLines: determines if the there should be horizontal marker lines from each data point to the yAxis. Default: false.
    ///   - yAxisDataPointLinesStrokeStyle: if showYAxisDataPointLines is set to true, set the lines stroke style here.
    ///   - yAxisDataPointLinesColor. if showYAxisDataPointLines is set to true, this value sets the data points lines' color.
    ///   - showYAxisSelectedDataPointLine: if set to true, there will be a line drawn from the selected point horizontally to the y-axis. Default is false.
    ///   - yAxisSelectedDataPointLineStrokeStyle: if showYAxisSelectedDataPointLine set to true, this value sets the line stroke style.
    ///  - yAxisSelectedDataPointLineColor: if showYAxisSelectedDataPointLine set to true, this value sets the line color.
    ///  - yAxisFontSize: font size of the y-axis marker labels.
    ///  - yAxisMinMaxOverride: override the max and min values of the y-axis. if not set, the min and max value will be calculated automatically.
    ///   - yAxisIntervalOverride: override the interval of the y-axis values. If not set, the interval will be calculated automatically.
    public init(showYAxis: Bool = true, yAxisPosition: Edge.Set = .leading, yAxisViewWidth: CGFloat = 35, showYAxisGridLines: Bool = true, yAxisGridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), showYAxisDataPointLines: Bool = false, yAxisDataPointLinesStrokeStyle: StrokeStyle  = StrokeStyle(lineWidth: 1, dash: [3]), yAxisDataPointLinesColor: Color = .green, showYAxisSelectedDataPointLine: Bool = false, yAxisSelectedDataPointLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, dash: [3]),  yAxisSelectedDataPointLineColor: Color = .orange,  yAxisFontSize: CGFloat = 8, yAxisMinMaxOverride: (min:Double?, max:Double?)? = nil, yAxisIntervalOverride: Double? = nil) {
        
        self.showYAxis = showYAxis
        self.yAxisPosition = yAxisPosition
        self.yAxisViewWidth = yAxisViewWidth
        self.showYAxisGridLines = showYAxisGridLines
        self.yAxisGridLinesStrokeStyle = yAxisGridLineStrokeStyle
        self.showYAxisDataPointLines = showYAxisDataPointLines
        self.yAxisDataPointLinesStrokeStyle = yAxisDataPointLinesStrokeStyle
        self.yAxisDataPointLinesColor = yAxisDataPointLinesColor
        self.showYAxisSelectedDataPointLine = showYAxisSelectedDataPointLine
        self.yAxisSelectedDataPointLineStrokeStyle = yAxisSelectedDataPointLineStrokeStyle
        self.yAxisSelectedDataPointLineColor = yAxisSelectedDataPointLineColor
        self.yAxisFontSize = yAxisFontSize
        self.yAxisMinMaxOverride = yAxisMinMaxOverride
        self.yAxisIntervalOverride = yAxisIntervalOverride
        
    }
}


