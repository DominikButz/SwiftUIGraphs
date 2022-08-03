//
//  DYLineChartView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI

/// DYLineChartView
public struct DYLineChartView: View, DYGridChart {

    var dataPoints: [DYDataPoint]

   @State private var convertedXValues: [CGFloat]  = []
    
    @Binding var selectedIndex: Int
    
    @State private var lineOffset: CGFloat = 0 // Vertical line offset
    @State private var selectedYPos: CGFloat = 0 // User Y touch location
    @State private var isSelected: Bool = false // Is the user touching the graph
    @State private var lineEnd: CGFloat = 0 // for line animation
    @State private var showLineSegments: Bool = false
    @State private var showWithAnimation: Bool = false

    var chartFrameHeight: CGFloat?
    var labelView:((DYDataPoint)->AnyView?)?
    var settings: DYGridChartSettings
    
    var yAxisScaler: YAxisScaler
    var xValueConverter:  (Double)->String
    var yValueConverter: (Double)->String
    var diameterPerPoint: ((DYDataPoint)->CGFloat)?
    var strokeStylePerPoint: ((DYDataPoint)->StrokeStyle)?
    var colorPerPoint: ((DYDataPoint)->Color)?
    var colorPerLineSegment: ((DYDataPoint)->Color)?
    var backgroundColorPerPoint: ((DYDataPoint)->Color)?
    var marginSum: CGFloat {
        return settings.lateralPadding.leading + settings.lateralPadding.trailing
    }
    

    
    /// DYLineChartView initializer
    /// - Parameters:
    ///   - dataPoints: an array of DYDataPoints.
    ///   - selectedIndex: the index of the selected data point.
    ///   - labelView: A custom view that should appear above the respective point. Default value is nil.
    ///   - xValueConverter: Implement a logic in this closure that format the x-value as string.
    ///   - yValueConverter: Implement a logic in this closure that format the y-value as string.
    ///   - diameterPerPoint: overrides the point diameter property in the DYLineChartSettings. Default value is nil (no override).
    ///   - strokeStylePerPoint: overrides the point stroke style property in the DYLineChartSettings. Default value is nil (no override).
    ///   - colorPerPoint: overrides the point (stroke) color property in the DYLineChartSettings. Default value is nil (no override).
    ///   - backgroundColorPerPoint: overrides the background point color property in the DYLineChartSettings. Default value is nil (no override).
    ///   - colorPerLineSegment: sets the line color for each line segment between two points, thus overriding the lineColor property in DYLineChartSettings. Default value is nil.
    ///   - chartFrameHeight: the height of the chart (including x-axis, if applicable). If an the x-axis view is present, it is recommended to set this value, otherwise the height might be unpredictable.
    ///   - settings: DYLineChartSettings
    public init(dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, xValueConverter: @escaping (Double)->String, labelView: ((DYDataPoint)->AnyView?)? = nil, yValueConverter: @escaping (Double)->String, diameterPerPoint: ((DYDataPoint)->CGFloat)? = nil, strokeStylePerPoint: ((DYDataPoint)->StrokeStyle)? = nil, colorPerPoint:((DYDataPoint)->Color)? = nil, backgroundColorPerPoint:((DYDataPoint)->Color)? = nil, colorPerLineSegment: ((DYDataPoint)->Color)? = nil,  chartFrameHeight:CGFloat? = nil, settings: DYLineChartSettings = DYLineChartSettings()) {
        self._selectedIndex = selectedIndex
        // sort the data points according to x values
        let sortedData = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.dataPoints = sortedData
        self.xValueConverter = xValueConverter
        self.yValueConverter = yValueConverter
        self.diameterPerPoint = diameterPerPoint
        self.strokeStylePerPoint = strokeStylePerPoint
        self.colorPerPoint = colorPerPoint
        self.backgroundColorPerPoint = backgroundColorPerPoint
        self.colorPerLineSegment = colorPerLineSegment
        self.chartFrameHeight = chartFrameHeight
        self.labelView = labelView
        self.settings = settings
        
        var min =  dataPoints.map({$0.yValue}).min() ?? 0
        if let overrideMin = settings.yAxisSettings.yAxisMinMaxOverride?.min, overrideMin < min {
            min = overrideMin
        }
         var max = self.dataPoints.map({$0.yValue}).max() ?? 0
        if let overrideMax = settings.yAxisSettings.yAxisMinMaxOverride?.max, overrideMax > max {
            max = overrideMax
        }
         self.yAxisScaler = YAxisScaler(min:min, max: max, maxTicks: 10)
    }
    
    

    public var body: some View {
        GeometryReader { geo in
            Group {
                if self.dataPoints.count >= 2 {
                    VStack(spacing: 0) {
                        HStack(spacing:0) {
                            if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading {
                                self.yAxisView(geo: geo).padding(.trailing, 5).frame(width:settings.yAxisSettings.yAxisViewWidth)
                            }
                            ZStack {
                                
                                if self.settings.yAxisSettings.showYAxisGridLines {
                                    self.yAxisGridLines().opacity(0.5)
                                }
                                if ((self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).showXAxisGridLines {
                                    self.xAxisGridLines().opacity(0.5)
                                }
                                
                                if (self.settings.xAxisSettings as! DYLineChartXAxisSettings).showXAxisDataPointLines {
                                    self.dataPointMarkerLines(isXAxis: true)
                                }
                                
                                if self.settings.yAxisSettings.showYAxisDataPointLines {
                                    self.dataPointMarkerLines(isXAxis: false)
                                }
                                
                                if self.showWithAnimation {
                                    self.selectedDataPointAxisLines()  // horizontal and/ or vertical line emanating from selected marker point
                                        .transition(AnyTransition.opacity.animation(Animation.easeIn(duration: 0.8)))
                                }
                                
                                
                                if let _ = self.colorPerLineSegment {
                                  self.lineSegments()
                                } else {
                                    self.line()
                                }
                              
                                
                                if self.showWithAnimation {
                                    Group {
                                        if (self.settings as! DYLineChartSettings).showGradient {
                                            self.gradient()
                                        }
                                        if (self.settings as! DYLineChartSettings).showPointMarkers {
                                            self.points()
                                        }
                                        self.pointLabelViews()
                                        self.addUserInteraction()
                                    }.transition(AnyTransition.opacity.animation(Animation.easeIn(duration: 0.8)))
                                
                                }
                                
                            }.background(settings.chartViewBackgroundColor)
                            
                            
                            if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing {
                                self.yAxisView(geo: geo).padding(.leading, 5).frame(width:settings.yAxisSettings.yAxisViewWidth)
                            }
                        }.frame(height: chartFrameHeight)
                        
                        if (self.settings as! DYLineChartSettings).xAxisSettings.showXAxis {
                            self.xAxisView()
                        }
                    }
                    //.transition(AnyTransition.opacity)
                    .onAppear {
                     
                        withAnimation(.easeIn(duration: (self.settings as! DYLineChartSettings).lineAnimationDuration)) {
                            self.lineEnd = 1
                            self.showLineSegments = true
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + (self.settings as! DYLineChartSettings).lineAnimationDuration) {
                            self.showWithAnimation = true
                        }
                    }
                            
                } else {
                    // placeholder grid in case not enough data is available
                    self.placeholderGrid(xAxisLineCount: 12, yAxisLineCount: 10).frame(height: self.chartFrameHeight).opacity(0.5).padding()
                }
            }
       

        }
        
    }
    
    //MARK: Sub-Views
    


    private func xAxisView()-> some View {

        ZStack(alignment: .center) {
            GeometryReader { geo in
                let labelSteps = self.xAxisLabelSteps(totalWidth: geo.size.width - marginSum)
                ForEach(self.xAxisValues(), id:\.self) { value in
                    let i = self.xAxisValues().firstIndex(of: value) ?? 0
                    if  i % labelSteps == 0 {
                        self.xAxisIntervalLabelViewFor(value: value, totalWidth: geo.size.width - marginSum)
                    }
                }
            }

        }
        .padding(.leading, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading ?  settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.leading, settings.lateralPadding.leading )
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.trailing, settings.lateralPadding.trailing)

    }
//
    

    
    private func xAxisIntervalLabelViewFor(value:Double, totalWidth: CGFloat)-> some View {
        Text(self.xValueConverter(value)).font(.system(size:(settings as! DYLineChartSettings).xAxisSettings.xAxisFontSize)).position(x: self.convertToXCoordinate(value: value, width: totalWidth), y: 10)
    }
//
//
    
    private func dataPointMarkerLines(isXAxis: Bool)->some View {
        let xAxisSettings = ((self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings)
        let yAxisSettings = (self.settings as! DYLineChartSettings).yAxisSettings
        
        let strokeStyle = isXAxis ? xAxisSettings.xAxisDataPointLinesStrokeStyle : yAxisSettings.yAxisDataPointLinesStrokeStyle
        let color = isXAxis ? xAxisSettings.xAxisDataPointLinesColor : yAxisSettings.yAxisDataPointLinesColor
        
        return GeometryReader { geo in
            let totalHeight = geo.size.height
            let totalWidth = geo.size.width - marginSum
            
                Path { p in
                    for point in self.dataPoints {
                        let xPosition = self.convertToXCoordinate(value: point.xValue, width: totalWidth)
                        let yPosition = totalHeight - self.convertToYCoordinate(value: point.yValue, height: totalHeight)
                        p.move(to: CGPoint(x: xPosition, y: yPosition))
                        if isXAxis {
                            p.addLine(to: CGPoint(x: xPosition, y: totalHeight))
                        } else {
                            let xValue  = self.settings.yAxisSettings.yAxisPosition == .trailing ? totalWidth : self.settings.lateralPadding.leading
                            p.addLine(to: CGPoint(x: xValue, y: yPosition))
                        }
                    }

                }.stroke(style: strokeStyle)
                    .foregroundColor(color)

        }
    }
    

    
    private func xAxisGridLines()-> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Path { p in
                    let totalWidth = geo.size.width - marginSum
                    let totalHeight = geo.size.height
                    var xPosition: CGFloat = self.settings.lateralPadding.leading
                    let count = self.xAxisLineCount()
                    let interval:Double = ((self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisInterval
                    let xAxisMinMax = self.xAxisMinMax()
                    let convertedXAxisInterval = totalWidth * CGFloat(interval / (xAxisMinMax.max - xAxisMinMax.min))
                    for _ in 0..<count + 1 {
                        p.move(to: CGPoint(x: xPosition, y: 0))
                        p.addLine(to: CGPoint(x:xPosition, y: totalHeight))
                        xPosition += convertedXAxisInterval
                    }
                }.stroke(style: ((self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisLineStrokeStyle)
                .foregroundColor(.secondary)
            }


        }
    }
    
    private func line()->some View {
      GeometryReader { geo in
        Group {
            if self.dataPoints.count >= 2 {
                self.pathFor(width: geo.size.width - marginSum, height: geo.size.height, closeShape: false)
                    .trim(from: 0, to: self.lineEnd)
                    .stroke(style: (self.settings as! DYLineChartSettings).lineStrokeStyle)
                    .foregroundColor((self.settings as! DYLineChartSettings).lineColor)
            }
        }
      }
 
    }
    
    // for separate
    private func lineSegments()-> some View {
        GeometryReader { geo in
            
            Group {
                if self.dataPoints.count >= 2 {
                    ForEach(0..<dataPoints.count, id: \.self) { index in
                        
                        Path { path in
                            path =  self.drawPathWith(path: &path, index: index, height: geo.size.height, width: geo.size.width)
                            
                        }
                        .stroke(style: (self.settings as! DYLineChartSettings).lineStrokeStyle)
                        .foregroundColor(self.colorPerLineSegment!(dataPoints[index]))
                        
                        
                    }.mask(lineAnimationMaskingView(width:geo.size.width))
                    
                }
            }
            
        }
        
    }
    
    /// for line drawing animation if line composed of several paths in separate colours
    private func lineAnimationMaskingView(width: CGFloat)->some View {
        HStack {
            Rectangle().fill(Color.white.opacity(0.5)).frame(width: self.showLineSegments ? width : 0, alignment: .trailing)
            Spacer()
        }
    }
    
    private func gradient() -> some View {
        settings.gradient
            .padding(.bottom, 1)
            .opacity(0.7)
            .mask(
               GeometryReader { geo in
                    if self.dataPoints.count >= 2 {
                        self.pathFor(width: geo.size.width - marginSum, height: geo.size.height, closeShape: true)
                    }
                }
            )
    }
    
    func pathFor(width: CGFloat, height: CGFloat, closeShape: Bool)->Path {
        Path { path in

           path  = self.drawCompletePathWith(path: &path, height: height, width: width)

            // Finally close the subpath off by looping around to the beginning point.
            if closeShape {
                path.addLine(to: CGPoint(x: settings.lateralPadding.leading + width, y: height))
                path.addLine(to: CGPoint(x: settings.lateralPadding.leading, y: height))
                path.closeSubpath()
            }
        }
    }
    
    ///
    func drawPathWith(path: inout Path, index: Int, height: CGFloat, width: CGFloat) -> Path {
        
            let mappedYValue0 = self.convertToYCoordinate(value: dataPoints[index].yValue, height: height)
            let mappedXValue0 = self.convertToXCoordinate(value: dataPoints[index].xValue, width: width)
            let point0 = CGPoint(x: settings.lateralPadding.leading + mappedXValue0, y: height - mappedYValue0)
            path.move(to: point0)
            if index < self.dataPoints.count - 1 {
                let nextIndex = index + 1
                
                _ = self.connectPointsWith(path: &path, index: nextIndex, point0: point0, height: height, width: width)

            }

        return path
        
    }
    
    func drawCompletePathWith(path: inout Path, height: CGFloat, width: CGFloat)->Path {
        
        guard let firstYValue = dataPoints.first?.yValue else {return path}
        
        var point0 = CGPoint(x: settings.lateralPadding.leading, y: height - self.convertToYCoordinate(value: firstYValue, height: height))
        path.move(to: point0)
        var index:Int = 0
        
        for _ in dataPoints {
            if index != 0 {

                point0 = self.connectPointsWith(path: &path, index: index, point0: point0, height: height, width: width)
             
            }
            index += 1
            
        }
        
        return path
        
    }
    
    private func connectPointsWith(path: inout Path, index: Int, point0: CGPoint, height: CGFloat, width: CGFloat)->CGPoint {

        let mappedYValue = self.convertToYCoordinate(value: dataPoints[index].yValue, height: height)
        let mappedXValue = self.convertToXCoordinate(value: dataPoints[index].xValue, width: width)
        let point1 = CGPoint(x: settings.lateralPadding.leading + mappedXValue, y: height - mappedYValue)
        if (self.settings as! DYLineChartSettings).interpolationType == .quadCurve {
            let midPoint = CGPoint.midPointForPoints(p1: point0, p2: point1)
            path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point0))
            path.addQuadCurve(to: point1, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point1))
        }
        path.addLine(to: point1)
        return point1
    }
    
    private func points()->some View {
      GeometryReader { geo in

         //   let yScale = self.yScaleFor(height: geo.size.height)
            let height = geo.size.height
            let width = geo.size.width - marginSum
           ForEach(dataPoints) { dataPoint in
                Circle()
                    .stroke(style: strokeStylePerPoint?(dataPoint) ?? (self.settings as! DYLineChartSettings).pointStrokeStyle)
                    .frame(width: diameterPerPoint?(dataPoint) ?? (self.settings as! DYLineChartSettings).pointDiameter, height: diameterPerPoint?(dataPoint) ?? (self.settings as! DYLineChartSettings).pointDiameter, alignment: .center)
                    .foregroundColor(colorPerPoint?(dataPoint) ?? (self.settings as! DYLineChartSettings).pointColor)
                    .background(backgroundColorPerPoint?(dataPoint) ?? (self.settings as! DYLineChartSettings).pointBackgroundColor)
                    .cornerRadius(5)
                    .offset(x: settings.lateralPadding.leading + self.convertToXCoordinate(value: dataPoint.xValue, width: width) - 5, y: (height - self.convertToYCoordinate(value: dataPoint.yValue, height: height)) - 5)
            }
       }
        
    }
    
    private func pointLabelViews()-> some View {
        GeometryReader { geo in
            
            let height = geo.size.height
            let width = geo.size.width - marginSum
            ForEach(dataPoints) { dataPoint in
                
                self.labelView?(dataPoint)
                    .position(x: settings.lateralPadding.leading + self.convertToXCoordinate(value: dataPoint.xValue, width: width), y: (height - self.convertToYCoordinate(value: dataPoint.yValue, height: height)))
                    .offset(x: self.settings.labelViewDefaultOffset.width, y:  self.settings.labelViewDefaultOffset.height)
           
                
            }
        }
        
    }
    
    // selection point x and y axis marker lines
    private func selectedDataPointAxisLines()-> some View {
        
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width - marginSum
            let selectedDataPoint = self.dataPoints[self.selectedIndex]
            let xValue = self.convertToXCoordinate(value: selectedDataPoint.xValue, width: width)
            let yValue = height - self.convertToYCoordinate(value: selectedDataPoint.yValue, height: height)
            
            if (( self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).showXAxisSelectedDataPointLine {
                Path { p in  // vertical from selected point to x-axis
                    p.move(to: CGPoint(x: xValue, y: yValue))
                    p.addLine(to: CGPoint(x: xValue, y: height))
                }.stroke(style:(( self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisSelectedDataPointLineStrokeStyle)
                    .foregroundColor( (( self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisSelectedDataPointLineColor)
                    .opacity(isSelected ? 0 : 1)
            }
            
            if self.settings.yAxisSettings.showYAxisSelectedDataPointLine {
                Path { p in  // horizontal from selected point to y-axis
                    p.move(to: CGPoint(x: xValue, y: yValue))
                    let xCoordinate = self.settings.yAxisSettings.yAxisPosition  == .trailing ? width : self.settings.lateralPadding.leading
                    p.addLine(to: CGPoint(x: xCoordinate, y: yValue))
                }.stroke(style:self.settings.yAxisSettings.yAxisSelectedDataPointLineStrokeStyle)
                    .foregroundColor(self.settings.yAxisSettings.yAxisSelectedDataPointLineColor)
                    .opacity(isSelected ? 0 : 1)
            }
        }
        
    }
    
    
    private func addUserInteraction() -> some View {
      GeometryReader { geo in

            let height = geo.size.height
            let width = geo.size.width - marginSum
        //    let yScale = self.yScaleFor(height: geo.size.height)

            ZStack(alignment: .leading) {
                
                (self.settings as! DYLineChartSettings).selectorLineColor
                                .frame(width: 2)
                                .opacity(self.isSelected ? 1 : 0) // hide the vertical indicator line if user not touching the chart
                                .overlay(
                                    Circle()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .foregroundColor((self.settings as! DYLineChartSettings).selectorLinePointColor)
                                        .opacity(0.2)
                                        .overlay(
                                            Circle()
                                                .fill()
                                                .frame(width: (self.settings as! DYLineChartSettings).selectorLinePointDiameter, height: (self.settings as! DYLineChartSettings).selectorLinePointDiameter, alignment: .center)
                                                .foregroundColor((self.settings as! DYLineChartSettings).selectorLinePointColor)
                                        )
                                        //CGFloat(self.dataPoints.count) - self.convertToYCoordinate(value: Double(selectedYPos), height: height)
                     //+ CGFloat(self.dataPoints.count)
                                        .offset(x: 0, y: isSelected ? selectedYPos - height + (self.settings as! DYLineChartSettings).selectorLinePointDiameter :  (self.settings as! DYLineChartSettings).selectorLinePointDiameter - self.convertToYCoordinate(value: dataPoints[selectedIndex].yValue, height: height))
                                    , alignment: .bottom)
                    .offset(x: isSelected ? lineOffset : settings.lateralPadding.leading + self.convertToXCoordinate(value: dataPoints[selectedIndex].xValue, width: width), y: 0)
                                .animation(Animation.spring().speed(4))
                
//                // selection point x and y axis marker lines
//
//                let selectedDataPoint = self.dataPoints[self.selectedIndex]
//                let xValue = self.convertToXCoordinate(value: selectedDataPoint.xValue, width: width)
//                let yValue = height - self.convertToYCoordinate(value: selectedDataPoint.yValue, height: height)
//
//                if (( self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).showXAxisSelectedDataPointLine {
//                    Path { p in  // vertical from selected point to x-axis
//                        p.move(to: CGPoint(x: xValue, y: yValue))
//                        p.addLine(to: CGPoint(x: xValue, y: height))
//                    }.stroke(style:(( self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisSelectedDataPointLineStrokeStyle)
//                        .foregroundColor( (( self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisSelectedDataPointLineColor)
//                        .opacity(isSelected ? 0 : 1)
//                }
//
//                if self.settings.yAxisSettings.showYAxisSelectedDataPointLine {
//                    Path { p in  // horizontal from selected point to y-axis
//                        p.move(to: CGPoint(x: xValue, y: yValue))
//                        let xCoordinate = self.settings.yAxisSettings.yAxisPosition  == .trailing ? width : self.settings.lateralPadding.leading
//                        p.addLine(to: CGPoint(x: xCoordinate, y: yValue))
//                    }.stroke(style:self.settings.yAxisSettings.yAxisSelectedDataPointLineStrokeStyle)
//                        .foregroundColor(self.settings.yAxisSettings.yAxisSelectedDataPointLineColor)
//                        .opacity(isSelected ? 0 : 1)
//                }
                
                
                
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
            }.onAppear {
                self.lineOffset = self.settings.lateralPadding.leading
            }

         }
    }
    
    //MARK: Helper functions
    
    private func dragOnChanged(value: DragGesture.Value, geo: GeometryProxy) {
        let xPos = value.location.x

        self.isSelected = true
        
        let path = self.pathFor(width: geo.size.width - marginSum, height: geo.size.height, closeShape: false)
        let pointY = path.point(to: xPos).y

       self.selectedYPos = pointY

        let index = self.fractionIndexFor(xPosition: xPos - settings.lateralPadding.leading, geo: geo)
//   //  / (((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)))
//        if index > 0 && index < CGFloat(self.dataPoints.count - 1) {
//            let m = (dataPoints[Int(index) + 1].yValue - dataPoints[Int(index)].yValue)
//            self.selectedYPos = CGFloat(m) * index.truncatingRemainder(dividingBy: 1) + CGFloat(dataPoints[Int(index)].yValue)
//         //   CGFloat(m) * index.truncatingRemainder(dividingBy: 1)
//
//        }

        if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < CGFloat(self.dataPoints.count  - 1) {
            self.selectedIndex = Int(index) + 1
        } else {
            self.selectedIndex = Int(index)
        }
      //  self.selectedXPos = min(max(leadingMargin, xPos), geo.size.width - leadingMargin)
        self.lineOffset = min(max(settings.lateralPadding.leading, xPos), geo.size.width - settings.lateralPadding.leading)
        
    }
    
    private func dragOnEnded(value: DragGesture.Value, geo: GeometryProxy) {
        let xPos = value.location.x
        self.isSelected = false
      //  let index = (xPos - leadingMargin) / (((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)))
        let index = self.fractionIndexFor(xPosition: xPos - settings.lateralPadding.leading, geo: geo)
        
        if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < CGFloat(self.dataPoints.count - 1) {
            self.selectedIndex = Int(index) + 1
        } else {
            self.selectedIndex = Int(index)
        }
    }
    
    private func fractionIndexFor(xPosition: CGFloat, geo: GeometryProxy)->CGFloat {
        self.convertedXValues = self.dataPoints.map({convertToXCoordinate(value: $0.xValue, width: geo.size.width - marginSum)})
        for i in 0..<self.convertedXValues.count {
            let currentValue = self.convertedXValues[i]
            let lastValue = i > 0 ? self.convertedXValues[i - 1] : nil
            if xPosition == currentValue {
                return CGFloat(i)
            } else if let lastValue = lastValue, xPosition < currentValue, xPosition > lastValue {
                let normalizedFraction = self.normalizationFactor(value: Double(xPosition), maxValue: Double(currentValue), minValue: Double(lastValue))
                 return CGFloat(i - 1) + CGFloat(normalizedFraction)
            }
        }

        
        return 0
    }
    
    internal func xAxisMinMax()->(min: Double, max: Double){
        let xValues = dataPoints.map({$0.xValue})
        return (min: xValues.min() ?? 0, max: xValues.max() ?? 0)
    }
    
//    private func yAxisMinMax()->(min: Double, max: Double){
//        let scaledMin = self.settings.yAxisSettings.yAxisMinMaxOverride?.min ?? self.yAxisScaler.scaledMin ?? 0
//        let scaledMax = self.settings.yAxisSettings.yAxisMinMaxOverride?.max ?? self.yAxisScaler.scaledMax ?? 1
//
//        return (min: scaledMin, max: scaledMax)
//        /////////
////        if let yAxisMinMax = settings.yAxisMinMax {
////            return yAxisMinMax
////        }
////
////        let yValues = dataPoints.map({$0.yValue})
////
////        let maxY = yValues.max() ?? 0
////        let minY = yValues.min() ?? 0
////
////        return (min: minY, max: maxY)
//
//    }
    
    
//    internal func yAxisValueCount()->Int {
//     //   print("y axis lines \(self.yAxisScaler.scaledValues().count)")
//        guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
//            return self.yAxisScaler.scaledValues().count
//        }
//        let yAxisMinMax = self.yAxisMinMax()
//        let yAxisInterval = interval
//        let count = (yAxisMinMax.max - yAxisMinMax.min) / yAxisInterval
//     //   print("line count \(count + 1)")
//        return Int(count) + 1
//    }
    
    internal func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
   
        let count = (xAxisMinMax.max - xAxisMinMax.min) / ((self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisInterval
        
        return Int(count)
    
        
    }
    

    internal func xAxisValues()->[Double] {
        var values:[Double] = []
        let count = self.xAxisLineCount()
        var currentValue = self.xAxisMinMax().min
        for _ in 0..<(count + 1) {
            values.append(currentValue)
            currentValue += ((self.settings as! DYLineChartSettings).xAxisSettings as! DYLineChartXAxisSettings).xAxisInterval
            
        }
        return values
    }
    
//    internal func yAxisValues()->[Double] {
//
//        guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
//            return self.yAxisScaler.scaledValues().reversed()
//        }
//        var values:[Double] = []
//        let count = self.yAxisValueCount()
//        let yAxisInterval = interval
//        var currentValue  = self.yAxisMinMax().max
//      //  print("value count :\(count)")
//        for _ in 0..<(count) {
//            values.append(currentValue)
//            currentValue -= yAxisInterval
//        }
//        return values
//
//    }
    

    
    private func convertToXCoordinate(value: Double, width: CGFloat)->CGFloat {
        let xValues = dataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        
        return width * CGFloat(normalizationFactor(value: value, maxValue: maxX, minValue: minX))

    }

    
//    private func  yScaleFor(height: CGFloat)->CGFloat {
//
//        let yValues = dataPoints.map({$0.yValue})
//
//
//        let maxY = yValues.reduce(0) { (res, value) -> Double in
//            return max(res, value)
//        }
//        let maxYRoundedUp = maxY.rounded(digits: 2, roundingRule: .up)
//      // print("max y rounded up \(maxYRoundedUp)")
//        let minY = yValues.reduce(0, {(res, value)->Double in
//           return min(res, value)
//       })
//
//        let minYRoundedDown = minY.rounded(digits: 2, roundingRule: .down)
//     //   print("min y rounded down: \(minYRoundedDown)")
//       let maxMinDiff = maxYRoundedUp - minYRoundedDown
//       // print("min Max Diff \(maxMinDiff)")
//        let yScale = height / CGFloat(maxMinDiff)
////        print("yScale \(yScale)")
////        print("height: \(height)")
//       return  yScale
//
//    }
    
  
    
    
}

//struct DYLineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        GeometryReader { proxy in
//            DYLineChartView(dataPoints: DYDataPoint.exampleData, selectedIndex: .constant(0)).frame(maxHeight: proxy.size.height / 3)
//        }
//    }
//}
