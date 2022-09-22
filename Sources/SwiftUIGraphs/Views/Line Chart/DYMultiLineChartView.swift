//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import SwiftUI

public struct DYMultiLineChartView: View, PlotAreaChart {
   
    var settings: DYPlotAreaSettings
    var lineDataSets: [DYLineDataSet]
    var selectedIndices: [Binding<Int>]
    var plotAreaHeight: CGFloat?
    var yAxisScaler: YAxisScaler
    var xValueAsString: (Double)->String
    var yValueAsString: (Double)->String
    
   // @State private var userTouchingChart: Bool = false
    @State private var touchingXPosition: CGFloat? // User X touch location
    @State private var selectorLineOffset: CGFloat = 0
    
    public init?(lineDataSets: [DYLineDataSet],  selectedIndices: Binding<Int>..., settings: DYLineChartSettingsNew = DYLineChartSettingsNew(xAxisSettings: DYLineChartXAxisSettingsNew()), plotAreaHeight: CGFloat? = nil, xValueAsString: @escaping (Double)->String , yValueAsString:  @escaping (Double)->String) {

        self.lineDataSets = lineDataSets
        self.settings = settings
        self.selectedIndices = selectedIndices
        self.plotAreaHeight = plotAreaHeight
        
        self.xValueAsString = xValueAsString
        self.yValueAsString = yValueAsString
        
        self.yAxisScaler = YAxisScaler(min:0, max: 0, maxTicks: 10) // initialize here otherwise error will be thrown
        let dataPoints = self.allDataPoints
        var min =  dataPoints.map({$0.yValue}).min() ?? 0
        if let overrideMin = settings.yAxisSettings.yAxisMinMaxOverride?.min, overrideMin < min {
            min = overrideMin
        }
         var max = dataPoints.map({$0.yValue}).max() ?? 0
        if let overrideMax = settings.yAxisSettings.yAxisMinMaxOverride?.max, overrideMax > max {
            max = overrideMax
        }
         self.yAxisScaler = YAxisScaler(min:min, max: max, maxTicks: 10)

        print("x axis min max: \(self.xAxisMinMax().min), \(self.xAxisMinMax().max)")
        
    }
    
    private var allDataPoints: [DYDataPoint] {
        var allDataPoints:[DYDataPoint] = []
        for dataSet in self.lineDataSets {
            allDataPoints = allDataPoints + dataSet.dataPoints
        }
        return allDataPoints.sorted(by: {$0.xValue < $1.xValue})
        
    }
    
    private var xValuesMinMax: (min: Double, max: Double) {
        let xValues = allDataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        return (minX, maxX)
}
    
    public var body: some View  {
        GeometryReader { geo in
            Group {
                if self.allDataPoints.count >= 2 {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading {
                         
                                self.yAxisView(yValueAsString: self.yValueAsString)
                                
                            }
                            
                            ZStack {
                                if self.settings.yAxisSettings.showYAxisGridLines {
                                    self.yAxisGridLines()
                                }
                                if (settings.xAxisSettings as! DYLineChartXAxisSettingsNew).showXAxisGridLines {
                                    self.xAxisGridLines()
                                }
                                

                                ForEach(self.lineDataSets) { dataSet in
                                    let index = self.lineDataSets.firstIndex(where: {$0.id == dataSet.id})!
                                    
                                    DYLineView(lineDataSet: dataSet, yAxisSettings: self.settings.yAxisSettings, yAxisScaler: self.yAxisScaler, xValuesMinMax: xValuesMinMax, selectedIndex: self.selectedIndices[index], touchingXPosition: self.$touchingXPosition, selectorLineOffset: self.$selectorLineOffset)
                                    
                                }
                                
                                self.selectorLine()
                                

                                if self.settings.allowUserInteraction {
                                    self.userInteraction()
                                }
                                
                            }.frame(width: geo.size.width - self.settings.yAxisSettings.yAxisViewWidth).background(settings.plotAreaBackgroundGradient)

                            if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing {
                         
                                self.yAxisView(yValueAsString: self.yValueAsString, yAxisPosition: .trailing)
                                
                            }
                            
                        }.frame(height: self.plotAreaHeight)
                        
                        if self.settings.xAxisSettings.showXAxis {
                            self.xAxisView()
                        }
                    }
                }
                
                else {

                    self.placeholderGrid(xAxisLineCount: 12, yAxisLineCount: 10).frame(height: self.plotAreaHeight).opacity(0.5).padding().transition(AnyTransition.opacity)

                }
            }
            
        }
    }
    
    
    private func selectorLine() -> some View {
        GeometryReader { geo in
            (self.settings as! DYLineChartSettingsNew).selectorLineColor
                .frame(width: (self.settings as! DYLineChartSettingsNew).selectorLineWidth)
                 .opacity(touchingXPosition != nil ? 1 : 0) // hide the vertical indicator line if user not touching the chart
                .position(x: self.selectorLineOffset, y: geo.size.height / 2)
                .animation(Animation.spring().speed(4))
        }
    }
    
    private func userInteraction()-> some View {
        GeometryReader { geo in
            Color.white.opacity(0.1)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { dragValue in
                           dragOnChanged(value: dragValue, geo: geo)
                        }
                        .onEnded { dragValue in
                            dragOnEnded(value: dragValue, geo: geo)
                        }
                )
        }
    }
    
    private func dragOnChanged(value: DragGesture.Value, geo: GeometryProxy) {
        self.touchingXPosition =  value.location.x
        self.selectorLineOffset = min(max(0, touchingXPosition!), geo.size.width )
        
    }
    
    private func dragOnEnded(value: DragGesture.Value, geo: GeometryProxy) {
        //let xPos = value.location.x
        self.touchingXPosition = nil
     //   self.userTouchingChart = false
      //  let index = (xPos - leadingMargin) / (((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)))

    }
    
    
    
    //MARK: xAxis
    
    private func xAxisView()-> some View {
        GeometryReader { geo in
            ZStack {
             
                    let labelSteps = self.xAxisLabelSteps(totalWidth: geo.size.width)
                    ForEach(self.xAxisValues(), id:\.self) { value in
                        let i = self.xAxisValues().firstIndex(of: value) ?? 0
                        if  i % labelSteps == 0 {
                            self.xAxisIntervalLabelViewFor(value: value, totalWidth: geo.size.width)
                        }
                    }
                }
   
            .frame(height: 30)
        }
        .padding(.leading, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading ?  settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)

    }
    
    private func xAxisGridLines()-> some View {
        GeometryReader { geo in
            ZStack {
                Path { p in
                    let totalWidth = geo.size.width
                    let totalHeight = geo.size.height
                    var xPosition: CGFloat = 0
                    let count = self.xAxisLineCount()
                    let interval:Double =  (settings.xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
                    let xAxisMinMax = self.xAxisMinMax()
                    let convertedXAxisInterval = totalWidth * CGFloat(interval / (xAxisMinMax.max - xAxisMinMax.min))
                    for _ in 0..<count + 1 {
                        p.move(to: CGPoint(x: xPosition, y: 0))
                        p.addLine(to: CGPoint(x:xPosition, y: totalHeight))
                        xPosition += convertedXAxisInterval
                    }
                }.stroke(style: (settings.xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisGridLineStrokeStyle)
                    .foregroundColor((settings.xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisGridLineColor)
            }

        }
    }

    private func xAxisIntervalLabelViewFor(value:Double, totalWidth: CGFloat)-> some View {
        let xValues = allDataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        let mappedXValue = self.convertToCoordinate(value:value, min: minX, max: maxX, length: totalWidth)
        
        return Text(self.xValueAsString(value)).font(.system(size:settings.xAxisSettings.labelFontSize)).position(x: mappedXValue, y: 10)
    }
    
    func xAxisLabelStrings()->[String] {
        return self.allDataPoints.map({self.xValueAsString($0.xValue)})
    }
    
  
    
    private func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
   
        let count = (xAxisMinMax.max - xAxisMinMax.min) / (settings.xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
        
        return Int(count)
    
        
    }
    
    
    private func xAxisValues()->[Double] {
        var values:[Double] = []
        let count = self.xAxisLineCount()
        var currentValue = self.xAxisMinMax().min
        for _ in 0..<(count + 1) {
            values.append(currentValue)
            currentValue += (settings.xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
            
        }
        return values
    }
    
    private func xAxisMinMax()->(min: Double, max: Double){
        let xValues = allDataPoints.map({$0.xValue})
        return (min: xValues.min() ?? 0, max: xValues.max() ?? 0)
    }
    
    
    
}

//struct DYMultiLineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        DYMultiLineChartView()
//    }
//}
