//
//  DYBarDataSet.swift
//  
//
//  Created by Dominik Butz on 2/9/2022.
//

import Foundation
import SwiftUI

public struct DYBarDataSet: Identifiable  {

    public let id:UUID
    public var fractions: [DYBarDataFraction]
    public let xAxisLabel: String
    public var labelView: ((_ value: Double)-> AnyView)?

    public var positiveFractions: [DYBarDataFraction] {
        return fractions.filter({$0.value >= 0})
    }
    
    public var negativeFractions: [DYBarDataFraction] {
        return fractions.filter({$0.value < 0})
    }
    
    public var positiveYValue: Double {
        positiveFractions.map({$0.value}).reduce(0, +)
    }
    
    public var negativeYValue: Double {
        negativeFractions.map({$0.value}).reduce(0, +)
    }
    
    public var netValue: Double {
        positiveYValue + negativeYValue
    }
    
    var yInterval: Double {
        return positiveYValue + abs(negativeYValue)
    }
    
    public var minValue: Double? {
        return fractions.map({$0.value}).min()
    }
    
    public var maxValue: Double? {
        return fractions.map({$0.value}).max()
    }

    
    public init(id: UUID = UUID(), fractions: [DYBarDataFraction], xAxisLabel: String, labelView: ((_ value: Double)-> AnyView)? = nil) {
        self.id = id
        self.fractions = fractions
        self.xAxisLabel = xAxisLabel
        self.labelView = labelView

    }
}

public struct DYBarDataFraction: Identifiable  {

    public let id:UUID
    public let value: Double
    public let title: String
    let gradient: LinearGradient
    var labelView: (()->
    AnyView)?
    
    public init(id: UUID = UUID(), value: Double, title:String = "", gradient: LinearGradient, labelView: (() -> AnyView)? = nil) {
        self.id = id
        self.value = value
        self.title = title
        self.gradient = gradient
        self.labelView = labelView
    }
    
}

