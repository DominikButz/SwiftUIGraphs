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
    var allowUserInteraction: Bool
    var shouldHideMultiFractionSliceOnSelection: Bool
    var selectedSliceScaleEffect: CGFloat
    var selectedSliceDropShadow: Shadow
    var sliceOutlineWidth: CGFloat
    var sliceOutlineColor: Color
    
    /// Initializer of DYPieChartSettings
    /// - Parameters:
    ///   - innerCircleRadiusFraction: Value must be between 0 and 1. By settings this value > 0, you can create a doughnut chart instead of a pie chart. Default is 0 which means that by default is a pie chart will be shown.
    ///   - minimumFractionForSliceLabelOffset: Value must be between 0 and 1. Determines the position of the chart slice label view. if the fraction is at least this value, the label will be displayed roughly in the center of the slice, otherwise it will be displayed outside of the slice.
    ///   - allowUserInteraction: Set to false if the tapping a pie chart slice should not change the selected slice ID. Default is true.
    ///  - shouldHideMultiFractionSliceOnSelection: if set to true, the selected slice will be hidden. This only makes sense in conjuction with a second pie chart that shows the detail slices of the hidden slice in the first pie chart. Default is false. 
    ///   - selectedSliceScaleEffect: When a user taps a slice, the slice (and its label if any) will be enlarged to this factor. Default is 1.05 (+5%).
    ///   - selectedSliceDropShadow: A shadow to appear underneath the selected slice.
    ///   - sliceOutlineWidth: The width of the edge line of each pie chart slice. Default is 1. Set to 0 if there should be no outline
    ///   - sliceOutlineColor: The color of the edge line of each pie chart slice. Default is primary.
    public init(innerCircleRadiusFraction: CGFloat = 0, minimumFractionForSliceLabelOffset: Double = 0.10, allowUserInteraction: Bool = true, shouldHideMultiFractionSliceOnSelection: Bool = false, selectedSliceScaleEffect: CGFloat = 1.05, selectedSliceDropShadow: Shadow = Shadow(color: .gray.opacity(0.7), radius: 10, x: 0, y: 0), sliceOutlineWidth: CGFloat = 1, sliceOutlineColor: Color = Color.primary) {
        self.innerCircleRadiusFraction = innerCircleRadiusFraction
        self.minimumFractionForSliceLabelOffset = minimumFractionForSliceLabelOffset
        self.allowUserInteraction = allowUserInteraction
        self.selectedSliceScaleEffect = selectedSliceScaleEffect
        self.shouldHideMultiFractionSliceOnSelection = shouldHideMultiFractionSliceOnSelection
        self.selectedSliceDropShadow = selectedSliceDropShadow
        self.sliceOutlineWidth = sliceOutlineWidth
        self.sliceOutlineColor = sliceOutlineColor
    }

}
