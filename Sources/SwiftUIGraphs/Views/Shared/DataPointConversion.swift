//
//  File.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import Foundation
import SwiftUI

protocol DataPointConversion {
    
    var yAxisScaler: YAxisScaler {get set}
    
    func convertToCoordinate(value:Double, min: Double, max: Double, length: CGFloat)->CGFloat
    func yAxisMinMax(settings: YAxisSettingsNew)->(min: Double, max: Double)
    
}

extension DataPointConversion {
    
    func yAxisMinMax(settings: YAxisSettingsNew)->(min: Double, max: Double){
        let scaledMin = settings.yAxisMinMaxOverride?.min ?? self.yAxisScaler.scaledMin ?? 0
        let scaledMax = settings.yAxisMinMaxOverride?.max ?? self.yAxisScaler.scaledMax ?? 1
       
       return (min: scaledMin, max: scaledMax)


   }
    
    func convertToCoordinate(value:Double, min: Double, max: Double,  length: CGFloat)->CGFloat {
       
        return length * CGFloat(Double.normalizationFactor(value: value, maxValue: max, minValue: min))

   }
    
    
}
