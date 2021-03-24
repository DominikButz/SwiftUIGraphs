//
//  File.swift
//  
//
//  Created by Dominik Butz on 17/2/2021.
//

import Foundation
import SwiftUI

protocol GridChart: View {
    
    var dataPoints: [DYDataPoint] {get set}
    var yAxisScaler: YAxisScaler {get set}
    var selectedIndex: Int {get set}
    var settings: DYGridSettings {get set}
    var marginSum: CGFloat {get}
    var chartFrameHeight: CGFloat? {get set}
    var yValueConverter: (Double)->String {get set}
    var xValueConverter: (Double)->String {get set}
    
    func yAxisValueCount()->Int
    func yAxisValues()->[Double]
}


extension GridChart {
    
    func yAxisView(geo: GeometryProxy)-> some View {

        VStack(alignment: .trailing, spacing: 0) {
            let interval = self.yAxisScaler.tickSpacing ?? self.settings.yAxisSettings.yAxisIntervalOverride ?? 0
            if let maxValue = self.yAxisValues().first, maxValue >=  interval {
                Text(self.yValueConverter(maxValue)).font(.system(size: settings.yAxisSettings.yAxisFontSize))
            }
            ForEach(self.yAxisValues(), id: \.self) {value in
                if value != self.yAxisMinMax().max {
                    Spacer(minLength: 0)
                    Text(self.yValueConverter(value)).font(.system(size: settings.yAxisSettings.yAxisFontSize))
                }
                
            }
            
            if self.yAxisValues().count == 1 {
                Spacer()
            }
        
        }
        //.frame(height: geo.size.height)
    }
    
     func yAxisGridLines() -> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                let width = geo.size.width
                Path { p in
                
                    var yPosition:CGFloat = 0

                    let count = self.yAxisValueCount()
                    let yAxisInterval = self.settings.yAxisSettings.yAxisIntervalOverride ?? self.yAxisScaler.tickSpacing ?? 1

                    let min = self.yAxisMinMax().min
                    let max = self.yAxisMinMax().max
                    let convertedYAxisInterval  = geo.size.height * CGFloat(yAxisInterval / (max - min))
                    
                    for _ in 0..<count    {
                         
                        p.move(to: CGPoint(x: 0, y: yPosition))
                        p.addLine(to: CGPoint(x: width, y: yPosition))
                        p.closeSubpath()
                        yPosition += convertedYAxisInterval
                    }

                    
                }.stroke(style: settings.yAxisSettings.yAxisLineStrokeStyle)
                .foregroundColor(.secondary)
                
            }

        }
    }
    

    // helper funcs

    
     func yAxisMinMax()->(min: Double, max: Double){
        let scaledMin = self.settings.yAxisSettings.yAxisMinMaxOverride?.min ?? self.yAxisScaler.scaledMin ?? 0
        let scaledMax = self.settings.yAxisSettings.yAxisMinMaxOverride?.max ?? self.yAxisScaler.scaledMax ?? 1
        
        return (min: scaledMin, max: scaledMax)


    }
    
    
     func yAxisValueCount()->Int {
     //   print("y axis lines \(self.yAxisScaler.scaledValues().count)")
        guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
            return self.yAxisScaler.scaledValues().count
        }
        let yAxisMinMax = self.yAxisMinMax()
        let yAxisInterval = interval
        let count = (yAxisMinMax.max - yAxisMinMax.min) / yAxisInterval
     //   print("line count \(count + 1)")
        return Int(count) + 1
    }
    

    
     func convertToYCoordinate(value:Double, height: CGFloat)->CGFloat {
        
        let yAxisMinMax = self.yAxisMinMax()

        return height * CGFloat(normalizationFactor(value: value, maxValue: yAxisMinMax.max, minValue: yAxisMinMax.min))

    
    }
    
    func yAxisValues()->[Double] {
        
        guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
            return self.yAxisScaler.scaledValues().reversed()
        }
        var values:[Double] = []
        let count = self.yAxisValueCount()
        let yAxisInterval = interval
        var currentValue  = self.yAxisMinMax().max
      //  print("value count :\(count)")
        for _ in 0..<(count) {
            values.append(currentValue)
            currentValue -= yAxisInterval
        }
        return values

    }
    
    func xAxisLabelStrings()->[String] {
        return self.dataPoints.map({self.xValueConverter($0.xValue)})
    }
    
    func xAxisLabelSteps(totalWidth: CGFloat)->Int {
        let allLabels = xAxisLabelStrings()

        let fontSize =  settings.xAxisSettings.xAxisFontSize

        let ctFont = CTFontCreateWithName(("SFProText-Regular" as CFString), fontSize, nil)
        // let 5 be the padding
        var totalWidthAllLabels: CGFloat = allLabels.map({$0.width(ctFont: ctFont) + 5}).reduce(0, +)
        if totalWidthAllLabels < totalWidth {
            return 1
        }
        
        var labels: [String] = allLabels
        var count = 1
        while totalWidthAllLabels > totalWidth {
            count += 1
            labels = labels.indices.compactMap({
                if $0 % 2 != 0 { return labels[$0] }
                   else { return nil }
            })
            totalWidthAllLabels = labels.map({$0.width(ctFont: ctFont)}).reduce(0, +)
            

        }
        
        return count
        
    }
    
     func normalizationFactor(value: Double, maxValue: Double, minValue: Double)->Double {
        
        return (value - minValue) / (maxValue - minValue)
    }
    
    func indexFor(labelString:String)->Int {
       return self.xAxisLabelStrings().firstIndex(where: {$0 == labelString}) ?? 0
   }
    
    func indexFor(dataPoint: DYDataPoint)->Int? {
        return self.dataPoints.firstIndex(where: {$0.id == dataPoint.id})
    }
}
