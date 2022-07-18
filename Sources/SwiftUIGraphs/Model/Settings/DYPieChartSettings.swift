//
//  DYPieChartSettings.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

/// Settings for DYPieChart
public struct DYPieChartSettings {
    
    var innerCircleRadiusFraction: CGFloat
    var minimumFractionForSliceLabelOffset: Double
    var selectedSliceScaleEffect: CGFloat
    var sliceOutlineWidth: CGFloat
    var sliceOutlineColor: Color
    
    /// Initializer of DYPieChartSettings
    /// - Parameters:
    ///   - innerCircleRadiusFraction: Value must be between 0 and 1. By settings this value > 0, you can create a doughnut chart instead of a pie chart. Default is 0 which means that by default is a pie chart will be shown.
    ///   - minimumFractionForSliceLabelOffset: Value must be between 0 and 1. Determines the position of the chart slice label view. if the fraction is at least this value, the label will be displayed roughly in the center of the slice, otherwise it will be displayed outside of the slice.
    ///   - selectedSliceScaleEffect: When a user taps a slice, the slice (and its label if any) will be enlarged to this factor. Default is 1.05 (+5%).
    ///   - sliceOutlineWidth: The width of the edge line of each pie chart slice. Default is 1. Set to 0 if there should be no outline
    ///   - sliceOutlineColor: The color of the edge line of each pie chart slice. Default is primary. 
    public init(innerCircleRadiusFraction: CGFloat = 0, minimumFractionForSliceLabelOffset: Double = 0.10, selectedSliceScaleEffect: CGFloat = 1.05, sliceOutlineWidth: CGFloat = 1, sliceOutlineColor: Color = Color.primary) {
        self.innerCircleRadiusFraction = innerCircleRadiusFraction
        self.minimumFractionForSliceLabelOffset = minimumFractionForSliceLabelOffset
        self.selectedSliceScaleEffect = selectedSliceScaleEffect
        self.sliceOutlineWidth = sliceOutlineWidth
        self.sliceOutlineColor = sliceOutlineColor
    }

}
