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

    var positiveFractions: [DYBarDataFraction] {
        return fractions.filter({$0.value >= 0})
    }
    
    var negativeFractions: [DYBarDataFraction] {
        return fractions.filter({$0.value < 0})
    }
    
    var positiveYValue: Double {
        positiveFractions.map({$0.value}).reduce(0, +)
    }
    
    var negativeYValue: Double {
        negativeFractions.map({$0.value}).reduce(0, +)
    }
    
    var yInterval: Double {
        return positiveYValue + abs(negativeYValue)
    }
    
    var minValue: Double? {
        return fractions.map({$0.value}).min()
    }
    
    var maxValue: Double? {
        return fractions.map({$0.value}).max()
    }
    
//    var yValue: Double {
//        fractions.map({$0.value}).reduce(0, +)
//    }
    
    public init(id: UUID = UUID(), fractions: [DYBarDataFraction], xAxisLabel: String, labelView: ((_ value: Double)-> AnyView)? = nil) {
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
    var labelView: (()-> AnyView)?
    
    public init(id: UUID = UUID(), value: Double, gradient: LinearGradient, labelView: (() -> AnyView)? = nil) {
        self.id = id
        self.value = value
        self.gradient = gradient
        self.labelView = labelView
    }
    
}

