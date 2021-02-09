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
        
        for _ in 0..<20 {
          let yValue = Int.random(in: 6000 ..< 12000)
           // let yValue:Double = 2000
            let xValue =  endDate.timeIntervalSinceReferenceDate
           let dataPoint = DYDataPoint(xValue: xValue, yValue: Double(yValue))
            dataPoints.append(dataPoint)
            let randomDayDifference = Int.random(in: 1 ..< 8)
            endDate = endDate.add(units: -randomDayDifference, component: .day)
        }
        
//        dataPoints.append(DYDataPoint(xValue: endDate.add(units: -3, component: .day).timeIntervalSinceReferenceDate, yValue: 2000))
//        dataPoints.append(DYDataPoint(xValue: endDate.add(units: -5, component: .day).timeIntervalSinceReferenceDate, yValue: 1000))
        print(dataPoints.map({$0.yValue}))
        return dataPoints
    }
    
}
