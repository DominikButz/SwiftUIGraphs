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
        return settings.leadingPadding + settings.trailingPadding
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
    //MARK: Sub-Views
    
    public var body: some View {
        GeometryReader { geo in
            if self.dataPoints.count >= 2 {
                HStack {
                    if self.settings.showYAxis {
                        self.yAxisView(geo: geo)
                    }
                    ZStack {

                        Group {
                            if self.settings.showYAxisLines {
                                self.yAxisLines().opacity(0.5)
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
              
            } else {
                HStack {
                    Spacer()
                    Text("Not enough data!").padding()
                    Spacer()
                }
            }
        }
        
    }
    
    private func yAxisView(geo: GeometryProxy)-> some View {

        VStack(alignment: .trailing, spacing: 0) {
            
            if let maxValue = self.yAxisValues(height: geo.size.height).first, maxValue >= self.yAxisInterval {
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
                    let yAxisInterval = self.yAxisInterval
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
    
    private func line()->some View {
      GeometryReader { geo in
            Path { p in

             //   let yScale = self.yScaleFor(height: geo.size.height)

                var index: CGFloat = 0
       
                // move to first dataPoint
                let height = geo.size.height
                let width = geo.size.width - marginSum
                
                let point0 = CGPoint(x: settings.leadingPadding, y: height - self.convertToYCoordinate(value: dataPoints[0].yValue, height: height))
                p.move(to: point0)

                for _ in dataPoints {
                    if index != 0 {
                        //+ ((geo.size.width - marginSum) / CGFloat(dataPoints.count - 1)) * index
//                        p.addQuadCurve(to: CGPoint(x: leadingMargin + self.convertToXCoordinate(value: dataPoints[Int(index)].xValue, width: width), y: height - self.convertToYCoordinate(value: dataPoints[Int(index)].yValue, height: height)), control: <#T##CGPoint#>)
                        let point1 = CGPoint(x: settings.leadingPadding + self.convertToXCoordinate(value: dataPoints[Int(index)].xValue, width: width), y: height - self.convertToYCoordinate(value: dataPoints[Int(index)].yValue, height: height))
                        p.addLine(to: point1)
                        
                    }
                    index += 1
                    
                }
            }
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
                     Path { p in

                    //    let yScale = self.yScaleFor(height: geo.size.height)

                         var index: CGFloat = 0
                        let height = geo.size.height
                        let width = geo.size.width - marginSum
                       
                         // Move to the starting point on graph
                        let mappedYValue = self.convertToYCoordinate(value: dataPoints[0].yValue, height: height)
                         p.move(to: CGPoint(x: settings.leadingPadding, y: height - mappedYValue))

                         // draw lines
                         for _ in dataPoints {
                             if index != 0 {
                                let mappedYValue = self.convertToYCoordinate(value: dataPoints[Int(index)].yValue, height: height)
                                let mappedXValue = self.convertToXCoordinate(value: dataPoints[Int(index)].xValue, width: width)
                                // ((geo.size.width - marginSum) / CGFloat(dataPoints.count - 1)) * index
                                p.addLine(to: CGPoint(x: settings.leadingPadding + mappedXValue, y: height - mappedYValue))
                             }
                             index += 1
                         }

                         // Finally close the subpath off by looping around to the beginning point.
                         p.addLine(to: CGPoint(x: settings.leadingPadding + ((width) / CGFloat(self.dataPoints.count - 1)) * (index - 1), y: geo.size.height))
                         p.addLine(to: CGPoint(x: settings.leadingPadding, y: geo.size.height))
                         p.closeSubpath()
                     }
                  }
             )
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
                    .offset(x: settings.leadingPadding + self.convertToXCoordinate(value: dataPoints[i].xValue, width: width) - 5, y: (height - self.convertToYCoordinate(value: dataPoints[i].yValue, height: height)) - 5)
            }
       }
        
    }
    
    private func addUserInteraction() -> some View {
      GeometryReader { geo in

            let height = geo.size.height
            let width = geo.size.width - marginSum
        //    let yScale = self.yScaleFor(height: geo.size.height)

            ZStack(alignment: .leading) {
                
                settings.lineMarkerColor
                                .frame(width: 2)
                                .opacity(self.isSelected ? 1 : 0) // hide the vertical indicator line if user not touching the chart
                                .overlay(
                                    Circle()
                                        .frame(width: 24, height: 24, alignment: .center)
                                        .foregroundColor(settings.lineMarkerColor)
                                        .opacity(0.2)
                                        .overlay(
                                            Circle()
                                                .fill()
                                                .frame(width: 12, height: 12, alignment: .center)
                                                .foregroundColor(settings.lineMarkerColor)
                                        )
                                        
                                        .offset(x: 0, y: isSelected ? CGFloat(self.dataPoints.count) - self.convertToYCoordinate(value: Double(selectedYPos), height: height)  : CGFloat(self.dataPoints.count) - self.convertToYCoordinate(value: dataPoints[selectedIndex].yValue, height: height) )
                                    , alignment: .bottom)
                    .offset(x: isSelected ? lineOffset : settings.leadingPadding + self.convertToXCoordinate(value: dataPoints[selectedIndex].xValue, width: width), y: 0)
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
                self.lineOffset = self.settings.leadingPadding
            }

         }
    }
    
    //MARK: Helper functions
    
    private func dragOnChanged(value: DragGesture.Value, geo: GeometryProxy) {
        let xPos = value.location.x
      // let width = geo.size.width
        //- marginSum
        self.isSelected = true
        
     //   let index = (xPos - leadingMargin) / (((width) / CGFloat(self.dataPoints.count - 1)))
        let index = self.fractionIndexFor(xPosition: xPos - settings.leadingPadding)
   //  / (((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)))
        if index > 0 && index < CGFloat(self.dataPoints.count - 1) {
            let m = (dataPoints[Int(index) + 1].yValue - dataPoints[Int(index)].yValue)
            self.selectedYPos = CGFloat(m) * index.truncatingRemainder(dividingBy: 1) + CGFloat(dataPoints[Int(index)].yValue)
            
        }


        if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < CGFloat(self.dataPoints.count  - 1) {
            self.selectedIndex = Int(index) + 1
        } else {
            self.selectedIndex = Int(index)
        }
      //  self.selectedXPos = min(max(leadingMargin, xPos), geo.size.width - leadingMargin)
        self.lineOffset = min(max(settings.leadingPadding, xPos), geo.size.width - settings.trailingPadding)
        
    }
    
    private func dragOnEnded(value: DragGesture.Value, geo: GeometryProxy) {
        let xPos = value.location.x
        self.isSelected = false
      //  let index = (xPos - leadingMargin) / (((geo.size.width - marginSum) / CGFloat(self.dataPoints.count - 1)))
        let index = self.fractionIndexFor(xPosition: xPos - settings.leadingPadding)
        
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
    
    private func yAxisMinMax()->(min: Double, max: Double){
        let yValues = dataPoints.map({$0.yValue})
        
        let maxY = yValues.max() ?? 0
        let roundingFactorDigits = maxY.roundingFactorDigits()
        let maxYRoundedUp = maxY.rounded(digits: roundingFactorDigits, roundingRule: .up)
        
        let minY = yValues.min() ?? 0
        
        let minYRoundedDown = minY.rounded(digits: roundingFactorDigits, roundingRule: .down)
        
        var maxYFinal: Double = Double(maxYRoundedUp)
        var minYFinal: Double = Double(minYRoundedDown)
        
        if let overrideMinMax = self.settings.overrideYAxisMinMax {
            if let overrideMax = overrideMinMax.max, overrideMax > maxYFinal {
                maxYFinal = overrideMax
            }
            if let overrideMin = overrideMinMax.min, overrideMin < minYFinal {
                minYFinal = overrideMin
            }
        }
        return (min:minYFinal, max: maxYFinal)
 
    
    }
    
    
    private func yAxisLineCountFor(height: CGFloat)->Int {
        
        let yAxisMinMax = self.yAxisMinMax()
        let yAxisInterval = self.yAxisInterval
        let count = (yAxisMinMax.max - yAxisMinMax.min) / yAxisInterval
        
        return Int(count)
    }
    
    private var yAxisInterval: Double {
        
        let yAxisMinMax = self.yAxisMinMax()
        let digits = yAxisMinMax.max.roundingFactorDigits()
        
        let roundFactor = pow(10, digits)
        let interval = Double(truncating: NSDecimalNumber(decimal:roundFactor)) * Double(settings.yAxisValueInterval)
        return interval
    }
    
    private func yAxisValues(height: CGFloat)->[Double] {
        var values:[Double] = []
        let count = self.yAxisLineCountFor(height: height)
        let yAxisInterval = self.yAxisInterval
        var currentValue  = self.yAxisMinMax().max
        for _ in 0..<(count + 1) {
            values.append(currentValue)
            currentValue -= yAxisInterval
        }
        return values
    }
    
    private func midPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
        return CGPoint(x:(p1.x + p2.x) / 2,y: (p1.y + p2.y) / 2)
    }

    
    private func controlPointForPoints(p1:CGPoint, p2:CGPoint) -> CGPoint {
        var controlPoint = self.midPointForPoints(p1:p1, p2:p2)
        let diffY = abs(p2.y - controlPoint.y)
        
        if (p1.y < p2.y){
            controlPoint.y += diffY
        } else if (p1.y > p2.y) {
            controlPoint.y -= diffY
        }
        return controlPoint
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
