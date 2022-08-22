//
//  DYChartFraction.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

/// DYChartFraction
public struct DYPieFraction: Identifiable, Equatable {
    
    public var id: String
    public var value: Double
    public var color: Color
    public var title: String
    public var detailFractions:[DYPieFraction]
    
    /// DY Chart Fraction initializer
    /// - Parameters:
    ///   - id: a unique string id. if not set, a random uuid-string will be set as default.
    ///   - value: value of the fraction.
    ///   - color: color of the slice in the fraction chart view.
    ///   - title: title of the fraction.
    ///   - detailFractions: fractions that this parent fraction struct is composed of. Make sure that the sum of the values are equal to the value of the parent DYChartFraction. Should be empty or contain at least two child DYChartFractions.
    public init(id: String? = UUID().uuidString, value: Double, color: Color = Color.random(), title: String, detailFractions: [DYPieFraction]) {
        self.id = id ?? UUID().uuidString
        self.value = value
        self.color = color
        self.title = title
        self.detailFractions = detailFractions
        if detailFractions.count > 0 {
            if self.detailFractions.count == 1 {
                assertionFailure("You can either add none or at least two detail fractions.")
            }
            let valueSum = detailFractions.map{$0.value}.reduce(0,+)
            if valueSum != self.value {
                assertionFailure("The sum of all detail fraction values needs to be equal to the parent chart fraction value!")
            }
        }
    }
    
    /// example data: source https://www.statista.com/statistics/247407/average-annual-consumer-spending-in-the-us-by-type/
    /// - Returns: an array of DYChart Fractions.
    public static func exampleData()->[DYPieFraction] {
        
        let housing = DYPieFraction(value: 20679, title: "Housing", detailFractions: [])
        let transportation = DYPieFraction(value: 10742, title: "Transportation", detailFractions: [])
        let food = DYPieFraction(value:8169, title: "Food", detailFractions: [])
        let insurance = DYPieFraction(value: 7165,  title: "Pers. Insurance & Pensions", detailFractions: [])
        let health = DYPieFraction(value: 5193, title: "Healthcare", detailFractions: [])
        let entertainment = DYPieFraction(value: 3050, title: "Entertainment", detailFractions: [])
        let cash = DYPieFraction(value: 1995, title: "Cash Contrib.", detailFractions: [])
        let other = DYPieFraction(value: 1891, title: "Other", detailFractions: [])
        let apparel = DYPieFraction(value: 1883, title: "Apparel & Services", detailFractions: [])
        
        return [housing, transportation, food, insurance, health, entertainment, cash, other, apparel]
    }
    

}
