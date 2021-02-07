//
//  DYLineChartView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI

public struct DYLineChartView: View {
   
    var dataPoints: [DYDataPoint]
    @ObservedObject var orientationObserver = OrientationObserver()
   @State private var convertedXValues: [CGFloat]  = []
    
    @Binding var selectedIndex: Int
    
    @State var lineOffset: CGFloat = 0 // Vertical line offset
   // @State var selectedXPos: CGFloat = 8 // User X touch location
    @State var selectedYPos: CGFloat = 0 // User Y touch location
    @State var isSelected: Bool = false // Is the user touching the graph
    
    @State var showWithAnimation: Bool = false
    // constants

    var settings: DYLineChartSettings
    
    var xValueConverter:  (Double)->String
    var yValueConverter: (Double)->String
    
    var marginSum: CGFloat {
        return settings.lateralPadding.leading + settings.lateralPadding.trailing
    }
    
    public init(dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, xValueConverter: @escaping (Double)->String, yValueConverter: @escaping (Double)->String,   settings: DYLineChartSettings = DYLineChartSettings()) {
        self._selectedIndex = selectedIndex
        // sort the data points according to x values
        let sortedData = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.dataPoints = sortedData
        self.xValueConverter = xValueConverter
        self.yValueConverter = yValueConverter
        self.settings = settings
       // self.setYAxisMinMax(overrideMinMax: overrideYAxisMinMax)
    }

    public var body: some View {
        GeometryReader { geo in
            if self.dataPoints.count >= 2 {
                VStack(spacing: 0) {
                    HStack {
                    if self.settings.showYAxis {
                        self.yAxisView(geo: geo).frame(width:settings.yAxisViewWidth)
                    }
                    ZStack {

                        Group {
                            if self.settings.showYAxisLines {
                                self.yAxisLines().opacity(0.5)
                            }
                            if self.settings.showXAxisLines {
                                self.xAxisLines().opacity(0.5)
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
   
                    }
                }
                    if settings.showXAxis {
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
    
    
//    private func yAxisViewNew(geo: GeometryProxy)-> some View {
//
//        ZStack(alignment: .top) {
//            if let maxValue = self.yAxisValues(height: geo.size.height).first, maxValue >= self.settings.yAxisInterval {
//               Text(self.yValueConverter(maxValue)).font(.system(size: 7)).position(x: 0, y: 0)
//            }
//
//            ForEach(self.yAxisValues(height: geo.size.height), id: \.self) {value in
//                if value != self.yAxisMinMax().max {
//
//                    Text(self.yValueConverter(value)).font(.system(size: 7)).position(x: 0, y: geo.size.height - self.convertToYCoordinate(value: value, height: geo.size.height))
//                }
//
//            }
//
//        }
//    }
    
    private func yAxisView(geo: GeometryProxy)-> some View {

        VStack(alignment: .trailing, spacing: 0) {
            
            if let maxValue = self.yAxisValues(height: geo.size.height).first, maxValue >= self.settings.yAxisInterval {
                Text(self.yValueConverter(maxValue)).font(.system(size: 7))
            }
            ForEach(self.yAxisValues(height: geo.size.height), id: \.self) {value in
                if value != self.yAxisMinMax().max {
                    Spacer(minLength: 0)
                    Text(self.yValueConverter(value)).font(.system(size: 7))
                }
                
            }
        
        }
        //.frame(height: geo.size.height)
    }
    
    

    
    
    private func yAxisLines() -> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                let width = geo.size.width
                Path { p in
                
                    var yPosition:CGFloat = 0

                    let count = self.yAxisLineCountFor(height: geo.size.height)
                    let yAxisInterval = settings.yAxisInterval
                    let yAxisMinMax = self.yAxisMinMax()
                    let convertedYAxisInterval  = geo.size.height * CGFloat(yAxisInterval / (yAxisMinMax.max - yAxisMinMax.min))

                    for _ in 0..<count + 1 {
                        
                        p.move(to: CGPoint(x: 0, y: yPosition))
                        p.addLine(to: CGPoint(x: width, y: yPosition))
                        p.closeSubpath()
                        yPosition += convertedYAxisInterval
                    }

                    
                }.stroke(style: settings.yAxisLineStrokeStyle)
                .foregroundColor(.secondary)
                
            }

        }
    }
    
    private func xAxisView()-> some View {
        
        ZStack {
            GeometryReader { geo in
                if let minValue = self.xAxisValues().first {
                    Text(self.xValueConverter(minValue)).font(.system(size: 7)).position(x: 10, y: 10)
                }
            
                ForEach(self.xAxisValues(), id:\.self) { value in
                    
                    if value != self.xAxisValues().first {
                        Text(self.xValueConverter(value)).font(.system(size: 7)).position(x: self.convertToXCoordinate(value: value, width: geo.size.width - marginSum) + 10, y: 10)
                    }
                }
            }
        
         }
        .padding(.leading, settings.yAxisViewWidth)
        .padding(.leading, settings.lateralPadding.leading )
        .padding(.trailing, settings.lateralPadding.trailing)
        

    }
    
    private func xAxisLines()-> some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                Path { p in
                    let totalWidth = geo.size.width - marginSum
                    let totalHeight = geo.size.height
                    var xPosition: CGFloat = self.settings.lateralPadding.leading
                    let count = self.xAxisLineCount()
                    let interval:Double = settings.xAxisInterval
                    let xAxisMinMax = self.xAxisMinMax()
                    let convertedXAxisInterval = totalWidth * CGFloat(interval / (xAxisMinMax.max - xAxisMinMax.min))
                    for _ in 0..<count + 1 {
                        p.move(to: CGPoint(x: xPosition, y: 0))
                        p.addLine(to: CGPoint(x:xPosition, y: totalHeight))
                        xPosition += convertedXAxisInterval
                    }
                }.stroke(style: settings.xAxisLineStrokeStyle)
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
              .onChange(of: self.orientationObserver.orientation) { (orientation) in
                  self.convertedXValues = self.dataPoints.map({convertToXCoordinate(value: $0.xValue, width: geo.size.width - marginSum)})
              }
        
        
      }
 
    }
    
    private func gradient() -> some View {
        settings.gradient
//            .padding(.leading, leadingMargin)
//            .padding(.trailing, trailingMargin)
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

        let index = self.fractionIndexFor(xPosition: xPos - settings.lateralPadding.leading)
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
        let index = self.fractionIndexFor(xPosition: xPos - settings.lateralPadding.leading)
        
        if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < CGFloat(self.dataPoints.count - 1) {
            self.selectedIndex = Int(index) + 1
        } else {
            self.selectedIndex = Int(index)
        }
    }
    
    private func fractionIndexFor(xPosition: CGFloat)->CGFloat {
        
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
        
        if let yAxisMinMax = settings.yAxisMinMax {
            return yAxisMinMax
        }
        
        let yValues = dataPoints.map({$0.yValue})

        let maxY = yValues.max() ?? 0
      //  let roundingFactorDigits = maxY.roundingFactorDigits()
     //   let maxYRoundedUp = maxY.rounded(digits: roundingFactorDigits, roundingRule: .up)

        let minY = yValues.min() ?? 0

        return (min: minY, max: maxY)
//        let minYRoundedDown = minY.rounded(digits: roundingFactorDigits, roundingRule: .down)
//
//        var maxYFinal: Double = Double(maxYRoundedUp)
//        var minYFinal: Double = Double(minYRoundedDown)
//
//        if let overrideMinMax = self.settings.overrideYAxisMinMax {
//            if let overrideMax = overrideMinMax.max, overrideMax > maxYFinal {
//                maxYFinal = overrideMax
//            }
//            if let overrideMin = overrideMinMax.min, overrideMin < minYFinal {
//                minYFinal = overrideMin
//            }
//        }
//        return (min:minYFinal, max: maxYFinal)


    }
    
    
    private func yAxisLineCountFor(height: CGFloat)->Int {
        
        let yAxisMinMax = self.yAxisMinMax()
        let yAxisInterval = settings.yAxisInterval
        let count = (yAxisMinMax.max - yAxisMinMax.min) / yAxisInterval
        
        return Int(count)
    }
    
    private func xAxisLineCount()->Int {

        let xAxisMinMax = self.xAxisMinMax()
   
        let count = (xAxisMinMax.max - xAxisMinMax.min) / settings.xAxisInterval
        
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
            currentValue += settings.xAxisInterval
            
        }
        return values
    }
    
    private func yAxisValues(height: CGFloat)->[Double] {
        var values:[Double] = []
        let count = self.yAxisLineCountFor(height: height)
        let yAxisInterval = settings.yAxisInterval
        var currentValue  = self.yAxisMinMax().max
        for _ in 0..<(count + 1) {
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
