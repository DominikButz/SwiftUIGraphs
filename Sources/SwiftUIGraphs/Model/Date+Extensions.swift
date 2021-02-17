//
//  Date+Extensions.swift
//  StravaActivityGraph
//
//  Created by Dominik Butz on 28/1/2021.
//

import Foundation

public extension Date {
    
    func add(units: Int, component: Calendar.Component)->Date {
      
        var components = DateComponents()
        components.setValue(units, for: component)
        
        var calendar = Calendar.current
        calendar.timeZone =  TimeZone.current

        let incrementedDate = calendar.date(byAdding: components, to: self)!

        return incrementedDate

    }
    
    func toString(format: String)->String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
       // print(lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate)
           return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
       }
    
}
