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
    var plotAreaHeight: CGFloat?
    var yAxisScaler: YAxisScaler
    var xValueAsString: (Double)->String
    var yValueAsString: (Double)->String
    
    @State private var userTouchingChart: Bool = false
    
    public init?(lineDataSets: [DYLineDataSet], plotAreaSettings: DYPlotAreaSettings = DYPlotAreaSettings(), plotAreaHeight: CGFloat? = nil, xValueAsString: @escaping (Double)->String , yValueAsString:  @escaping (Double)->String) {
        if lineDataSets.isEmpty {
            assertionFailure("You need to add at least one line data set")
            return nil
        }
        self.lineDataSets = lineDataSets
        self.settings = plotAreaSettings
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
                                    self.yAxisGridLines().opacity(0.5)
                                }
                                if settings.xAxisSettings.showXAxisGridLines {
                                    self.xAxisGridLines().opacity(0.5)
                                }
                                
                                ForEach(self.lineDataSets) { dataSet in
                                    DYLineView(lineDataSet: dataSet, yAxisSettings: self.settings.yAxisSettings, yAxisScaler: self.yAxisScaler)
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
                }.stroke(style: self.settings.xAxisSettings.xAxisLineStrokeStyle)
                .foregroundColor(.secondary)
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


internal struct DYLineView: View, DataPointConversion {

    var lineDataSet: DYLineDataSet
    var yAxisSettings: YAxisSettingsNew
    var yAxisScaler: YAxisScaler
    
    @State private var lineEnd: CGFloat = 0 // for line animation
    
    var body: some View {
        
        ZStack {
            self.line()
            
        }.onAppear {
            self.showLine()
        }
    }
    
    private func showLine() {

        guard self.lineDataSet.settings.showAppearAnimation  else {
            return
            
        }
        
        withAnimation(.easeIn(duration: self.lineDataSet.settings.lineAnimationDuration)) {
            self.lineEnd = 1
           // self.showLineSegments = true // for different color line segments
        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + (self.lineDataSet.settings.lineAnimationDuration) {
//            withAnimation(.easeIn) {
//                self.showSupplementaryViews = true
//            }
//        }
    }
    
    private func line()->some View {
      GeometryReader { geo in
        Group {
            if self.lineDataSet.dataPoints.count >= 2 {
                self.pathFor(width: geo.size.width, height: geo.size.height, closeShape: false)
                    .trim(from: 0, to: self.lineDataSet.settings.showAppearAnimation ? self.lineEnd : 1)
                    .stroke(style: self.lineDataSet.settings.lineStrokeStyle)
                    .foregroundColor(self.lineDataSet.settings.lineColor)
                    .shadow(color: self.lineDataSet.settings.lineDropShadow?.color ?? .clear, radius: self.lineDataSet.settings.lineDropShadow?.radius ?? 0, x:  self.lineDataSet.settings.lineDropShadow?.x ?? 0, y:  self.lineDataSet.settings.lineDropShadow?.y ?? 0)
            }
        }
      }
 
    }
    
    func pathFor(width: CGFloat, height: CGFloat, closeShape: Bool)->Path {
        Path { path in

           path  = self.drawCompletePathWith(path: &path, height: height, width: width)

            // Finally close the subpath off by looping around to the beginning point.
            if closeShape {
                path.addLine(to: CGPoint(x: width, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.closeSubpath()
            }
        }
    }
    
    func drawCompletePathWith(path: inout Path, height: CGFloat, width: CGFloat)->Path {
        
        guard let firstYValue = lineDataSet.dataPoints.first?.yValue else {return path}
        
        var point0 = CGPoint(x: 0, y: height - self.convertToCoordinate(value: firstYValue, min: self.yAxisMinMax(settings: self.yAxisSettings).min, max: self.yAxisMinMax(settings: self.yAxisSettings).max, length: height))
        path.move(to: point0)
        var index:Int = 0
        
        for _ in lineDataSet.dataPoints {
            if index != 0 {

                point0 = self.connectPointsWith(path: &path, index: index, point0: point0, height: height, width: width)
             
            }
            index += 1
            
        }
        
        return path
        
    }
    
    private func connectPointsWith(path: inout Path, index: Int, point0: CGPoint, height: CGFloat, width: CGFloat)->CGPoint {

        let mappedYValue = self.convertToCoordinate(value: lineDataSet.dataPoints[index].yValue, min: self.yAxisMinMax(settings: self.yAxisSettings).min, max: self.yAxisMinMax(settings: self.yAxisSettings).max, length: height)
        let xValues = lineDataSet.dataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        let mappedXValue = self.convertToCoordinate(value: lineDataSet.dataPoints[index].xValue, min: minX, max: maxX, length: width)
        let point1 = CGPoint(x: mappedXValue, y: height - mappedYValue)
        if self.lineDataSet.settings.interpolationType == .quadCurve {
            let midPoint = CGPoint.midPointForPoints(p1: point0, p2: point1)
            path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point0))
            path.addQuadCurve(to: point1, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point1))
        }
        path.addLine(to: point1)
        return point1
    }

    
}
//struct DYMultiLineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        DYMultiLineChartView()
//    }
//}
