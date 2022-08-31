//
//  File.swift
//  
//
//  Created by Dominik Butz on 19/8/2022.
//

import Foundation
import SwiftUI

protocol PlotAreaChart: DataPointConversion {
    var settings: DYPlotAreaSettings {get set}
  
}

extension PlotAreaChart {
    
    
    func yAxisView(yValueAsString: @escaping (Double)->String, yAxisPosition: Edge.Set = .leading)-> some View {
        GeometryReader { geo in
            ZStack(alignment: .trailing) {
                let interval = self.yAxisScaler.tickSpacing ?? self.settings.yAxisSettings.yAxisIntervalOverride ?? 0
                if let maxValue = self.yAxisValues().first, maxValue >=  interval {
                    self.yAxisIntervalLabelViewFor(value: maxValue, yValueAsString: yValueAsString, totalHeight: geo.size.height)
                }
                ForEach(self.yAxisValues(), id: \.self) {value in
                    if value != self.yAxisMinMax(settings: settings.yAxisSettings).max {
                       // Spacer(minLength: 0)
                        self.yAxisIntervalLabelViewFor(value: value, yValueAsString: yValueAsString, totalHeight: geo.size.height)
                    }
                    
                }

            }.frame(width: self.settings.yAxisSettings.yAxisViewWidth)
         
         
     
        }
    }
    
    private func yAxisIntervalLabelViewFor(value:Double, yValueAsString: (Double)->String, totalHeight: CGFloat)-> some View {
        Text(yValueAsString(value)).font(.system(size:settings.yAxisSettings.yAxisFontSize)).position(x: self.settings.yAxisSettings.yAxisViewWidth / 2, y: totalHeight - self.convertToCoordinate(value: value, min: self.yAxisMinMax(settings: settings.yAxisSettings).min, max: self.yAxisMinMax(settings: settings.yAxisSettings).max, length: totalHeight))
    }
    
     func yAxisGridLines() -> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                let width = geo.size.width
                Path { p in
                
                    var yPosition:CGFloat = 0

                    let count = self.yAxisValueCount()
                    let yAxisInterval = self.settings.yAxisSettings.yAxisIntervalOverride ?? self.yAxisScaler.tickSpacing ?? 1

                    let min = self.yAxisMinMax(settings: settings.yAxisSettings).min
                    let max = self.yAxisMinMax(settings: settings.yAxisSettings).max
                    let convertedYAxisInterval  = geo.size.height * CGFloat(yAxisInterval / (max - min))
                    
                    for _ in 0..<count    {
                         
                        p.move(to: CGPoint(x: 0, y: yPosition))
                        p.addLine(to: CGPoint(x: width, y: yPosition))
                        p.closeSubpath()
                        yPosition += convertedYAxisInterval
                    }

                    
                }.stroke(style: settings.yAxisSettings.yAxisGridLinesStrokeStyle)
                    .foregroundColor(settings.yAxisSettings.yAxisGridLineColor)
                
            }

        }
    }
    
    func placeholderGrid(xAxisLineCount: Int, yAxisLineCount: Int)->some View {
        ZStack {
            VStack {
                ForEach(0..<yAxisLineCount, id:\.self) { i in
                    Line()
                        .stroke(style: self.settings.yAxisSettings.yAxisGridLinesStrokeStyle)
                        .foregroundColor(.secondary)
                        .frame(height:1)
                    
                    if i < yAxisLineCount - 1 {
                        Spacer()
                    }
                }
            }
            HStack {
                ForEach(0..<xAxisLineCount, id: \.self) { i in
                    Line(horizontal: false)
                        .stroke(style: self.settings.yAxisSettings.yAxisGridLinesStrokeStyle)
                        .foregroundColor(.secondary)
                        .frame(width:1)
                        if i < xAxisLineCount - 1 {
                            Spacer()
                        }
                }
            }
            
        }
    }
    
    //MARK: Helper funcs
    
    func yAxisValues()->[Double] {
        
        guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
            return self.yAxisScaler.scaledValues().reversed()
        }
        var values:[Double] = []
        let count = self.yAxisValueCount()
        let yAxisInterval = interval
        var currentValue  = self.yAxisMinMax(settings: settings.yAxisSettings).max
      //  print("value count :\(count)")
        for _ in 0..<(count) {
            values.append(currentValue)
            currentValue -= yAxisInterval
        }
        return values

    }
    
    

    
    func yAxisValueCount()->Int {
    //   print("y axis lines \(self.yAxisScaler.scaledValues().count)")
       guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
           return self.yAxisScaler.scaledValues().count
       }
        let yAxisMinMax = self.yAxisMinMax(settings: settings.yAxisSettings)
       let yAxisInterval = interval
       let count = (yAxisMinMax.max - yAxisMinMax.min) / yAxisInterval
    //   print("line count \(count + 1)")
       return Int(count) + 1
   }
    
}