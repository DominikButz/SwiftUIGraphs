//
//  File.swift
//  
//
//  Created by Dominik Butz on 19/8/2022.
//

import Foundation
import SwiftUI

protocol PlotAreaChart  {
    var yAxisScaler: AxisScaler {get set}
    var yAxisSettings: YAxisSettings {get set}
    var xAxisSettings: XAxisSettings {get set}
    func xAxisLabelStrings()->[String]
    mutating func configureYAxisScaler(min: Double, max: Double, maxTicks: Int)
}

extension PlotAreaChart {
    
    func plotAreaFrameWidth(proxy: GeometryProxy)->CGFloat? {
        let yAxisViewWidth = self.yAxisSettings.showYAxis ? self.yAxisSettings.yAxisViewWidth : 0
        let calculatedWidth = proxy.size.width - yAxisViewWidth
        return calculatedWidth > 0 ? calculatedWidth : nil
    }
    
    mutating func configureYAxisScaler(min: Double, max: Double, maxTicks: Int = 10) {
        var didOverrideMin = false
        var didOverrideMax = false
        var min = min
        var max = max
        if let overrideMin = yAxisSettings.yAxisMinMaxOverride?.min, overrideMin < min {
            min = overrideMin
            didOverrideMin = true
        }

        if let overrideMax = yAxisSettings.yAxisMinMaxOverride?.max, overrideMax > max {
            max = overrideMax
            didOverrideMax = true
        }
        self.yAxisScaler = AxisScaler(min:min, max: max, maxTicks: maxTicks, minOverride: didOverrideMin, maxOverride: didOverrideMax)
    }
    
    func yAxisView(yValueAsString: @escaping (Double)->String, yAxisPosition: Edge.Set = .leading)-> some View {
        GeometryReader { geo in
            ZStack(alignment: .trailing) {

                ForEach(self.yAxisValues(), id: \.self) {value in
   
                        self.yAxisIntervalLabelViewFor(value: value, yValueAsString: yValueAsString, totalHeight: geo.size.height)

                    
                }

            }.frame(width: self.yAxisSettings.yAxisViewWidth)
         
         
     
        }
    }
    
    private func yAxisIntervalLabelViewFor(value:Double, yValueAsString: (Double)->String, totalHeight: CGFloat)-> some View {
        Text(yValueAsString(value)).font(.system(size:yAxisSettings.yAxisFontSize)).position(x: self.yAxisSettings.yAxisViewWidth / 2, y: totalHeight - value.convertToCoordinate(min: self.yAxisScaler.axisMinMax.min, max: self.yAxisScaler.axisMinMax.max, length: totalHeight))
    }
    
    func yAxisGridLinesView()-> some View {
        GeometryReader { geo in
  
                Path { p in
                    let width = geo.size.width
                    let height = geo.size.height
                    var yPosition: CGFloat = 0
                    let count = self.yAxisValueCount()
                    let interval:Double =  self.yAxisSettings.yAxisIntervalOverride ?? self.yAxisScaler.tickSpacing ?? 1
                    let min = self.yAxisScaler.axisMinMax.min
                    let max = self.yAxisScaler.axisMinMax.max
                    let convertedYAxisInterval  = height * CGFloat(interval / (max - min))
               
                    for _ in 0..<count  {
                        p.move(to: CGPoint(x: 0, y: yPosition))
                        p.addLine(to: CGPoint(x:width, y: yPosition))
                        yPosition += convertedYAxisInterval
                    }
                }.stroke(style: yAxisSettings.yAxisGridLinesStrokeStyle)
                    .foregroundColor(yAxisSettings.yAxisGridLineColor)

        }
    }
    
    
    func yAxisZeroGridLineView()-> some View {
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            let min = self.yAxisScaler.axisMinMax.min
            let max = self.yAxisScaler.axisMinMax.max
            let zeroYPosition = height - 0.convertToCoordinate(min: min, max: max, length: height)
            if 0 > min && 0 <= max  && (yAxisSettings.yAxisZeroGridLineStrokeStyle  != nil || yAxisSettings.yAxisZeroGridLineColor != nil ){
                Path {p in
                    p.move(to: CGPoint(x: 0, y: zeroYPosition))
                    p.addLine(to: CGPoint(x: width, y: zeroYPosition))
                    p.closeSubpath()
                }.stroke(style: yAxisSettings.yAxisZeroGridLineStrokeStyle ?? yAxisSettings.yAxisGridLinesStrokeStyle)
                    .foregroundColor(yAxisSettings.yAxisZeroGridLineColor ?? yAxisSettings.yAxisGridLineColor)
            }
        }

    }
    
    func placeholderGrid(xAxisLineCount: Int, yAxisLineCount: Int)->some View {
        ZStack {
            VStack {
                ForEach(0..<yAxisLineCount, id:\.self) { i in
                    Line()
                        .stroke(style: self.yAxisSettings.yAxisGridLinesStrokeStyle)
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
                        .stroke(style: self.yAxisSettings.yAxisGridLinesStrokeStyle)
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

        let fontSize =  xAxisSettings.labelFontSize

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
        
        let intervalOverride = yAxisSettings.yAxisIntervalOverride
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
        let intervalOverride = yAxisSettings.yAxisIntervalOverride
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



