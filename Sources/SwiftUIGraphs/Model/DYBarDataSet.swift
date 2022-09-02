//
//  DYBarChartDataSet.swift
//  
//
//  Created by Dominik Butz on 2/9/2022.
//

import Foundation
import SwiftUI

public struct DYBarDataSet: Identifiable  {

    
    public let id:UUID
    var fractions: [DYBarDataFraction]
    let xAxisLabel: String
    var labelView: ((_ value: Double)-> AnyView)?
    var yValue: Double {
        fractions.map({$0.value}).reduce(0, +)
    }
    
    public init(id: UUID = UUID(), fractions: [DYBarDataFraction], xAxisLabel: String, labelView: ((Double) -> AnyView)? = nil) {
        self.id = id
        self.fractions = fractions
        self.xAxisLabel = xAxisLabel
        self.labelView = labelView
    }
}

public struct DYBarDataFraction: Identifiable  {

    public let id:UUID
    let value: Double
    let gradient: LinearGradient
    var labelView: ((_ value: Double)-> AnyView)?
    
    public init(id: UUID = UUID(), value: Double, gradient: LinearGradient, labelView: ((Double) -> AnyView)? = nil) {
        self.id = id
        self.value = value
        self.gradient = gradient
        self.labelView = labelView
    }
    
}

