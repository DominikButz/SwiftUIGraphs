//
//  File.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import Foundation
import SwiftUI

public extension Color {
    
    static func random()->Color {
        let red = drand48()
        let green = drand48()
        let blue = drand48()
        return Color(.displayP3, red: red, green: green, blue: blue, opacity: 1)
    }
    
    
    /// shadesOf function
    /// - Parameters:
    ///   - color: a base color (opacity should be 1!)
    ///   - number: number of shades, including the base color
    /// - Returns: an array of colors, each of which has a different opacity, in descending order
    static func shadesOf(darker: Bool = true, color: Color, number: Int)->[Color] {
       // let baseColor = color
        var shades:[Color] = [color]
        
        var uiColor = UIColor(color)
        
        // get darker shades
    
        let step: CGFloat  = 1.0 / CGFloat(number) * 100

        for _ in 0..<number  - 1 {
            if darker {
                uiColor = uiColor.darker(by: step)
            } else {
                uiColor = uiColor.lighter(by: step)
            }
            shades.append(Color(uiColor))
        }
        return shades
    }
}


// https://stackoverflow.com/questions/38435308/get-lighter-and-darker-color-variations-for-a-given-uicolor by Oscar
public extension UIColor {

  func lighter(by percentage: CGFloat = 30.0) -> UIColor {
    return self.adjustBrightness(by: abs(percentage))
  }

   func darker(by percentage: CGFloat = 30.0) -> UIColor {
    return self.adjustBrightness(by: -abs(percentage))
  }

  func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {

    let ratio = percentage/100

    var red:   CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue:  CGFloat = 0.0
    var alpha: CGFloat = 0.0

    if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      let newRed =   (red   + ((ratio < 0) ? red   * ratio : (1 - red)   * ratio)).clamped(to: 0.0 ... 1.0)
      let newGreen = (green + ((ratio < 0) ? green * ratio : (1 - green) * ratio)).clamped(to: 0.0 ... 1.0)
      let newBlue =  (blue  + ((ratio < 0) ? blue  * ratio : (1 - blue)  * ratio)).clamped(to: 0.0 ... 1.0)
      return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
    return self
  }
}

//https://stackoverflow.com/questions/38435308/get-lighter-and-darker-color-variations-for-a-given-uicolor by lukszar
extension Comparable {

    func clamped(to range: ClosedRange<Self>) -> Self {

        if self > range.upperBound {
            return range.upperBound
        } else if self < range.lowerBound {
            return range.lowerBound
        } else {
            return self
        }
    }
}
