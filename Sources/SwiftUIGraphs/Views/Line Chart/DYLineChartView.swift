//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 18/8/2022.
//

import SwiftUI



public struct DYLineChartView<L>: View, PlotAreaChart, DYMultiLineChartModifiableProperties  where L: View {
   
    public var settings: DYLineChartSettings
    public var yAxisSettings: YAxisSettings
    public var xAxisSettings: XAxisSettings
    var allDataPoints: [DYDataPoint]
    var yAxisScaler: AxisScaler
    var xAxisScaler: AxisScaler
    var xAxisValueAsString: (Double)->String
    var yAxisValueAsString: (Double)->String
    @ViewBuilder var lineViews: (DYLineParentViewProperties)->L
    @State private var touchingXPosition: CGFloat? // User X touch location
    @State private var selectorLineOffset: CGFloat = 0

    
    public init(allDataPoints: [DYDataPoint], @ViewBuilder lineViews: @escaping (DYLineParentViewProperties)->L) {

        self.allDataPoints = allDataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.settings = DYLineChartSettings()
        self.xAxisSettings = DYLineChartXAxisSettings()
        self.yAxisSettings = YAxisSettings()
        self.xAxisValueAsString = {xValue in xValue.toDecimalString(maxFractionDigits: 0)}
        self.yAxisValueAsString = {yValue in yValue.toDecimalString(maxFractionDigits: 0)}
        
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
                         
                                self.yAxisView(yValueAsString: self.yAxisValueAsString)
                                
                            }
                            
                            ZStack {
                                if self.yAxisSettings.showYAxisGridLines  {
                                    self.yAxisGridLinesView()
                                    self.yAxisZeroGridLineView()
                                }
                                
                                if (xAxisSettings as! DYLineChartXAxisSettings).showXAxisGridLines {
                                    self.xAxisGridLines().clipped()
                                }
                                

                                lineViews((yAxisSettings, yAxisScaler, xAxisScaler, $touchingXPosition, $selectorLineOffset))

                                
                                self.selectorLine().clipped()
                                

                                if self.settings.allowUserInteraction {
                                    self.userInteraction()
                                }
                                
                            }.frame(width: self.plotAreaFrameWidth(proxy: geo)).background(settings.plotAreaBackgroundGradient)
                             

                            if self.yAxisSettings.showYAxis && yAxisSettings.yAxisPosition == .trailing {
                         
                                self.yAxisView(yValueAsString: self.yAxisValueAsString, yAxisPosition: .trailing)
                                
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
        if let overrideMin = (xAxisSettings as! DYLineChartXAxisSettings).minMaxOverride?.min, overrideMin <= min {
            min = overrideMin
            didOverrideMin = true
        }

        if let overrideMax = (xAxisSettings as! DYLineChartXAxisSettings).minMaxOverride?.max, overrideMax >= max {
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
    
                   let interval =  (self.xAxisSettings as! DYLineChartXAxisSettings).intervalOverride ?? self.xAxisScaler.tickSpacing ?? 1
                    let xAxisMinMax = self.xAxisMinMax()
                    let convertedXAxisInterval = totalWidth * CGFloat(interval / (xAxisMinMax.max - xAxisMinMax.min))
                    for _ in 0..<count  {
                        p.move(to: CGPoint(x: xPosition, y: 0))
                        p.addLine(to: CGPoint(x:xPosition, y: totalHeight))
                        xPosition += convertedXAxisInterval
                    }
                }.stroke(style: (xAxisSettings as! DYLineChartXAxisSettings).xAxisGridLineStrokeStyle)
                    .foregroundColor((xAxisSettings as! DYLineChartXAxisSettings).xAxisGridLineColor)
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
        let mappedXValue = value.convertToCoordinate(min: minX, max: maxX, length: totalWidth)
        
        return Text(self.xAxisValueAsString(value)).font(.system(size:xAxisSettings.labelFontSize)).position(x: mappedXValue, y: 10)
    }
    
    public func xAxisLabelStrings()->[String] {
        return xAxisValues().map({self.xAxisValueAsString($0)})
       // return self.allDataPoints.map({self.xValueAsString($0.xValue)})
    }
    
  
    
    private func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
        /// NEW
        let interval = (self.xAxisSettings as! DYLineChartXAxisSettings).intervalOverride ?? self.xAxisScaler.tickSpacing ?? 1
        let count = (xAxisMinMax.max - xAxisMinMax.min) / interval
        return Int(count)
    
        
    }
    
    ///NEW
    func xAxisValues()->[Double] {
        
        let intervalOverride = (xAxisSettings as! DYLineChartXAxisSettings).intervalOverride
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
        let intervalOverride =  (xAxisSettings as! DYLineChartXAxisSettings).intervalOverride
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
    

    private func xAxisMinMax()->(min: Double, max: Double){
        return self.xAxisScaler.axisMinMax
    }
   
}


public protocol DYMultiLineChartModifiableProperties where Self: View {
    associatedtype L: View
}

public extension View where Self:  DYMultiLineChartModifiableProperties {
    
    /// background of the plot area
    /// - Parameter gradient: a linear gradient. Default is system background color.
    /// - Returns: modified DYLineChartView
    func background(gradient: LinearGradient)->DYLineChartView<L> {
       var modView = self as! DYLineChartView<L>

        modView.settings.plotAreaBackgroundGradient = gradient
        return modView
        
    }
    
    /// selectorLine: vertical selector line that appear when user touches the plot area.
    /// - Parameters:
    ///   - color: color of the selector line
    ///   - width: width of the selector line
    /// - Returns: modified DYLineChartView
    func selectorLine(color: Color = .red, width: CGFloat = 2)->DYLineChartView<L>   {
        var modView = self  as! DYLineChartView<L>
        modView.settings.selectorLineColor = color
        modView.settings.selectorLineWidth = width
        return modView
        
    }
    
    
    /// userInteraction
    /// - Parameter enabled: if set to true, the user can interact with the chart by swiping horizontally
    /// - Returns: modified DYLineChartView
    func userInteraction(enabled: Bool = true)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        modView.settings.allowUserInteraction = enabled
        return modView
    }

//MARK: x-Axis Settings
        
    /// showXaxis
    /// - Parameter show: determines if the x-axis view should be visible. Default is true.
    /// - Returns: modified DYLineChartView
    func showXaxis(_ show: Bool = true)->DYLineChartView<L>  {
        var modView = self as! DYLineChartView<L>
        modView.xAxisSettings.showXAxis = show
        return modView
    }

    
    /// xAxisViewHeight
    /// - Parameter height: the height of the x-axis view. default is 20.
    /// - Returns: modified DYLineChartView
    func xAxisViewHeight(_ height: CGFloat = 20)->DYLineChartView<L>{
        var modView = self as! DYLineChartView<L>
        modView.xAxisSettings.xAxisViewHeight = height
        return modView
    }

    
    /// xAxisGridLines: vertical grid line settings
    /// - Parameters:
    ///   - showGridLines: show the vertical grid lines
    ///   - gridLineColor: vertical grid line color
    ///   - gridLineStrokeStyle: vertical grid line stroke style
    /// - Returns: modified DYLineChartView
    func xAxisGridLines(showGridLines: Bool = true, gridLineColor: Color = Color.secondary.opacity(0.5), gridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]))->DYLineChartView<L>{
        var modView = self  as! DYLineChartView<L>
        var xAxisSettings = modView.xAxisSettings as! DYLineChartXAxisSettings
        xAxisSettings.showXAxisGridLines = showGridLines
        xAxisSettings.xAxisGridLineColor = gridLineColor
        xAxisSettings.xAxisGridLineStrokeStyle = gridLineStrokeStyle
        modView.xAxisSettings = xAxisSettings
        return modView
        
    }
    
    /// xAxisStringValue
    /// - Parameter stringValue: a closure to format x-Axis label strings depending on the number value. Default is a format as integer string (no fraction digits)
    /// - Returns: modified DYLineChartView
    func xAxisStringValue(_ stringValue: @escaping (Double)->String)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        modView.xAxisValueAsString = stringValue
        return modView
    }
    
    
    /// xAxisLabelFontSize
    /// - Parameter fontSize: font size of the x-axis tick labels. default is 8.
    /// - Returns: modified  DYLineChartView
    func xAxisLabelFontSize(_ fontSize: CGFloat)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        modView.xAxisSettings.labelFontSize = fontSize
        return modView
    }
    
    /// xAxisScalerOverride
    /// - Parameters:
    ///   - minMax: min and max value of the x-axis. if the min value is > than the smallest x-value of the DYDataPoints, the min override is ignored. Similarly, the max value is ignored if it is < than the largest x-value among the data points.
    ///   - interval: override the tick interval on the x-axis.
    ///   - maxTicks: maximum number of ticks on the x-axis. Default is 20.
    /// - Returns: modified DYLineChartView
    func xAxisScalerOverride(minMax: (min:Double?, max:Double?)? = nil, interval: Double? = nil, maxTicks: Int = 20) ->DYLineChartView<L> {
            var modView = self as! DYLineChartView<L>
            var xAxisSettings = modView.xAxisSettings as! DYLineChartXAxisSettings
            xAxisSettings.minMaxOverride = minMax
            xAxisSettings.intervalOverride = interval
            modView.xAxisSettings = xAxisSettings
            modView.configureXAxisScaler(min: modView.allDataPoints.map({$0.xValue}).min() ?? 0, max: modView.allDataPoints.map({$0.xValue}).max() ?? 0, maxTicks: maxTicks)
            return modView
    
    }
    
//MARK: y-Axis Settings
    
    
    /// showYaxis
    /// - Parameter show:  determines if the y-axis view should be visible. Default is true.
    /// - Returns: modified DYLineChartView
    func showYaxis(_ show: Bool = true)->DYLineChartView<L>{
        var modView = self as! DYLineChartView<L>
        modView.yAxisSettings.showYAxis = show
        return modView
    }
    //
    /// yAxisPosition
    /// - Parameter position: .leading or .trailing.
    /// - Returns: modified DYLineChartView
    func yAxisPosition(_ position: Edge.Set = .leading)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        modView.yAxisSettings.yAxisPosition = position
        return modView
    }

    
    /// yAxisViewWidth
    /// - Parameter width: the width of the y-axis view. default is 35.
    /// - Returns:  modified DYLineChartView
    func yAxisViewWidth(_ width: CGFloat = 35)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        modView.yAxisSettings.yAxisViewWidth = width
        return modView
    }

    
    /// yAxisGridLines settings
    /// - Parameters:
    ///   - showGridLines: show the horizontal grid lines
    ///   - gridLineColor: horizontal grid line color
    ///   - gridLineStrokeStyle: vertical grid line stroke style
    ///   - zeroGridLineColor: color of the 0-grid line. default nil: no separate zero grid line
    ///   - zeroGridLineStrokeStyle: stroke style of the 0-grid line. default nil.
    /// - Returns: modified DYLineChartView
    func yAxisGridLines(showGridLines: Bool = true, gridLineColor: Color = Color.secondary.opacity(0.5), gridLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 1, dash: [3]), zeroGridLineColor: Color? = nil, zeroGridLineStrokeStyle: StrokeStyle? = nil)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        var yAxisSettings = modView.yAxisSettings
        yAxisSettings.showYAxisGridLines = showGridLines
        yAxisSettings.yAxisGridLineColor = gridLineColor
        yAxisSettings.yAxisGridLinesStrokeStyle = gridLineStrokeStyle
        yAxisSettings.yAxisZeroGridLineColor = zeroGridLineColor
        yAxisSettings.yAxisZeroGridLineStrokeStyle = zeroGridLineStrokeStyle
        modView.yAxisSettings = yAxisSettings
        return modView
        
    }
    
    /// yAxisStringValue
    /// - Parameter stringValue: a closure to format y-Axis label strings depending on the number value. Default is a format as integer string (no fraction digits)
    /// - Returns: modified DYLineChartView
    func yAxisStringValue(_ stringValue: @escaping (Double)->String)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        modView.yAxisValueAsString = stringValue
        return modView
    }
    
    
    /// yAxisLabelFontSize
    /// - Parameter fontSize: font size of the y-axis labels. default size is 8
    /// - Returns: modified  DYLineChartView
    func yAxisLabelFontSize(_ size: CGFloat)->DYLineChartView<L> {
        var modView = self as! DYLineChartView<L>
        modView.yAxisSettings.yAxisFontSize = size
        return modView
        
    }
    
    
    /// yAxisScalerOverride
    /// - Parameters:
    ///   - minMax: min and max value of the y-axis. if the min value is >= than the smallest y-value of the data points, the min override is ignored. Similarly, the max value is ignored if it is <= than the largest y-value among the data points.
    ///   - interval: override the tick interval on the x-axis.
    ///   - maxTicks: maximum number of ticks on the y-axis. Default is 10.
    /// - Returns: modified DYLineChartView
    func yAxisScalerOverride(minMax: (min:Double?, max:Double?)? = nil, interval: Double? = nil, maxTicks: Int = 10) ->DYLineChartView<L>  {
            var modView  = self as! DYLineChartView<L>
            modView.yAxisSettings.yAxisMinMaxOverride = minMax
            modView.yAxisSettings.yAxisIntervalOverride = interval
            modView.configureYAxisScaler(min: modView.allDataPoints.map({$0.yValue}).min() ?? 0, max: modView.allDataPoints.map({$0.yValue}).max() ?? 0, maxTicks: maxTicks)
            return modView
    
    }

    
}


//struct DYMultiLineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        DYMultiLineChartView()
//    }
//}
