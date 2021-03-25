
//  Settings.swift

//  Created by Dominik Butz on 5/2/2021.
//

import Foundation
import SwiftUI

public protocol DYGridChartSettings  {
    var chartViewBackgroundColor: Color {get set}
    var gradient: LinearGradient {get set}
    var lateralPadding: (leading: CGFloat, trailing: CGFloat) {get set}
    var yAxisSettings: YAxisSettings {get set }
    var xAxisSettings: XAxisSettings {get set}
}

public struct  DYLineChartSettings:  DYGridChartSettings {
    
    //chart
    public var chartViewBackgroundColor: Color
    public var gradient: LinearGradient
    public var lateralPadding: (leading: CGFloat, trailing: CGFloat)
    var lineColor: Color
    var lineStrokeStyle:  StrokeStyle
    var showPointMarkers: Bool
    var showGradient: Bool

    var pointDiameter: CGFloat
    var pointStrokeStyle: StrokeStyle
    var pointColor: Color
    var pointBackgroundColor: Color
    
    var markerLineWidth: CGFloat
    var markerLinePointDiameter: CGFloat
    var markerLineColor: Color
    var markerLinePointColor: Color
    // yAxis
    public var yAxisSettings: YAxisSettings
    
    //xAxis
    public var xAxisSettings: XAxisSettings

    public init(chartViewBackgroundColor: Color = Color(.systemBackground), lineStrokeStyle:StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: Color = Color.orange, showPointMarkers: Bool = true, showGradient: Bool = true, gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.orange, .white]), startPoint: .top, endPoint: .bottom), lateralPadding: (leading: CGFloat, trailing: CGFloat) = (0, 0), pointDiameter: CGFloat = 10, pointStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), pointColor: Color = Color.orange, pointBackgroundColor: Color = Color(.systemBackground), markerLineWidth: CGFloat = 2, markerLinePointDiameter: CGFloat = 12, markerLineColor: Color = .orange, markerLinePointColor: Color = .orange, yAxisSettings: YAxisSettings = YAxisSettings(), xAxisSettings: LineChartXAxisSettings = LineChartXAxisSettings()) {
        
        self.chartViewBackgroundColor = chartViewBackgroundColor
        self.lineColor = lineColor
        self.lineStrokeStyle = lineStrokeStyle
        self.showPointMarkers = showPointMarkers
        self.showGradient = showGradient
        self.gradient = gradient
        self.lateralPadding = lateralPadding
        self.pointDiameter = pointDiameter
        self.pointStrokeStyle = pointStrokeStyle
        self.pointColor = pointColor
        self.pointBackgroundColor = pointBackgroundColor
        self.markerLineWidth = markerLineWidth
        self.markerLinePointDiameter = markerLinePointDiameter
        self.markerLineColor = markerLineColor
        self.markerLinePointColor = markerLinePointColor
        
        self.yAxisSettings = yAxisSettings
        
        self.xAxisSettings = xAxisSettings
 
        
    }
    
}


public struct DYBarChartSettings: DYGridChartSettings {
    
    public var chartViewBackgroundColor: Color
    public var gradient: LinearGradient
    public var lateralPadding: (leading: CGFloat, trailing: CGFloat)
    public var yAxisSettings: YAxisSettings
    public var xAxisSettings: XAxisSettings
    
    var showSelectionIndicator: Bool
    var selectionIndicatorColor: Color
    
    public init(chartViewBackgroundColor: Color = Color(.systemBackground), gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]), startPoint: .top, endPoint: .bottom), lateralPadding: (leading: CGFloat, trailing: CGFloat) = (0, 0), showSelectionIndicator: Bool = true, selectionIndicatorColor: Color = .orange, yAxisSettings: YAxisSettings = YAxisSettings(), xAxisSettings: BarChartXAxisSettings = BarChartXAxisSettings()) {
        
        self.chartViewBackgroundColor = chartViewBackgroundColor
        self.gradient = gradient
        self.lateralPadding = lateralPadding
        self.showSelectionIndicator = showSelectionIndicator
        self.selectionIndicatorColor = selectionIndicatorColor
        self.yAxisSettings = yAxisSettings
        self.xAxisSettings = xAxisSettings
  
    }
    
}






