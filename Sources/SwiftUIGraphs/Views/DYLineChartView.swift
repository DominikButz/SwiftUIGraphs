//
//  DYLineChartView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI

public struct DYLineChartView: View {
   
    var dataPoints: [DYDataPoint]

   @State private var convertedXValues: [CGFloat]  = []
    
    @Binding var selectedIndex: Int
    
    @State var lineOffset: CGFloat = 0 // Vertical line offset
   // @State var selectedXPos: CGFloat = 8 // User X touch location
    @State var selectedYPos: CGFloat = 0 // User Y touch location
    @State var isSelected: Bool = false // Is the user touching the graph
    
    @State var showWithAnimation: Bool = false
    // constants
    var chartFrameHeight: CGFloat?
    var settings: DYLineChartSettings
    
    var yAxisScaler: YAxisScaler
    var xValueConverter:  (Double)->String
    var yValueConverter: (Double)->String
    
    var marginSum: CGFloat {
        return settings.lateralPadding.leading + settings.lateralPadding.trailing
    }
    
    public init(dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, xValueConverter: @escaping (Double)->String, yValueConverter: @escaping (Double)->String, chartFrameHeight:CGFloat? = nil, settings: DYLineChartSettings = DYLineChartSettings()) {
        self._selectedIndex = selectedIndex
        // sort the data points according to x values
        let sortedData = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.dataPoints = sortedData
        self.xValueConverter = xValueConverter
        self.yValueConverter = yValueConverter
        self.chartFrameHeight = chartFrameHeight
        self.settings = settings
        
        var min =  dataPoints.map({$0.yValue}).min() ?? 0
        if let overrideMin = settings.yAxisSettings.yAxisMinMaxOverride?.min, overrideMin < min {
            min = overrideMin
        }

    //     let min =  self.dataPoints.map({$0.yValue}).min() ?? 0
         var max = self.dataPoints.map({$0.yValue}).max() ?? 0
        if let overrideMax = settings.yAxisSettings.yAxisMinMaxOverride?.max, overrideMax > max {
            max = overrideMax
        }
         self.yAxisScaler = YAxisScaler(min:min, max: max, maxTicks: 10)
    }

    public var body: some View {
        GeometryReader { geo in
            
            if self.dataPoints.count >= 2 {
                VStack(spacing: 0) {
                    HStack(spacing:0) {
                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading {
                            self.yAxisView(geo: geo).padding(.trailing, 5).frame(width:settings.yAxisSettings.yAxisViewWidth)
                        }
                        ZStack {

                            Group {
                                if self.settings.yAxisSettings.showYAxisLines {
                                    self.yAxisGridLines().opacity(0.5)
                                }
                                if self.settings.xAxisSettings.showXAxisLines {
                                    self.xAxisGridLines().opacity(0.5)
                                }
                                self.line()
                                if self.settings.showGradient {
                                    self.gradient()
                                }
                                if self.settings.showPointMarkers {
                                    self.points()
                                }
                               self.addUserInteraction()
                                
                            }
       
                        }.background(settings.chartViewBackgroundColor)
                        
                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing {
                            self.yAxisView(geo: geo).padding(.leading, 5).frame(width:settings.yAxisSettings.yAxisViewWidth)
                        }
                    }.frame(height: chartFrameHeight)
                    
                    if settings.xAxisSettings.showXAxis {
                        self.xAxisView()
                    }
                }
            } else {
                HStack {
                    Spacer()
                    Text("Not enough data!").padding()
                    Spacer()
                }
            }
        }
        
    }
    
    //MARK: Sub-Views
    

    
    private func yAxisView(geo: GeometryProxy)-> some View {

        VStack(alignment: .trailing, spacing: 0) {
            let interval = self.yAxisScaler.tickSpacing ?? self.settings.yAxisSettings.yAxisIntervalOverride ?? 0
            if let maxValue = self.yAxisValues().first, maxValue >=  interval {
                Text(self.yValueConverter(maxValue)).font(.system(size: 7))
            }
            ForEach(self.yAxisValues(), id: \.self) {value in
                if value != self.yAxisMinMax().max {
                    Spacer(minLength: 0)
                    Text(self.yValueConverter(value)).font(.system(size: 7))
                }
                
            }
        
        }
        //.frame(height: geo.size.height)
    }
    
    

    
    
    private func yAxisGridLines() -> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                let width = geo.size.width
                Path { p in
                
                    var yPosition:CGFloat = 0

                    let count = self.yAxisValueCount()
                    let yAxisInterval = self.settings.yAxisSettings.yAxisIntervalOverride ?? self.yAxisScaler.tickSpacing ?? 1

                    let min = self.yAxisMinMax().min
                    let max = self.yAxisMinMax().max
                    let convertedYAxisInterval  = geo.size.height * CGFloat(yAxisInterval / (max - min))
                    
                    for _ in 0..<count    {
                         
                        p.move(to: CGPoint(x: 0, y: yPosition))
                        p.addLine(to: CGPoint(x: width, y: yPosition))
                        p.closeSubpath()
                        yPosition += convertedYAxisInterval
                    }

                    
                }.stroke(style: settings.yAxisSettings.yAxisLineStrokeStyle)
                .foregroundColor(.secondary)
                
            }

        }
    }
    
    private func xAxisView()-> some View {
        
        ZStack(alignment: .center) {
            GeometryReader { geo in

                ForEach(self.xAxisValues(), id:\.self) { value in
                    self.xAxisIntervalTextViewFor(value: value, geo: geo)
                }
            }
        
        }
        .padding(.leading, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading ?  settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.leading, settings.lateralPadding.leading )
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.trailing, settings.lateralPadding.trailing)

    }
    
    private func xAxisIntervalTextViewFor(value:Double, geo: GeometryProxy)-> some View {
        Text(self.xValueConverter(value)).font(.system(size: 7)).position(x: self.convertToXCoordinate(value: value, width: geo.size.width - marginSum), y: 10)
    }


    private func xAxisGridLines()-> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Path { p in
                    let totalWidth = geo.size.width - marginSum
                    let totalHeight = geo.size.height
                    var xPosition: CGFloat = self.settings.lateralPadding.leading
                    let count = self.xAxisLineCount()
                    let interval:Double = settings.xAxisSettings.xAxisInterval
                    let xAxisMinMax = self.xAxisMinMax()
                    let convertedXAxisInterval = totalWidth * CGFloat(interval / (xAxisMinMax.max - xAxisMinMax.min))
                    for _ in 0..<count + 1 {
                        p.move(to: CGPoint(x: xPosition, y: 0))
                        p.addLine(to: CGPoint(x:xPosition, y: totalHeight))
                        xPosition += convertedXAxisInterval
                    }
                }.stroke(style: settings.xAxisSettings.xAxisLineStrokeStyle)
                .foregroundColor(.secondary)
            }
            
            
        }
    }
    
    private func line()->some View {
      GeometryReader { geo in
        self.pathFor(width: geo.size.width - marginSum, height: geo.size.height, closeShape: false)

            .stroke(style: settings.lineStrokeStyle)
            .foregroundColor(settings.lineColor)
            .onAppear {
                  self.convertedXValues = self.dataPoints.map({convertToXCoordinate(value: $0.xValue, width: geo.size.width - marginSum)})
              }
      }
 
    }
    
    private func gradient() -> some View {
        settings.gradient
            .padding(.bottom, 1)
            .opacity(0.7)
            .mask(
               GeometryReader { geo in
                    self.pathFor(width: geo.size.width - marginSum, height: geo.size.height, closeShape: true)

                  }
             )
    }
    
    func pathFor(width: CGFloat, height: CGFloat, closeShape: Bool)->Path {
        Path { path in

           path  = self.drawLineWith(path: &path, height: height, width: width)

            // Finally close the subpath off by looping around to the beginning point.
            if closeShape {
                path.addLine(to: CGPoint(x: settings.lateralPadding.leading + width, y: height))
                path.addLine(to: CGPoint(x: settings.lateralPadding.leading, y: height))
                path.closeSubpath()
            }
        }
    }
    
    func drawLineWith(path: inout Path, height: CGFloat, width: CGFloat)->Path {
        var point1 = CGPoint(x: settings.lateralPadding.leading, y: height - self.convertToYCoordinate(value: dataPoints[0].yValue, height: height))
        path.move(to: point1)
        var index:CGFloat = 0
        
        for _ in dataPoints {
            if index != 0 {

                let mappedYValue = self.convertToYCoordinate(value: dataPoints[Int(index)].yValue, height: height)
                let mappedXValue = self.convertToXCoordinate(value: dataPoints[Int(index)].xValue, width: width)
                let point2 = CGPoint(x: settings.lateralPadding.leading + mappedXValue, y: height - mappedYValue)
                let midPoint = CGPoint.midPointForPoints(p1: point1, p2: point2)
                path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point1))
                path.addQuadCurve(to: point2, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point2))
                path.addLine(to: point2)
                point1 = point2
            }
            index += 1
            
        }
        
        return path
        
    }
    
    private func points()->some View {
      GeometryReader { geo in

         //   let yScale = self.yScaleFor(height: geo.size.height)
            let height = geo.size.height
            let width = geo.size.width - marginSum
          ForEach(dataPoints.indices) { i in
                Circle()
                    .stroke(style: settings.pointStrokeStyle)
                    .frame(width: settings.pointDiameter, height: settings.pointDiameter, alignment: .center)
                    .foregroundColor(settings.pointColor)
                    .background(settings.pointBackgroundColor)
                    .cornerRadius(5)
                    //((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)) * CGFloat(i) - 5
                    .offset(x: settings.lateralPadding.leading + self.convertToXCoordinate(value: dataPoints[i].xValue, width: width) - 5, y: (height - self.convertToYCoordinate(value: dataPoints[i].yValue, height: height)) - 5)
            }
       }
        
    }
    
    private func addUserInteraction() -> some View {
      GeometryReader { geo in

            let height = geo.size.height
            let width = geo.size.width - marginSum
        //    let yScale = self.yScaleFor(height: geo.size.height)

            ZStack(alignment: .leading) {
                
                settings.markerLineColor
                                .frame(width: 2)
                                .opacity(self.isSelected ? 1 : 0) // hide the vertical indicator line if user not touching the chart
                                .overlay(
                                    Circle()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .foregroundColor(settings.markerLinePointColor)
                                        .opacity(0.2)
                                        .overlay(
                                            Circle()
                                                .fill()
                                                .frame(width: settings.markerLinePointDiameter, height: settings.markerLinePointDiameter, alignment: .center)
                                                .foregroundColor(settings.markerLinePointColor)
                                        )
                                        //CGFloat(self.dataPoints.count) - self.convertToYCoordinate(value: Double(selectedYPos), height: height)
                     //+ CGFloat(self.dataPoints.count)
                                        .offset(x: 0, y: isSelected ? selectedYPos - height + settings.markerLinePointDiameter :  settings.markerLinePointDiameter - self.convertToYCoordinate(value: dataPoints[selectedIndex].yValue, height: height))
                                    , alignment: .bottom)
                    .offset(x: isSelected ? lineOffset : settings.lateralPadding.leading + self.convertToXCoordinate(value: dataPoints[selectedIndex].xValue, width: width), y: 0)
                                .animation(Animation.spring().speed(4))
                
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
      // let width = geo.size.width
        //- marginSum
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
    
    private func xAxisMinMax()->(min: Double, max: Double){
        let xValues = dataPoints.map({$0.xValue})
        return (min: xValues.min() ?? 0, max: xValues.max() ?? 0)
    }
    
    private func yAxisMinMax()->(min: Double, max: Double){
        let scaledMin = self.settings.yAxisSettings.yAxisMinMaxOverride?.min ?? self.yAxisScaler.scaledMin ?? 0
        let scaledMax = self.settings.yAxisSettings.yAxisMinMaxOverride?.max ?? self.yAxisScaler.scaledMax ?? 1
        
        return (min: scaledMin, max: scaledMax)
        /////////
//        if let yAxisMinMax = settings.yAxisMinMax {
//            return yAxisMinMax
//        }
//
//        let yValues = dataPoints.map({$0.yValue})
//
//        let maxY = yValues.max() ?? 0
//        let minY = yValues.min() ?? 0
//
//        return (min: minY, max: maxY)

    }
    
    
    private func yAxisValueCount()->Int {
     //   print("y axis lines \(self.yAxisScaler.scaledValues().count)")
        guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
            return self.yAxisScaler.scaledValues().count
        }
        let yAxisMinMax = self.yAxisMinMax()
        let yAxisInterval = interval
        let count = (yAxisMinMax.max - yAxisMinMax.min) / yAxisInterval
     //   print("line count \(count + 1)")
        return Int(count) + 1
    }
    
    private func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
   
        let count = (xAxisMinMax.max - xAxisMinMax.min) / settings.xAxisSettings.xAxisInterval
        
        return Int(count)
    
        
    }
    
//    private var yAxisInterval: Double {
//        
//        let yAxisMinMax = self.yAxisMinMax()
//        let digits = yAxisMinMax.max.roundingFactorDigits()
//        
//        let roundFactor = pow(settings.yAxisIntervalNumberBase, digits)
//        
//        let interval = Double(truncating: NSDecimalNumber(decimal:roundFactor)) * Double(settings.yAxisValueFrequency)
//    
//        return interval
//    }
    
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
    
    private func yAxisValues()->[Double] {
        
        guard let interval = settings.yAxisSettings.yAxisIntervalOverride else {
            return self.yAxisScaler.scaledValues().reversed()
        }
        var values:[Double] = []
        let count = self.yAxisValueCount()
        let yAxisInterval = interval
        var currentValue  = self.yAxisMinMax().max
      //  print("value count :\(count)")
        for _ in 0..<(count) {
            values.append(currentValue)
            currentValue -= yAxisInterval
        }
        return values

    }
    

    
    private func convertToXCoordinate(value: Double, width: CGFloat)->CGFloat {
        let xValues = dataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        
        return width * CGFloat(normalizationFactor(value: value, maxValue: maxX, minValue: minX))

    }
    
    private func convertToYCoordinate(value:Double, height: CGFloat)->CGFloat {
        
        let yAxisMinMax = self.yAxisMinMax()

        return height * CGFloat(normalizationFactor(value: value, maxValue: yAxisMinMax.max, minValue: yAxisMinMax.min))

    
    }
    
    private func normalizationFactor(value: Double, maxValue: Double, minValue: Double)->Double {
        
        return (value - minValue) / (maxValue - minValue)
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
