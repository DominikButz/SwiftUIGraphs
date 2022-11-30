//
//  File.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import Foundation
import SwiftUI


struct DYLineChartSettings {

    public var plotAreaBackgroundGradient: LinearGradient = LinearGradient(colors: [Color.defaultPlotAreaBackgroundColor, Color.defaultPlotAreaBackgroundColor], startPoint: .top, endPoint: .bottom)
    public var allowUserInteraction: Bool = true
    var selectorLineWidth: CGFloat = 2
    var selectorLineColor: Color = .red
  

}

struct DYBarChartSettings {

    var plotAreaBackgroundGradient: LinearGradient = LinearGradient(colors: [Color.defaultPlotAreaBackgroundColor, Color.defaultPlotAreaBackgroundColor], startPoint: .top, endPoint: .bottom)
    var allowUserInteraction: Bool = true
    var selectedBarBorderColor: Color = Color.yellow
    var barDropShadow: Shadow? = nil
    var selectedBarDropShadow: Shadow? = nil
    var labelViewOffset: CGSize = CGSize(width: 0, height: -10)
    var minimumTopEdgeBarLabelMargin: CGFloat = 0
    var minimumBottomEdgeBarLabelMargin: CGFloat = 10

}

