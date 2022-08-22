//
//  NumberFormatter+Extensions.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import Foundation

public extension Double {
    
    
    static func normalizationFactor(value: Double, maxValue: Double, minValue: Double)->Double {
       
       return (value - minValue) / (maxValue - minValue)
   }
    
    func convertToCoordinate(min: Double, max: Double,  length: CGFloat)->CGFloat {
       
        return length * CGFloat(Double.normalizationFactor(value: self, maxValue: max, minValue: min))

   }
    
    func toDecimalString(maxFractionDigits: Int)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxFractionDigits
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }
    
    func toCurrencyString(symbol:String = "USD", maxDigits: Int = 0)->String {
        
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.currencySymbol = symbol
            formatter.maximumFractionDigits = maxDigits
            return formatter.string(for: self)!
        
    }

 
    func decimalsCount() -> Int {
        if self == Double(Int(self)) {
            return 0
        }

        let integerString = String(Int(self))
        let doubleString = String(Double(self))
        let decimalCount = doubleString.count - integerString.count - 1

        return decimalCount
    }
    
    func percentageString(totalValue: Double)->String {
        let fractionValue = self / totalValue
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(for: fractionValue)!
        
    }
    
}

public extension Int {
    
    func nearest(multipleOf: UInt, up: Bool)->Int {
        // e.g. -12 % 10 = -2
        let remainder = self % Int(multipleOf)

        let addFullUnit = self >= 0 && up == true || self < 0 && up == false
        //  -12 -- 2 = -10
        var rounded = self - remainder
        if addFullUnit {
            rounded += Int(multipleOf)
        }
        
        return rounded
    }
    
}


public extension TimeInterval {
    func toString()->String? {

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        
        formatter.allowedUnits = self >= 3600 ? [ .hour, .minute, .second] : [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        var resultString = formatter.string(from: self)
        if let result = resultString, result.hasPrefix("0") {
            resultString?.removeFirst()
        }
        return resultString
    }
}
