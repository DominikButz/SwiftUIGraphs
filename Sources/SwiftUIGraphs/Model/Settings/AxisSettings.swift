//
//  AxisSettings.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

public struct YAxisSettings {
    
    var showYAxis: Bool = true
    var yAxisPosition: Edge.Set = .leading
    var yAxisViewWidth: CGFloat = 35
    var showYAxisGridLines: Bool = true
    var yAxisGridLinesStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3])
    var yAxisGridLineColor: Color = Color.secondary.opacity(0.5)
    #if os(macOS)
    var labelFont: NSFont = .systemFont(ofSize: 10)
    #else
    var labelFont: UIFont = .systemFont(ofSize: 8)
    #endif
    var yAxisMinMaxOverride: (min:Double?, max:Double?)? = nil
    var yAxisIntervalOverride: Double? = nil
    
}

protocol XAxisSettings {
    var showXAxis: Bool {get set}
    #if os(macOS)
    var labelFont: NSFont {get set}
    #else
    var labelFont: UIFont {get set}
    #endif
    var xAxisViewHeight: CGFloat {get set}
}
 
struct DYLineChartXAxisSettings: XAxisSettings {

    var showXAxis: Bool = true
    var xAxisViewHeight: CGFloat = 20
    var showXAxisGridLines: Bool = true
    var xAxisGridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3])
    var xAxisGridLineColor: Color = Color.secondary.opacity(0.5)
    #if os(macOS)
    var labelFont: NSFont = .systemFont(ofSize: 10)
    #else
    var labelFont: UIFont = .systemFont(ofSize: 8)
    #endif
    var minMaxOverride: (min:Double?, max:Double?)? = nil
    var intervalOverride: Double? = nil


}




/// Bar chart x-axis settings
struct DYBarChartXAxisSettings: XAxisSettings {
    
    var showXAxis: Bool = true
    var xAxisViewHeight: CGFloat = 20
    #if os(macOS)
    var labelFont: NSFont = .systemFont(ofSize: 10)
    #else
    var labelFont: UIFont = .systemFont(ofSize: 8)
    #endif

}





