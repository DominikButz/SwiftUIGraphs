//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import SwiftUI



public struct DYMultiLineChartView<L>: View, PlotAreaChart, DYMultiLineChartModifiableProperties  where L: View {
   
    public var settings: DYLineChartSettingsNew
    public var yAxisSettings: YAxisSettingsNew
    public var xAxisSettings: XAxisSettings
    var allDataPoints: [DYDataPoint]
    var yAxisScaler: AxisScaler
    var xAxisScaler: AxisScaler
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
        
        self.yAxisScaler = AxisScaler(min:allDataPoints.map({$0.yValue}).min() ?? 0, max: allDataPoints.map({$0.yValue}).max() ?? 0, maxTicks: 10, minOverride: false, maxOverride: false)
       // self.configureYAxisScaler(min: allDataPoints.map({$0.yValue}).min() ?? 0, max:  allDataPoints.map({$0.yValue}).max() ?? 0)
        
        self.xAxisScaler = AxisScaler(min:allDataPoints.map({$0.xValue}).min() ?? 0, max: allDataPoints.map({$0.xValue}).max() ?? 0, maxTicks: 20, minOverride: false, maxOverride: false)
        
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
                                    self.xAxisGridLines().clipped()
                                }
                                

                                lineViews((yAxisSettings, yAxisScaler, xAxisScaler, $touchingXPosition, $selectorLineOffset))
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
    
    mutating  func configureXAxisScaler(min: Double, max: Double, maxTicks: Int = 30) {
        var didOverrideMin = false
        var didOverrideMax = false
        var min = min
        var max = max
        if let overrideMin = (xAxisSettings as! DYLineChartXAxisSettingsNew).minMaxOverride?.min, overrideMin <= min {
            min = overrideMin
            didOverrideMin = true
        }

        if let overrideMax = (xAxisSettings as! DYLineChartXAxisSettingsNew).minMaxOverride?.max, overrideMax >= max {
            max = overrideMax
            didOverrideMax = true
        }
        self.xAxisScaler = AxisScaler(min:min, max: max, maxTicks: maxTicks, minOverride: didOverrideMin, maxOverride: didOverrideMax)
    }
    
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
                    let count = self.xAxisValueCount()
                   // let interval:Double =  (xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
                    // NEW:
                   let interval =  (self.xAxisSettings as! DYLineChartXAxisSettingsNew).intervalOverride ?? self.xAxisScaler.tickSpacing ?? 1
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
//        let xValues = allDataPoints.map({$0.xValue})
//        let maxX = xValues.max() ?? 0
//        let minX = xValues.min() ?? 0
        let xAxisMinMax = self.xAxisScaler.axisMinMax
        let maxX = xAxisMinMax.max
        let minX = xAxisMinMax.min
        let mappedXValue = self.convertToCoordinate(value:value, min: minX, max: maxX, length: totalWidth)
        
        return Text(self.xValueAsString(value)).font(.system(size:xAxisSettings.labelFontSize)).position(x: mappedXValue, y: 10)
    }
    
    public func xAxisLabelStrings()->[String] {
        return xAxisValues().map({self.xValueAsString($0)})
       // return self.allDataPoints.map({self.xValueAsString($0.xValue)})
    }
    
  
    
    private func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
        /// NEW
        let interval = (self.xAxisSettings as! DYLineChartXAxisSettingsNew).intervalOverride ?? self.xAxisScaler.tickSpacing ?? 1
//        let count = (xAxisMinMax.max - xAxisMinMax.min) / (xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
        /// NEW
        let count = (xAxisMinMax.max - xAxisMinMax.min) / interval
        return Int(count)
    
        
    }
    
    ///NEW
    func xAxisValues()->[Double] {
        
        let intervalOverride = (xAxisSettings as! DYLineChartXAxisSettingsNew).intervalOverride
        let minMaxOverriden: Bool = self.xAxisScaler.minOverride || self.xAxisScaler.maxOverride
        guard intervalOverride != nil || minMaxOverriden else {
            return self.xAxisScaler.scaledValues()
        }
        var values:[Double] = []
        let count = self.xAxisValueCount()
        let interval = intervalOverride ?? self.xAxisScaler.tickSpacing ?? 1
        var currentValue  = self.xAxisScaler.axisMinMax.min
      //  print("value count :\(count)")
        for _ in 0..<(count) {
            values.append(currentValue)
            currentValue += interval
        }
        return values

    }
    
    ///NEW
    func xAxisValueCount()->Int {
    //   print("y axis lines \(self.yAxisScaler.scaledValues().count)")
        let intervalOverride =  (xAxisSettings as! DYLineChartXAxisSettingsNew).intervalOverride
        let minMaxOverriden: Bool = self.xAxisScaler.minOverride || self.xAxisScaler.maxOverride
        guard intervalOverride != nil || minMaxOverriden else {
            return self.xAxisScaler.scaledValues().count
        }
    
        let xAxisMinMax = self.xAxisScaler.axisMinMax
        let interval = intervalOverride ?? self.xAxisScaler.tickSpacing ?? 1
       let count = (xAxisMinMax.max - xAxisMinMax.min) / interval
    //   print("line count \(count + 1)")
       return Int(count) + 1
   }
    
    
//    private func xAxisValues()->[Double] {
//        var values:[Double] = []
//        let count = self.xAxisLineCount()
//        var currentValue = self.xAxisMinMax().min
//        for _ in 0..<(count + 1) {
//            values.append(currentValue)
//            currentValue += (xAxisSettings as! DYLineChartXAxisSettingsNew).xAxisInterval
//
//        }
//        return values
//    }
    
//    private func xAxisMinMax()->(min: Double, max: Double){
//        let xValues = allDataPoints.map({$0.xValue})
//        return (min: xValues.min() ?? 0, max: xValues.max() ?? 0)
//    }
    
    /// NEW
    private func xAxisMinMax()->(min: Double, max: Double){
        return self.xAxisScaler.axisMinMax
        //return (self.xAxisScaler.scaledMin ?? 0 , self.xAxisScaler.scaledMax ?? 1)
    }
    
    
    
}


public protocol DYMultiLineChartModifiableProperties where Self: View {
    associatedtype L: View 
//    var settings: DYLineChartSettingsNew {get set}
//    var xAxisSettings: XAxisSettings {get set}
//    var yAxisSettings: YAxisSettingsNew {get set}

}

public extension View where Self:  DYMultiLineChartModifiableProperties {
    
    func background(gradient: LinearGradient)->DYMultiLineChartView<L> {
       var modView = self as! DYMultiLineChartView<L>

        modView.settings.plotAreaBackgroundGradient = gradient
        return modView
        
    }
    
    func selectorLine(color: Color = .red, width: CGFloat = 2)->DYMultiLineChartView<L>   {
        var modView = self  as! DYMultiLineChartView<L>
        modView.settings.selectorLineColor = color
        modView.settings.selectorLineWidth = width
        return modView
        
    }
    
    // modView.settings.plotAreaBackgroundGradient = gradient
    
    func userInteraction(enabled: Bool = true)->DYMultiLineChartView<L> {
        var modView = self as! DYMultiLineChartView<L>
        modView.settings.allowUserInteraction = enabled
        return modView
    }
//
    /// x-Axis settings
    func xAxisScalerOverride(minMax: (min:Double?, max:Double?)? = nil, interval: Double? = nil, maxTicks: Int = 20) ->DYMultiLineChartView<L> {
            var modView = self as! DYMultiLineChartView<L>
            var xAxisSettings = modView.xAxisSettings as! DYLineChartXAxisSettingsNew
            xAxisSettings.minMaxOverride = minMax
            xAxisSettings.intervalOverride = interval
            modView.xAxisSettings = xAxisSettings
            modView.configureXAxisScaler(min: modView.allDataPoints.map({$0.xValue}).min() ?? 0, max: modView.allDataPoints.map({$0.xValue}).max() ?? 0, maxTicks: maxTicks)
            return modView
    
    }

    func showXaxis(_ show: Bool = true)->DYMultiLineChartView<L>  {
        var modView = self as! DYMultiLineChartView<L>
        modView.xAxisSettings.showXAxis = show
        return modView
    }
//    

//    
    func xAxisViewHeight(_ height: CGFloat = 20)->DYMultiLineChartView<L>{
        var modView = self as! DYMultiLineChartView<L>
        modView.xAxisSettings.xAxisViewHeight = height
        return modView
    }
//    
    func xAxisStyle(fontSize: CGFloat = 8, showGridLines: Bool = true, gridLineColor: Color = Color.secondary.opacity(0.5), gridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]))->DYMultiLineChartView<L>{
        var modView = self  as! DYMultiLineChartView<L>
        var xAxisSettings = modView.xAxisSettings as! DYLineChartXAxisSettingsNew
        xAxisSettings.labelFontSize = fontSize
        xAxisSettings.showXAxisGridLines = showGridLines
        xAxisSettings.xAxisGridLineColor = gridLineColor
        xAxisSettings.xAxisGridLineStrokeStyle = gridLineStrokeStyle
        modView.xAxisSettings = xAxisSettings
        return modView
        
    }
//    
//    /// YAxisSettings
    func showYaxis(_ show: Bool = true)->DYMultiLineChartView<L>{
        var modView = self as! DYMultiLineChartView<L>
        modView.yAxisSettings.showYAxis = show
        return modView
    }
//    
    func yAxisPosition(_ position: Edge.Set = .leading)->DYMultiLineChartView<L> {
        var modView = self as! DYMultiLineChartView<L>
        modView.yAxisSettings.yAxisPosition = position
        return modView
    }
//    
    func yAxisViewWidth(_ height: CGFloat = 35)->DYMultiLineChartView<L> {
        var modView = self as! DYMultiLineChartView<L>
        modView.yAxisSettings.yAxisViewWidth = height
        return modView
    }
//    
    func yAxisStyle(fontSize: CGFloat = 8, showGridLines: Bool = true, gridLineColor: Color = Color.secondary.opacity(0.5), gridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), zeroGridLineColor: Color? = nil, zeroGridLineStrokeStyle: StrokeStyle? = nil)->DYMultiLineChartView<L> {
        var modView = self as! DYMultiLineChartView<L>
        var yAxisSettings = modView.yAxisSettings
        yAxisSettings.yAxisFontSize = fontSize
        yAxisSettings.showYAxisGridLines = showGridLines
        yAxisSettings.yAxisGridLineColor = gridLineColor
        yAxisSettings.yAxisGridLinesStrokeStyle = gridLineStrokeStyle
        yAxisSettings.yAxisZeroGridLineColor = zeroGridLineColor
        yAxisSettings.yAxisZeroGridLineStrokeStyle = zeroGridLineStrokeStyle
        modView.yAxisSettings = yAxisSettings
        return modView
        
    }
    
    func yAxisScalerOverride(minMax: (min:Double?, max:Double?)? = nil, interval: Double? = nil, maxTicks: Int = 10) ->DYMultiLineChartView<L>  {
            var modView  = self as! DYMultiLineChartView<L>
            modView.yAxisSettings.yAxisMinMaxOverride = minMax
            modView.yAxisSettings.yAxisIntervalOverride = interval
            modView.configureYAxisScaler(min: modView.allDataPoints.map({$0.yValue}).min() ?? 0, max: modView.allDataPoints.map({$0.yValue}).max() ?? 0, maxTicks: maxTicks)
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
