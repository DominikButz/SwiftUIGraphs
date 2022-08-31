//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import SwiftUI

public struct DYMultiLineChartView: View, PlotAreaChart {

    var lineDataSets: [DYLineDataSet]
    var settings: DYPlotAreaSettings
    var selectedIndices: [Binding<Int>]
    var plotAreaHeight: CGFloat?
    var yAxisScaler: YAxisScaler
    var xValueAsString: (Double)->String
    var yValueAsString: (Double)->String
    
   // @State private var userTouchingChart: Bool = false
    @State private var touchingXPosition: CGFloat? // User X touch location
    @State private var selectorLineOffset: CGFloat = 0
    
    public init?(lineDataSets: [DYLineDataSet],  selectedIndices: [Binding<Int>], plotAreaSettings: DYPlotAreaSettings = DYPlotAreaSettings(), plotAreaHeight: CGFloat? = nil, xValueAsString: @escaping (Double)->String , yValueAsString:  @escaping (Double)->String) {

        self.lineDataSets = lineDataSets
        self.settings = plotAreaSettings
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
                                if settings.xAxisSettings.showXAxisGridLines {
                                    self.xAxisGridLines()
                                }
                                

                                ForEach(self.lineDataSets) { dataSet in
                                    let index = self.lineDataSets.firstIndex(where: {$0.id == dataSet.id})!
    
                                    DYLineView(lineDataSet: dataSet, yAxisSettings: self.settings.yAxisSettings, yAxisScaler: self.yAxisScaler, selectedIndex: self.selectedIndices[index], touchingXPosition: self.$touchingXPosition, selectorLineOffset: self.$selectorLineOffset)
                                    
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
            self.settings.selectorLineColor
                .frame(width: self.settings.selectorLineWidth)
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

        ZStack(alignment: .center) {
            GeometryReader { geo in
                let labelSteps = self.xAxisLabelSteps(totalWidth: geo.size.width)
                ForEach(self.xAxisValues(), id:\.self) { value in
                    let i = self.xAxisValues().firstIndex(of: value) ?? 0
                    if  i % labelSteps == 0 {
                        self.xAxisIntervalLabelViewFor(value: value, totalWidth: geo.size.width)
                    }
                }
            }

        }
        .padding(.leading, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading ?  settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)
        .frame(height: 30)


    }
    
    private func xAxisGridLines()-> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Path { p in
                    let totalWidth = geo.size.width
                    let totalHeight = geo.size.height
                    var xPosition: CGFloat = 0
                    let count = self.xAxisLineCount()
                    let interval:Double =  self.settings.xAxisSettings.xAxisInterval
                    let xAxisMinMax = self.xAxisMinMax()
                    let convertedXAxisInterval = totalWidth * CGFloat(interval / (xAxisMinMax.max - xAxisMinMax.min))
                    for _ in 0..<count + 1 {
                        p.move(to: CGPoint(x: xPosition, y: 0))
                        p.addLine(to: CGPoint(x:xPosition, y: totalHeight))
                        xPosition += convertedXAxisInterval
                    }
                }.stroke(style: self.settings.xAxisSettings.xAxisGridLineStrokeStyle)
                    .foregroundColor(self.settings.xAxisSettings.xAxisGridLineColor)
            }

        }
    }

    private func xAxisIntervalLabelViewFor(value:Double, totalWidth: CGFloat)-> some View {
        let xValues = allDataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        let mappedXValue = self.convertToCoordinate(value:value, min: minX, max: maxX, length: totalWidth)
        
        return Text(self.xValueAsString(value)).font(.system(size:settings.xAxisSettings.xAxisFontSize)).position(x: mappedXValue, y: 10)
    }
    
    func xAxisLabelStrings()->[String] {
        return self.allDataPoints.map({self.xValueAsString($0.xValue)})
    }
    
    func xAxisLabelSteps(totalWidth: CGFloat)->Int {
        let allLabels = xAxisLabelStrings()

        let fontSize =  settings.xAxisSettings.xAxisFontSize

        let ctFont = CTFontCreateWithName(("SFProText-Regular" as CFString), fontSize, nil)
        // let x be the padding
        var count = 1
        var totalWidthAllLabels: CGFloat = allLabels.map({$0.width(ctFont: ctFont)}).reduce(0, +)
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
            totalWidthAllLabels = labels.map({$0.width(ctFont: ctFont)}).reduce(0, +)
            

        }
        
        return count
        
    }
    
    private func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
   
        let count = (xAxisMinMax.max - xAxisMinMax.min) / settings.xAxisSettings.xAxisInterval
        
        return Int(count)
    
        
    }
    
    
    private func xAxisValues()->[Double] {
        var values:[Double] = []
        let count = self.xAxisLineCount()
        var currentValue = self.xAxisMinMax().min
        for _ in 0..<(count + 1) {
            values.append(currentValue)
            currentValue += settings.xAxisSettings.xAxisInterval
            
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
