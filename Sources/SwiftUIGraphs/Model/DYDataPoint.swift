//
//  DYDataPoint.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import Foundation

public struct DYDataPoint: Identifiable {
    
    public let id:UUID = UUID()
    
    /// DYDataPoint initializer
    /// - Parameters:
    ///   - xValue: the x-value of the data point.
    ///   - yValue: the y-value of the data point.
    public init(xValue: Double, yValue: Double) {
        self.xValue = xValue
        self.yValue = yValue
    }
    
    public var xValue: Double
    public var yValue: Double
    
    /// example data: e.g. y-values are seconds.
    public static var exampleData0: [DYDataPoint] {
        var dataPoints:[DYDataPoint] = []
        
        var endDate = Date().add(units: -3, component: .hour)
        
        for _ in 0..<20 {
          let yValue = Int.random(in: 6000 ..< 12000)

            let xValue =  endDate.timeIntervalSinceReferenceDate
           let dataPoint = DYDataPoint(xValue: xValue, yValue: Double(yValue))
            dataPoints.append(dataPoint)
            let randomDayDifference = Int.random(in: 1 ..< 8)
            endDate = endDate.add(units: -randomDayDifference, component: .day)
        }

        return dataPoints
    }
    
    /// e.g. weight volume per exercise
    public static var exampleData1: [DYDataPoint] {
        var dataPoints:[DYDataPoint] = []
        
        var endDate = Date().add(units: -3, component: .hour)
        
        for _ in 0..<14 {
          let yValue = Double.random(in: 1500 ..< 1940)
            let xValue =  endDate.timeIntervalSinceReferenceDate
           let dataPoint = DYDataPoint(xValue: xValue, yValue: yValue)
            dataPoints.append(dataPoint)
            let randomDayDifference = Int.random(in: 1 ..< 8)
            endDate = endDate.add(units: -randomDayDifference, component: .day)
        }

        return dataPoints
    }
    
}
