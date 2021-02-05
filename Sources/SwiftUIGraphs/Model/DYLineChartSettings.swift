//
//  File.swift
//  
//
//  Created by Dominik Butz on 5/2/2021.
//

import Foundation
import SwiftUI

public struct  DYLineChartSettings {
    
    //chart
    var lineColor: Color
    var lineStrokeStyle:  StrokeStyle
    var showPointMarkers: Bool
    var showGradient: Bool
    var gradient: LinearGradient
    var leadingPadding: CGFloat
    var trailingPadding: CGFloat
    
    var pointDiameter: CGFloat
    var pointStrokeStyle: StrokeStyle
    var pointColor: Color
    var pointBackgroundColor: Color
    
    var lineMarkerColor: Color
    
    // yAxis
    var showYAxis: Bool
    var showYAxisLines: Bool
    var yAxisLineStrokeStyle: StrokeStyle
    var overrideYAxisMinMax: (min:Double?, max:Double?)?
    var yAxisValueInterval: Int
    
    
    public init(lineStrokeStyle:StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: Color = Color.orange, showPointMarkers: Bool = true, showGradient: Bool = true, gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color.orange, .white]), startPoint: .top, endPoint: .bottom), leadingPadding: CGFloat = 5, trailingPadding: CGFloat = 5, pointDiameter: CGFloat = 10, pointStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), pointColor: Color = Color.orange, pointBackgroundColor: Color = Color(.systemBackground), lineMarkerColor: Color = .orange, showYAxis: Bool = true , showYAxisLines: Bool = true, yAxisLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), overrideYAxisMinMax: (min:Double?, max:Double?)? = nil, yAxisValueInterval: Int = 1) {
        
        self.lineColor = lineColor
        self.lineStrokeStyle = lineStrokeStyle
        self.showPointMarkers = showPointMarkers
        self.showGradient = showGradient
        self.gradient = gradient
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
        self.pointDiameter = pointDiameter
        self.pointStrokeStyle = pointStrokeStyle
        self.pointColor = pointColor
        self.pointBackgroundColor = pointBackgroundColor
        self.lineMarkerColor = lineMarkerColor
        self.showYAxis = showYAxis
        self.showYAxisLines = showYAxisLines
        self.yAxisLineStrokeStyle = yAxisLineStrokeStyle
        self.overrideYAxisMinMax = overrideYAxisMinMax
        self.yAxisValueInterval = yAxisValueInterval

        
    }
    
}
