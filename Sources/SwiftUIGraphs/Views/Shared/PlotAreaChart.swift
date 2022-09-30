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
    func xAxisLabelStrings()->[String]
    mutating func configureYAxisScaler(min: Double, max: Double)
}

extension PlotAreaChart {
    
    mutating func configureYAxisScaler(min: Double, max: Double) {
        var didOverrideMin = false
        var didOverrideMax = false
        var min = min
        var max = max
        if let overrideMin = settings.yAxisSettings.yAxisMinMaxOverride?.min, overrideMin < min {
            min = overrideMin
            didOverrideMin = true
        }

        if let overrideMax = settings.yAxisSettings.yAxisMinMaxOverride?.max, overrideMax > max {
            max = overrideMax
            didOverrideMax = true
        }
        self.yAxisScaler = YAxisScaler(min:min, max: max, maxTicks: 10, minOverride: didOverrideMin, maxOverride: didOverrideMax)
    }
    
    func yAxisView(yValueAsString: @escaping (Double)->String, yAxisPosition: Edge.Set = .leading)-> some View {
        GeometryReader { geo in
            ZStack(alignment: .trailing) {
               // let interval = self.yAxisScaler.tickSpacing ?? self.settings.yAxisSettings.yAxisIntervalOverride ?? 0
//                if let maxValue = self.yAxisValues().first, maxValue >=  interval {
//                    self.yAxisIntervalLabelViewFor(value: maxValue, yValueAsString: yValueAsString, totalHeight: geo.size.height)
//                }
                ForEach(self.yAxisValues(), id: \.self) {value in
                   // if value != self.yAxisMinMax(settings: settings.yAxisSettings).max {
                       // Spacer(minLength: 0)
                        self.yAxisIntervalLabelViewFor(value: value, yValueAsString: yValueAsString, totalHeight: geo.size.height)
                 //   }
                    
                }

            }.frame(width: self.settings.yAxisSettings.yAxisViewWidth)
         
         
     
        }
    }
    
    private func yAxisIntervalLabelViewFor(value:Double, yValueAsString: (Double)->String, totalHeight: CGFloat)-> some View {
        Text(yValueAsString(value)).font(.system(size:settings.yAxisSettings.yAxisFontSize)).position(x: self.settings.yAxisSettings.yAxisViewWidth / 2, y: totalHeight - self.convertToCoordinate(value: value, min: self.yAxisScaler.axisMinMax.min, max: self.yAxisScaler.axisMinMax.max, length: totalHeight))
    }
    
    func yAxisGridLines()-> some View {
        GeometryReader { geo in
  
                Path { p in
                    let width = geo.size.width
                    let height = geo.size.height
                    var yPosition: CGFloat = 0
                    let count = self.yAxisValueCount()
                    let interval:Double =  self.settings.yAxisSettings.yAxisIntervalOverride ?? self.yAxisScaler.tickSpacing ?? 1
                    let min = self.yAxisScaler.axisMinMax.min
                    let max = self.yAxisScaler.axisMinMax.max
                    let convertedYAxisInterval  = height * CGFloat(interval / (max - min))
               
                    for _ in 0..<count  {
                        p.move(to: CGPoint(x: 0, y: yPosition))
                        p.addLine(to: CGPoint(x:width, y: yPosition))
                        yPosition += convertedYAxisInterval
                    }
                }.stroke(style: settings.yAxisSettings.yAxisGridLinesStrokeStyle)
                    .foregroundColor(settings.yAxisSettings.yAxisGridLineColor)

        }
    }
    
    
    func yAxisZeroGridLine()-> some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            let min = self.yAxisScaler.axisMinMax.min
            let max = self.yAxisScaler.axisMinMax.max
            let zeroYPosition = height - self.convertToCoordinate(value: 0, min: min, max: max, length: height)
            if 0 > min && 0 <= max  && (settings.yAxisSettings.yAxisZeroGridLineStrokeStyle  != nil || settings.yAxisSettings.yAxisZeroGridLineColor != nil ){
                Path {p in
                    p.move(to: CGPoint(x: 0, y: zeroYPosition))
                    p.addLine(to: CGPoint(x: width, y: zeroYPosition))
                    p.closeSubpath()
                }.stroke(style: settings.yAxisSettings.yAxisZeroGridLineStrokeStyle ?? settings.yAxisSettings.yAxisGridLinesStrokeStyle)
                    .foregroundColor(settings.yAxisSettings.yAxisZeroGridLineColor ?? settings.yAxisSettings.yAxisGridLineColor)
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
    
    func xAxisLabelSteps(totalWidth: CGFloat)->Int {
        let allLabels = xAxisLabelStrings()

        let fontSize =  settings.xAxisSettings.labelFontSize

        let ctFont = CTFontCreateWithName(("SFProText-Regular" as CFString), fontSize, nil)
        // let x be the padding
        let padding: CGFloat = 5
        var count = 1
        var totalWidthAllLabels: CGFloat = allLabels.map({$0.width(ctFont: ctFont) + padding}).reduce(0, +)
        if totalWidthAllLabels < totalWidth {
            return count
        }
        
        var labels: [String] = allLabels
        while totalWidthAllLabels  > totalWidth {
            count += 1
            labels = labels.indices.compactMap({
                if $0 % count != 0 { return labels[$0] }
                   else { return nil }
            })
            totalWidthAllLabels = labels.map({$0.width(ctFont: ctFont) + padding}).reduce(0, +)
            

        }
        
        return count
        
    }
    
    func yAxisValues()->[Double] {
        
        let intervalOverride = settings.yAxisSettings.yAxisIntervalOverride
        let minMaxOverriden: Bool = self.yAxisScaler.minOverride || self.yAxisScaler.maxOverride
        guard intervalOverride != nil || minMaxOverriden else {
            return self.yAxisScaler.scaledValues().reversed()
        }
        var values:[Double] = []
        let count = self.yAxisValueCount()
        let interval = intervalOverride ?? self.yAxisScaler.tickSpacing ?? 1
        var currentValue  = self.yAxisScaler.axisMinMax.max
      //  print("value count :\(count)")
        for _ in 0..<(count) {
            values.append(currentValue)
            currentValue -= interval
        }
        return values

    }
    
    

    
    func yAxisValueCount()->Int {
    //   print("y axis lines \(self.yAxisScaler.scaledValues().count)")
        let intervalOverride = settings.yAxisSettings.yAxisIntervalOverride
        let minMaxOverriden: Bool = self.yAxisScaler.minOverride || self.yAxisScaler.maxOverride
        guard intervalOverride != nil || minMaxOverriden else {
            return self.yAxisScaler.scaledValues().count
        }
    
        let yAxisMinMax = self.yAxisScaler.axisMinMax
        let interval = intervalOverride ?? self.yAxisScaler.tickSpacing ?? 1
       let count = (yAxisMinMax.max - yAxisMinMax.min) / interval
    //   print("line count \(count + 1)")
       return Int(count) + 1
   }
    
}
