//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import SwiftUI



public struct DYMultiLineChartView<L: View>: View, PlotAreaChart, DYMultiLineChartModifiableProperties {

    public var settings: DYLineChartSettingsNew
    public var yAxisSettings: YAxisSettingsNew
    public var xAxisSettings: XAxisSettings
    var allDataPoints: [DYDataPoint]
    var yAxisScaler: YAxisScaler
    var xValueAsString: (Double)->String
    var yValueAsString: (Double)->String
    var lineViews: (DYLineParentViewProperties)->L
   // @State private var userTouchingChart: Bool = false
    @State private var touchingXPosition: CGFloat? // User X touch location
    @State private var selectorLineOffset: CGFloat = 0

    
    public init(allDataPoints: [DYDataPoint], @ViewBuilder lineViews: @escaping (DYLineParentViewProperties)->L,  xValueAsString: @escaping (Double)->String , yValueAsString:  @escaping (Double)->String) {

        self.allDataPoints = allDataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.settings = DYLineChartSettingsNew()
        self.xAxisSettings = DYLineChartXAxisSettingsNew()
        self.yAxisSettings = YAxisSettingsNew()
        self.xValueAsString = xValueAsString
        self.yValueAsString = yValueAsString
        
        self.yAxisScaler = YAxisScaler(min:allDataPoints.map({$0.yValue}).min() ?? 0, max: allDataPoints.map({$0.yValue}).max() ?? 0, maxTicks: 10, minOverride: false, maxOverride: false)
       // self.configureYAxisScaler(min: allDataPoints.map({$0.yValue}).min() ?? 0, max:  allDataPoints.map({$0.yValue}).max() ?? 0)
        self.lineViews = lineViews
        //print("x axis min max: \(self.xAxisMinMax().min), \(self.xAxisMinMax().max)")
        //print("some value: \(someValue)")
        
    }
    

    
    private var globalxValuesMinMax: (min: Double, max: Double) {
        let xValues = allDataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        return (minX, maxX)
    }
    
    public var body: some View  {
        GeometryReader { geo in
            //Group {
                if self.allDataPoints.count >= 2 {
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            if self.yAxisSettings.showYAxis && yAxisSettings.yAxisPosition == .leading {
                         
                                self.yAxisView(yValueAsString: self.yValueAsString)
                                
                            }
                            
                            ZStack {
                                if self.yAxisSettings.showYAxisGridLines  {
                                    self.yAxisGridLines()
                                    self.yAxisZeroGridLine() 
                                }
                                
                                if (xAxisSettings as! DYLineChartXAxisSettingsNew).showXAxisGridLines {
                                    self.xAxisGridLines()
                                }
                                

                                lineViews((yAxisSettings, yAxisScaler, globalxValuesMinMax, $touchingXPosition, $selectorLineOffset))
//                                ForEach(self.lineDataSets) { dataSet in
//
//                                    DYLineView(lineDataSet: dataSet, yAxisSettings: self.yAxisSettings, yAxisScaler: self.yAxisScaler, xValuesMinMax: xValuesMinMax, touchingXPosition: self.$touchingXPosition, selectorLineOffset: self.$selectorLineOffset)
//
//                                }
                                
                                self.selectorLine().clipped()
                                

                                if self.settings.allowUserInteraction {
                                    self.userInteraction()
                                }
                                
                            }.frame(width: geo.size.width - self.yAxisSettings.yAxisViewWidth).background(settings.plotAreaBackgroundGradient)
                             

                            if self.yAxisSettings.showYAxis && yAxisSettings.yAxisPosition == .trailing {
                         
                                self.yAxisView(yValueAsString: self.yValueAsString, yAxisPosition: .trailing)
                                
                            }
                            
                        }
                        
                        if xAxisSettings.showXAxis {
                            self.xAxisView().frame(height:xAxisSettings.xAxisViewHeight  )
                        }
                    }

                }
                
                else {

                    self.placeholderGrid(xAxisLineCount: 12, yAxisLineCount: 10).opacity(0.5).padding().transition(AnyTransition.opacity)

                }
           // }
            
        }
    }
    
    
    private func selectorLine() -> some View {
        GeometryReader { geo in
           settings.selectorLineColor
                .frame(width: settings.selectorLineWidth)
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

        self.touchingXPosition = nil

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
        }
        .padding(.leading, yAxisSettings.showYAxis && yAxisSettings.yAxisPosition == .leading ?  yAxisSettings.yAxisViewWidth : 0)
        .padding(.trailing, yAxisSettings.showYAxis && yAxisSettings.yAxisPosition == .trailing ? yAxisSettings.yAxisViewWidth : 0)

    }
    
    private func xAxisGridLines()-> some View {
        GeometryReader { geo in
            ZStack {
                Path { p in
                    let totalWidth = geo.size.width
                    let totalHeight = geo.size.height
                    var xPosition: CGFloat = 0
                    let count = self.xAxisLineCount()
                    let interval:Double =  (xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
                    let xAxisMinMax = self.xAxisMinMax()
                    let convertedXAxisInterval = totalWidth * CGFloat(interval / (xAxisMinMax.max - xAxisMinMax.min))
                    for _ in 0..<count + 1 {
                        p.move(to: CGPoint(x: xPosition, y: 0))
                        p.addLine(to: CGPoint(x:xPosition, y: totalHeight))
                        xPosition += convertedXAxisInterval
                    }
                }.stroke(style: (xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisGridLineStrokeStyle)
                    .foregroundColor((xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisGridLineColor)
            }

        }
    }
    

    private func xAxisIntervalLabelViewFor(value:Double, totalWidth: CGFloat)-> some View {
        let xValues = allDataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        let mappedXValue = self.convertToCoordinate(value:value, min: minX, max: maxX, length: totalWidth)
        
        return Text(self.xValueAsString(value)).font(.system(size:xAxisSettings.labelFontSize)).position(x: mappedXValue, y: 10)
    }
    
    func xAxisLabelStrings()->[String] {
        return self.allDataPoints.map({self.xValueAsString($0.xValue)})
    }
    
  
    
    private func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
   
        let count = (xAxisMinMax.max - xAxisMinMax.min) / (xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
        
        return Int(count)
    
        
    }
    
    
    private func xAxisValues()->[Double] {
        var values:[Double] = []
        let count = self.xAxisLineCount()
        var currentValue = self.xAxisMinMax().min
        for _ in 0..<(count + 1) {
            values.append(currentValue)
            currentValue += (xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
            
        }
        return values
    }
    
    private func xAxisMinMax()->(min: Double, max: Double){
        let xValues = allDataPoints.map({$0.xValue})
        return (min: xValues.min() ?? 0, max: xValues.max() ?? 0)
    }
    
    
    
}


public protocol DYMultiLineChartModifiableProperties {
    var settings: DYLineChartSettingsNew {get set}
    var xAxisSettings: XAxisSettings {get set}
    var yAxisSettings: YAxisSettingsNew {get set}
}

public extension View where Self: DYMultiLineChartModifiableProperties {
    
    func background(gradient: LinearGradient)->DYMultiLineChartView<DYLineView> {
        var modView = self
        modView.settings.plotAreaBackgroundGradient = gradient
        return modView as! DYMultiLineChartView<DYLineView>
  
    }
    
    func userInteraction(enabled: Bool = true)->DYMultiLineChartView<DYLineView> {
        var modView = self
        modView.settings.allowUserInteraction = enabled
        return modView as! DYMultiLineChartView<DYLineView>
    }
     
    func selectorLine(color: Color = .red, width: CGFloat = 2)->DYMultiLineChartView<DYLineView>  {
        var modView = self
        modView.settings.selectorLineColor = color
        modView.settings.selectorLineWidth = width
        return modView as! DYMultiLineChartView<DYLineView>
        
    }
    
    /// XAxisSettings
    func showXaxis(_ show: Bool = true)->DYMultiLineChartView<DYLineView> {
        var modView = self
        modView.xAxisSettings.showXAxis = show
        return modView as! DYMultiLineChartView<DYLineView>
    }
    
    func xAxisInterval(_ interval: Double = 100)->DYMultiLineChartView<DYLineView> {
        var modView = self
        var xAxisSettings = modView.xAxisSettings as! DYLineChartXAxisSettingsNew
        xAxisSettings.xAxisInterval = interval
        modView.xAxisSettings = xAxisSettings
        return modView as! DYMultiLineChartView<DYLineView>
    }
    
    func xAxisViewHeight(_ height: CGFloat = 20)->DYMultiLineChartView<DYLineView> {
        var modView = self
        modView.xAxisSettings.xAxisViewHeight = height
        return modView as! DYMultiLineChartView<DYLineView>
    }
    
    func xAxisStyle(fontSize: CGFloat = 8, showGridLines: Bool = true, gridLineColor: Color = Color.secondary.opacity(0.5), gridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]))->DYMultiLineChartView<DYLineView> {
        var modView = self
        var xAxisSettings = modView.xAxisSettings as! DYLineChartXAxisSettingsNew
        xAxisSettings.labelFontSize = fontSize
        xAxisSettings.showXAxisGridLines = showGridLines
        xAxisSettings.xAxisGridLineColor = gridLineColor
        xAxisSettings.xAxisGridLineStrokeStyle = gridLineStrokeStyle
        modView.xAxisSettings = xAxisSettings
        return modView as! DYMultiLineChartView<DYLineView>
        
    }
    
    /// YAxisSettings
    func showYaxis(_ show: Bool = true)->DYMultiLineChartView<DYLineView> {
        var modView = self
        modView.yAxisSettings.showYAxis = show
        return modView as! DYMultiLineChartView<DYLineView>
    }
    
    func yAxisPosition(_ position: Edge.Set = .leading)->DYMultiLineChartView<DYLineView> {
        var modView = self
        modView.yAxisSettings.yAxisPosition = position
        return modView as! DYMultiLineChartView<DYLineView>
    }
    
    func yAxisViewWidth(_ height: CGFloat = 35)->DYMultiLineChartView<DYLineView> {
        var modView = self
        modView.yAxisSettings.yAxisViewWidth = height
        return modView as! DYMultiLineChartView<DYLineView>
    }
    
    func yAxisStyle(fontSize: CGFloat = 8, showGridLines: Bool = true, gridLineColor: Color = Color.secondary.opacity(0.5), gridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), zeroGridLineColor: Color? = nil, zeroGridLineStrokeStyle: StrokeStyle? = nil)->DYMultiLineChartView<DYLineView> {
        var modView = self
        var yAxisSettings = modView.yAxisSettings
        yAxisSettings.yAxisFontSize = fontSize
        yAxisSettings.showYAxisGridLines = showGridLines
        yAxisSettings.yAxisGridLineColor = gridLineColor
        yAxisSettings.yAxisGridLinesStrokeStyle = gridLineStrokeStyle
        yAxisSettings.yAxisZeroGridLineColor = zeroGridLineColor
        yAxisSettings.yAxisZeroGridLineStrokeStyle = zeroGridLineStrokeStyle
        modView.yAxisSettings = yAxisSettings
        return modView as! DYMultiLineChartView<DYLineView>
        
    }
    
    func yAxisScalerOverride(minMax: (min:Double?, max:Double?)? = nil, interval: Double? = nil) ->DYMultiLineChartView<DYLineView> {
        var modView  = self as! DYMultiLineChartView<DYLineView>
        modView.yAxisSettings.yAxisMinMaxOverride = minMax
        modView.yAxisSettings.yAxisIntervalOverride = interval
        modView.configureYAxisScaler(min: modView.allDataPoints.map({$0.yValue}).min() ?? 0, max: modView.allDataPoints.map({$0.yValue}).max() ?? 0)
        return modView
        
    }
    
}



//var yAxisMinMaxOverride: (min:Double?, max:Double?)?
//var yAxisIntervalOverride: Double?



//struct DYMultiLineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        DYMultiLineChartView()
//    }
//}
