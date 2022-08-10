
//  Settings.swift

//  Created by Dominik Butz on 5/2/2021.
//

import Foundation
import SwiftUI


/// Grid chart settings (for line chart and bar chart)
public protocol DYGridChartSettings  {
    var chartViewBackgroundColor: Color {get set}
    var gradient: LinearGradient {get set}
    var lateralPadding: (leading: CGFloat, trailing: CGFloat) {get set}
    var labelViewDefaultOffset: CGSize {get set}
    var allowUserInteraction: Bool {get set}
    var yAxisSettings: YAxisSettings {get set }
    var xAxisSettings: XAxisSettings {get set}
 
}

/// Line Chart Settings
public struct  DYLineChartSettings:  DYGridChartSettings {
    
    /// chart  view background color
    public var chartViewBackgroundColor: Color
    /// gradient
    public var gradient: LinearGradient
    /// lateral padding, leading and trailing
    public var lateralPadding: (leading: CGFloat, trailing: CGFloat)
    
    /// in case a label view is returned in initialiser, this value determines the offset of the label view relative to the data point
    public var labelViewDefaultOffset: CGSize
    
    var lineColor: Color
    var lineStrokeStyle:  StrokeStyle
    var lineAnimationDuration: TimeInterval
    var showPointMarkers: Bool
    var showGradient: Bool

    var pointDiameter: CGFloat
    var pointStrokeStyle: StrokeStyle
    var pointColor: Color
    var pointBackgroundColor: Color
    
    var selectorLineWidth: CGFloat
    var selectorLinePointDiameter: CGFloat
    var selectorLinePointColor: Color
    var selectorLineColor: Color
    
    var interpolationType: InterpolationType
    
    public var allowUserInteraction: Bool
    /// yAxis settings
    public var yAxisSettings: YAxisSettings
    
    /// xAxis settings
    public var xAxisSettings: XAxisSettings

    /// DYLineChart settings
    /// - Parameters:
    ///   - chartViewBackgroundColor: background color of the chart view
    ///   - lineStrokeStyle: The stroke style of the line graph.
    ///   - lineColor: The color of the line graph.
    ///   - lineAnimationDuration: the duration in seconds during which the line is drawn when the view appears.
    ///   - showPointMarkers: This boolean determines whether or not to show the data points.
    ///   - showGradient: If set tot true, a gradient will be displayed underneath the line.
    ///   - gradient: Linear gradient underneath the line.
    ///   - lateralPadding: Set padding left to the first data point and to the right of the last data point. default 0,0.
    ///   - labelViewDefaultOffset: In case a label view is returned in the line chart labelView closure, this value determines the offset of the label view relative to the data point. Default is (0, -12)
    ///   - pointDiameter: Diameter of the data point markers..
    ///   - pointStrokeStyle: stroke style of the data point markers.
    ///   - pointColor: color of the data point markers.
    ///   - pointBackgroundColor: background color of the data point markers.
    ///   - selectorLineWidth: width of the selector line (appears when user drags on the grid).
    ///   - selectorLinePointDiameter: the diameter of the selector point.
    ///   - selectorLineColor: color of the selector line.
    ///   - selectorLinePointColor: color of the selector line point.
    ///   - interpolationType: Determines if the paths between the points are drawn by linear interpolation or by a quad-curve. Default value is quad-curve
    ///   - allowUserInteraction: Determines if swiping horizontally over the chart will make the selector move along the line from point to point. Default value is true.
    ///   - yAxisSettings: y-axis settings
    ///   - xAxisSettings: x-axis settings.
    public init(chartViewBackgroundColor: Color = Color(.systemBackground), lineStrokeStyle:StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: Color = Color.orange, lineAnimationDuration: TimeInterval = 1.4, showPointMarkers: Bool = true, showGradient: Bool = true, gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.orange, .white]), startPoint: .top, endPoint: .bottom), lateralPadding: (leading: CGFloat, trailing: CGFloat) = (0, 0), labelViewDefaultOffset: CGSize = CGSize(width: 0, height: -12), pointDiameter: CGFloat = 10, pointStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), pointColor: Color = Color.orange, pointBackgroundColor: Color = Color(.systemBackground), selectorLineWidth: CGFloat = 2, selectorLinePointDiameter: CGFloat = 12, selectorLineColor: Color = .orange, selectorLinePointColor: Color = .orange, interpolationType: InterpolationType = .quadCurve, allowUserInteraction: Bool = true,  yAxisSettings: YAxisSettings = YAxisSettings(), xAxisSettings: DYLineChartXAxisSettings = DYLineChartXAxisSettings()) {
        
        self.chartViewBackgroundColor = chartViewBackgroundColor
        self.lineColor = lineColor
        self.lineStrokeStyle = lineStrokeStyle
        self.lineAnimationDuration = lineAnimationDuration
        self.showPointMarkers = showPointMarkers
        self.showGradient = showGradient
        self.gradient = gradient
        self.lateralPadding = lateralPadding
        self.labelViewDefaultOffset = labelViewDefaultOffset
        self.pointDiameter = pointDiameter
        self.pointStrokeStyle = pointStrokeStyle
        self.pointColor = pointColor
        self.pointBackgroundColor = pointBackgroundColor
        self.selectorLineWidth = selectorLineWidth
        self.selectorLinePointDiameter = selectorLinePointDiameter
        self.selectorLineColor = selectorLineColor
        self.selectorLinePointColor = selectorLinePointColor
        self.interpolationType = interpolationType
        self.allowUserInteraction = allowUserInteraction
        self.yAxisSettings = yAxisSettings
        
        self.xAxisSettings = xAxisSettings
 
        
    }
    
}

public enum InterpolationType {
    case linear, quadCurve
}



/// Bar Chart settings. conforms to DYGridChartSettings protocol
public struct DYBarChartSettings: DYGridChartSettings {
    
    public var chartViewBackgroundColor: Color
    public var gradient: LinearGradient
    
    public var lateralPadding: (leading: CGFloat, trailing: CGFloat)
    /// in case a label view is returned in initialiser, this value determines the offset of the label view relative to the data point
    public var labelViewDefaultOffset: CGSize
    public var allowUserInteraction: Bool
    public var yAxisSettings: YAxisSettings
    public var xAxisSettings: XAxisSettings
    
    var showSelectionIndicator: Bool
    var selectionIndicatorColor: Color
    public var selectedBarGradient: LinearGradient?
    
    /// Initializer of DYBarChartSettings
    /// - Parameters:
    ///   - chartViewBackgroundColor: background color of the chart grid.
    ///   - gradient: Fill the bars with a linear gradient.
    ///   - lateralPadding: adds padding, leading and trailing, before the first and after the last bar.
    ///   - labelViewDefaultOffset: In case a label view is set in the initialiser, this value determines the offset of the label view relative the y-value of the bar (its height). Default is (0, -12)
    ///   - showSelectionIndicator: determines if the selection indicator should be shown at the top of the grid. selection changes on bar tap.
    ///   - selectionIndicatorColor: color of the selection indicator.
    ///   - selectedBarGradient: Linear gradient for the selected bar. Default is nil (no different gradient for the selected bar).
    ///   - allowUserInteraction: Set to false if the user should not be able to select a bar by tapping on it. Default value is true.
    ///   - yAxisSettings: y-axis settings
    ///   - xAxisSettings: x-axis settings
    public init(chartViewBackgroundColor: Color = Color(.systemBackground), gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]), startPoint: .top, endPoint: .bottom), lateralPadding: (leading: CGFloat, trailing: CGFloat) = (0, 0), labelViewDefaultOffset: CGSize = CGSize(width: 0, height: -12),  showSelectionIndicator: Bool = true, selectionIndicatorColor: Color = .orange, selectedBarGradient: LinearGradient? = nil, allowUserInteraction: Bool = true, yAxisSettings: YAxisSettings = YAxisSettings(), xAxisSettings: DYBarChartXAxisSettings = DYBarChartXAxisSettings()) {
        
        self.chartViewBackgroundColor = chartViewBackgroundColor
        self.gradient = gradient
        self.selectedBarGradient = selectedBarGradient
        self.lateralPadding = lateralPadding
        self.labelViewDefaultOffset = labelViewDefaultOffset
        self.showSelectionIndicator = showSelectionIndicator
        self.selectionIndicatorColor = selectionIndicatorColor
        self.allowUserInteraction = allowUserInteraction
        self.yAxisSettings = yAxisSettings
        self.xAxisSettings = xAxisSettings
  
    }
    
}






