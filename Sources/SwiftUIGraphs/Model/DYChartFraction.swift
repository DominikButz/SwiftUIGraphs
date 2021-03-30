//
//  DYChartFraction.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

/// DYChartFraction
public struct DYChartFraction: Identifiable {
    
    public var id: String
    public var value: Double
    public var color: Color
    public var title: String
    public var detailFractions:[DYChartFraction]
    
    /// DY Chart Fraction initializer
    /// - Parameters:
    ///   - id: a unique string id. if not set, a random uuid-string will be set as default.
    ///   - value: value of the fraction.
    ///   - color: color of the slice in the fraction chart view.
    ///   - title: title of the fraction.
    ///   - detailFractions: fractions that this parent fraction struct is composed of. Make sure that the sum of the values are equal to the value of the parent DYChartFraction. Should be empty or contain at least two child DYChartFractions.
    public init(id: String? = UUID().uuidString, value: Double, color: Color = Color.random(), title: String, detailFractions: [DYChartFraction]) {
        self.id = id ?? UUID().uuidString
        self.value = value
        self.color = color
        self.title = title
        self.detailFractions = detailFractions
    }
    
    /// example data: source https://www.statista.com/statistics/247407/average-annual-consumer-spending-in-the-us-by-type/
    /// - Returns: an array of DYChart Fractions.
    public static func exampleData()->[DYChartFraction] {
        
        let housing = DYChartFraction(value: 20679, title: "Housing", detailFractions: [])
        let transportation = DYChartFraction(value: 10742, title: "Transportation", detailFractions: [])
        let food = DYChartFraction(value:8169, title: "Food", detailFractions: [])
        let insurance = DYChartFraction(value: 7165,  title: "Pers. Insurance & Pensions", detailFractions: [])
        let health = DYChartFraction(value: 5193, title: "Healthcare", detailFractions: [])
        let entertainment = DYChartFraction(value: 3050, title: "Entertainment", detailFractions: [])
        let cash = DYChartFraction(value: 1995, title: "Cash Contrib.", detailFractions: [])
        let other = DYChartFraction(value: 1891, title: "Other", detailFractions: [])
        let apparel = DYChartFraction(value: 1883, title: "Apparel & Services", detailFractions: [])
        
        return [housing, transportation, food, insurance, health, entertainment, cash, other, apparel]
    }
    

}
