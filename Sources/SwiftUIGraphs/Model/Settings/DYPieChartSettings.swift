//
//  File.swift
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
    
    /// Initializer of DYPieChartSettings
    /// - Parameters:
    ///   - innerCircleRadiusFraction: Value must be between 0 and 1. By settings this value > 0, you can create a doughnut chart instead of a pie chart. Default is 0 which means that by default is a pie chart will be shown.
    ///   - minimumFractionForSliceLabelOffset: Value must be between 0 and 1. Determines the position of the chart slice label view. if the fraction is at least this value, the label will be displayed roughly in the center of the slice, otherwise it will be displayed outside of the slice.
    ///   - selectedSliceScaleEffect: When a user taps a slice, the slice (and its label if any) will be enlarged to this factor. Default is 1.05 (+5%).
    public init(innerCircleRadiusFraction: CGFloat = 0, minimumFractionForSliceLabelOffset: Double = 0.10, selectedSliceScaleEffect: CGFloat = 1.05){
        self.innerCircleRadiusFraction = innerCircleRadiusFraction
        self.minimumFractionForSliceLabelOffset = minimumFractionForSliceLabelOffset
        self.selectedSliceScaleEffect = selectedSliceScaleEffect
    }

}
