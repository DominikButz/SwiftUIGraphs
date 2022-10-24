//
//  File.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import Foundation
import SwiftUI

//public protocol DYPlotAreaSettings {
//
//    var plotAreaBackgroundGradient: LinearGradient {get set}
//    var xAxisSettings: XAxisSettings {get set}
//    var yAxisSettings: YAxisSettingsNew {get set}
//    var allowUserInteraction: Bool {get set }
//}

public struct DYLineChartSettingsNew {

    public var plotAreaBackgroundGradient: LinearGradient
//    public var xAxisSettings: XAxisSettings
//    public var yAxisSettings: YAxisSettingsNew
    public var allowUserInteraction: Bool
    var selectorLineWidth: CGFloat
    var selectorLineColor: Color
    
    
    public init(plotAreaBackgroundGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemBackground)]), startPoint: .top, endPoint: .bottom), selectorLineWidth: CGFloat = 2, selectorLineColor: Color = .red, allowUserInteraction: Bool = true) {
        self.plotAreaBackgroundGradient = plotAreaBackgroundGradient
        self.selectorLineWidth = selectorLineWidth
        self.selectorLineColor = selectorLineColor
        self.allowUserInteraction = allowUserInteraction
        
    }
    
    
}

public struct DYStackedBarChartSettings {

    public var plotAreaBackgroundGradient: LinearGradient
    public var allowUserInteraction: Bool
    var selectedBarBorderColor: Color
    var barDropShadow: Shadow?
    var selectedBarDropShadow: Shadow?
    var labelViewOffset: CGSize
    var minimumTopEdgeBarLabelMargin: CGFloat
    var minimumBottomEdgeBarLabelMargin: CGFloat
    
    
    public init(plotAreaBackgroundGradient: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemBackground)]), startPoint: .top, endPoint: .bottom), allowUserInteraction: Bool = true, selectedBarBorderColor: Color = .yellow,  barDropShadow: Shadow? = nil, selectedBarDropShadow: Shadow? = nil, labelViewOffset: CGSize = CGSize(width: 0, height: -10), minimumTopEdgeBarLabelMargin: CGFloat = 0, minimumBottomEdgeBarLabelMargin: CGFloat = 10) {
       self.plotAreaBackgroundGradient = plotAreaBackgroundGradient
       self.allowUserInteraction = allowUserInteraction
       self.selectedBarBorderColor = selectedBarBorderColor
       self.barDropShadow = barDropShadow
       self.selectedBarDropShadow = selectedBarDropShadow
       self.labelViewOffset = labelViewOffset
       self.minimumTopEdgeBarLabelMargin = minimumTopEdgeBarLabelMargin
       self.minimumBottomEdgeBarLabelMargin = minimumBottomEdgeBarLabelMargin
   }
  
}

