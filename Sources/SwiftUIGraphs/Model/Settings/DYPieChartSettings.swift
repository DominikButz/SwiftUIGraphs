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
    var sliceLabelVisibilityThreshold: Double
    var selectedSliceScaleEffect: CGFloat
    
    /// Initializer of DYPieChartSettings
    /// - Parameters:
    ///   - innerCircleRadiusFraction: Value must be between 0 and 1. By settings this value > 0, you can create a doughnut chart instead of a pie chart. Default is 0 which means that by default is a pie chart will be shown.
    ///   - sliceLabelVisibilityThreshold: Value must be between 0 and 1. If your pie chart has label views, each view will only be shown if its share of the total value is at least this fraction. Default is 0.1.
    ///   - selectedSliceScaleEffect: When a user taps a slice, the slice (and its label if any) will be enlarged to this factor. Default is 1.05 (+5%).
    public init(innerCircleRadiusFraction: CGFloat = 0, sliceLabelVisibilityThreshold: Double = 0.10,  selectedSliceScaleEffect: CGFloat = 1.05){
        self.innerCircleRadiusFraction = innerCircleRadiusFraction
        self.sliceLabelVisibilityThreshold = sliceLabelVisibilityThreshold
        self.selectedSliceScaleEffect = selectedSliceScaleEffect
    }

}
