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
    
    func roundedUp()->Int { 
        let intValue = Int(self)
        let digitCount = String(intValue).count
        
        var roundFactorExp = digitCount - 1
        if roundFactorExp == 0 {
            roundFactorExp = 1
        }
        return self.rounded(digits: roundFactorExp, roundingRule: .up)

    }
    
    func rounded(digits: Int, roundingRule: FloatingPointRoundingRule)->Int {

        let roundFactor = pow(10, digits)
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
}
