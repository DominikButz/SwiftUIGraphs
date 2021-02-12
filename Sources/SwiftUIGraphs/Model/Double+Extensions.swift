//
//  NumberFormatter+Extensions.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import Foundation

public extension Double {
    
    func toDecimalString(maxFractionDigits: Int)->String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = maxFractionDigits
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }

    
    
    func rounded(digits: Int, base: Decimal = 10, roundingRule: FloatingPointRoundingRule)->Int {

        let roundFactor = pow(base, digits)
        let roundFactorAsDouble = Double(truncating: NSDecimalNumber(decimal:roundFactor))

        return Int(roundFactorAsDouble)  * Int((self / roundFactorAsDouble).rounded(roundingRule))
    }
    
    func roundingFactorDigits()->Int {
        let integer = Int(self)
        let stringNumber = "\(integer)"
        let digits = stringNumber.count
        var digitsForRoundingFactor  = digits - 2
        if digitsForRoundingFactor == 0 {
            digitsForRoundingFactor = 1
        }
        return digitsForRoundingFactor
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
    
}

public extension Int {
    
    func nearest(multipleOf: Int, up: Bool)->Int {
        // e.g. 1900 % 1800 = 100
        let remainder = self % multipleOf
        
        //1900 + 1800 - 100 = 3600
        var rounded = self - remainder
        if up {
            rounded += multipleOf
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
