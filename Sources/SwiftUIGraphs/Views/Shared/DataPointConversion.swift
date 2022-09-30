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
   // func yAxisMinMax(settings: YAxisSettingsNew)->(min: Double, max: Double)
    
}
 
extension DataPointConversion {
    
//    func yAxisMinMax(settings: YAxisSettingsNew)->(min: Double, max: Double){
//
//        let scaledMin =  self.yAxisScaler.minOverride ? self.yAxisScaler.minPoint :  self.yAxisScaler.scaledMin ?? 0
//        let scaledMax = self.yAxisScaler.maxOverride ? self.yAxisScaler.maxPoint :  self.yAxisScaler.scaledMax ?? 0
//
//       return (min: scaledMin, max: scaledMax)
//
//
//   }
    
//    var scaledMin:Double = 0
//    var scaledMax:Double = 1
//    if let overrideMin = settings.yAxisMinMaxOverride?.min {
//        if overrideMin < valueRangeMin {
//            scaledMin = overrideMin
//        }
//    } else {
//        scaledMin =  self.yAxisScaler.scaledMin ?? 0
//    }
//
//    if let overrideMax = settings.yAxisMinMaxOverride?.max {
//        if overrideMax > valueRangeMax {
//            scaledMax = overrideMax
//        }
//    } else {
//        scaledMax =  self.yAxisScaler.scaledMax ?? 1
//    }
    
    func convertToCoordinate(value:Double, min: Double, max: Double,  length: CGFloat)->CGFloat {
       
        return length * CGFloat(Double.normalizationFactor(value: value, maxValue: max, minValue: min))

   }
    
    
}
