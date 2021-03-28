//
//  DYChartFraction.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

public struct DYChartFraction: Identifiable {
    
    public var id: String
    public var value: Double
    public var color: Color
    public var title: String
    public var detailFractions:[DYChartFraction]
    
    public init(id: String? = UUID().uuidString, value: Double, color: Color = Color.random(), title: String, detailFractions: [DYChartFraction]) {
        self.id = id ?? UUID().uuidString
        self.value = value
        self.color = color
        self.title = title
        self.detailFractions = detailFractions
    }
    
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
    // source https://www.statista.com/statistics/247407/average-annual-consumer-spending-in-the-us-by-type/
    public static func exampleFormatter(value: Double)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(for: value)!
    }
    
    
    
}
