//
//  DYDataPoint.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import Foundation

public struct DYDataPoint {
    
    var xValue: Double
    var yValue: Double
    
    public static var exampleData: [DYDataPoint] {
        var dataPoints:[DYDataPoint] = []
        
        var endDate = Date().add(units: -3, component: .hour)
        
        for _ in 0..<12 {
            let yValue = Double.random(in: 1000 ..< 4000)
            let xValue =  endDate.timeIntervalSinceReferenceDate
           let dataPoint = DYDataPoint(xValue: xValue, yValue: yValue)
            dataPoints.append(dataPoint)
            let randomDayDifference = Int.random(in: 1 ..< 8)
            endDate = endDate.add(units: -randomDayDifference, component: .day)
        }
        print(dataPoints.map({$0.yValue}))
        return dataPoints
    }
    
}
