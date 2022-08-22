//
//  File.swift
//  
//
//  Created by Dominik Butz on 23/8/2022.
//

import Foundation
import SwiftUI


public struct DYLineView<PointV: View, LabelV: View, SelectorV: View>: View, DYLineViewModifiableProperties {
    
    var dataPoints: [DYDataPoint]
    var yAxisSettings: YAxisSettings
    var yAxisScaler: AxisScaler
    var xAxisScaler: AxisScaler
    // var xAxisScaler.axisMinMax: (min: Double, max: Double) // can be different from this data set's x values min max because other line data sets included.
    var pointView: (DYDataPoint)-> PointV
    var labelView: (DYDataPoint)->LabelV
    var selectorView: SelectorV
    @Binding var selectedDataPoint: DYDataPoint?
    @Binding var touchingXPosition: CGFloat? // User X touch location - nil = not touching
    @Binding var selectorLineOffset: CGFloat
    
    ///modifiables:
    public var colorPerLineSegment: ((DYDataPoint)->Color)?
    public var settings: DYLineSettings
    // private State properties
    @State private var selectedIndex: Int?
    @State private var selectorCurrentXPosition: CGFloat = 0 // can be different from selector line offset in multi-line chart!
    @State private var lineEnd: CGFloat = 0 // for line animation
    @State private var showLineSegments: Bool = false  // for segmented line animation
    @State private var showSupplementaryViews: Bool = false  // for supplementary views appear animation
    
    
    
    public init(dataPoints: [DYDataPoint], selectedDataPoint: Binding<DYDataPoint?>, @ViewBuilder pointView: @escaping (DYDataPoint)-> PointV = {_ in EmptyView()}, labelView:  @escaping (DYDataPoint)->LabelV = {_ in EmptyView()}, selectorView: SelectorV = EmptyView(), parentViewProperties: DYLineParentViewProperties) {
    
        self.dataPoints =  dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self._selectedDataPoint = selectedDataPoint
        self.pointView = pointView
        self.labelView = labelView
        self.selectorView = selectorView
        self.settings = DYLineSettings()
        self.yAxisSettings = parentViewProperties.yAxisSettings
        self.yAxisScaler = parentViewProperties.yAxisScaler
        /// NEW:
        self.xAxisScaler = parentViewProperties.xAxisScaler
        //self.xAxisScaler.axisMinMax = parentViewProperties.xAxisScaler.axisMinMax
        self._touchingXPosition = parentViewProperties.touchingXPosition
        self._selectorLineOffset = parentViewProperties.selectorLineOffset

    }
    
   public var body: some View {
        GeometryReader { geo in
            ZStack {
                
                if (self.settings.lineAreaGradient != nil && showSupplementaryViews) || self.settings.showAppearAnimation == false {
                    self.gradient()
                }
                
                if let _ = self.colorPerLineSegment {
                    self.lineSegments()
                } else {
                    self.line()
                }
             
                if self.showSupplementaryViews || self.settings.showAppearAnimation == false {
                    
                    if self.selectedDataPoint != nil {
                        self.selectedDataPointAxisLines().clipped()
                    }
                    
                    if let _ = self.pointView {
                        self.points()
                    }
                    
                    if let _ = self.labelView {
                        self.pointLabelViews()
                    }

                    if self.settings.allowUserInteraction {
                        self.selectorPointView()
                    }
                }
                
                
                
            }.onAppear {
               // self.selectedIndex = self.lineDataSet.selectedIndex
                if let selectedDataPoint = self.selectedDataPoint {
                    if let index = self.dataPoints.firstIndex(where: {$0.id == selectedDataPoint.id}) {
                        self.setSelected(index: index)
                    }
                }
                self.showLine()
            }.onChange(of: self.touchingXPosition) { newValue in
               // print("touching x pos \(newValue)")
           
               // if newValue == nil {
                    //print("line offset \(self.selectorLineOffset)")
                    self.updateSelectorCurrentXPosition(geo: geo)
                    let index = self.fractionIndexFor(xPosition: self.selectorLineOffset, width: geo.size.width)
                    //print("released touching position. setting index to \(index)")
                    self.setSelected(index: index)
                
                    //print("setting selected to index \(index)")
              //  }
                
            }
        }
    }
    
    private func showLine() {

        guard self.settings.showAppearAnimation  else {
            return
            
        }
        
        withAnimation(.easeIn(duration: self.settings.lineAnimationDuration)) {
            self.lineEnd = 1
            self.showLineSegments = true // for different color line segments
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + self.settings.lineAnimationDuration) {
            withAnimation(.easeIn) {
                self.showSupplementaryViews = true
            }
        }
    }
    
    
    private func line()->some View {
      GeometryReader { geo in
        Group {
            if self.dataPoints.count >= 2 {
                self.pathFor(width: geo.size.width, height: geo.size.height, closeShape: false)
                    .trim(from: 0, to: self.settings.showAppearAnimation ? self.lineEnd : 1)
                    .stroke(style: self.settings.lineStrokeStyle)
                    .foregroundColor(self.settings.lineColor)
                    .shadow(color: self.settings.lineDropShadow?.color ?? .clear, radius: self.settings.lineDropShadow?.radius ?? 0, x:  self.settings.lineDropShadow?.x ?? 0, y:  self.settings.lineDropShadow?.y ?? 0)
            }
        }
      }
 
    }
    
    // for separatly colored segments between points
    private func lineSegments()-> some View {
        GeometryReader { geo in
            
            Group {
                if self.dataPoints.count >= 2 {
                    ForEach(0..<dataPoints.count, id: \.self) { index in
                        
                        Path { path in
                            path =  self.drawPathWith(path: &path, index: index, height: geo.size.height, width: geo.size.width)
                            
                        }
                        .stroke(style: self.settings.lineStrokeStyle)
                        .foregroundColor(self.colorPerLineSegment!(dataPoints[index]))
  
                    }
                    
                }
            }
            .shadow(color: self.settings.lineDropShadow?.color ?? .clear, radius:  self.settings.lineDropShadow?.radius ?? 0, x:  self.settings.lineDropShadow?.x ?? 0, y:  self.settings.lineDropShadow?.y ?? 0)
            .mask(lineAnimationMaskingView(width:geo.size.width))
            
        }
        
    }
    
    /// for line drawing animation if line composed of several paths in separate colours
    private func lineAnimationMaskingView(width: CGFloat)->some View {
        HStack {
            Rectangle().fill(Color.white.opacity(0.5)).frame(width: self.showLineSegments || self.settings.showAppearAnimation == false ? width : 0, alignment: .trailing)
            Spacer()
        }
    }
    
    private func points()->some View {
      GeometryReader { geo in

         //   let yScale = self.yScaleFor(height: geo.size.height)
            let height = geo.size.height
            let width = geo.size.width
 
          ForEach(dataPoints) { dataPoint in
              self.pointView(dataPoint)
                  .position(x: dataPoint.xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: width), y: height - dataPoint.yValue.convertToCoordinate( min: self.yAxisScaler.axisMinMax.min, max: self.yAxisScaler.axisMinMax.max, length: height))
              
            }
       }
        
    }
    
    private func pointLabelViews()-> some View {
        GeometryReader { geo in
            
            let height = geo.size.height
            let width = geo.size.width
            ForEach(dataPoints) { dataPoint in
                
                self.labelView(dataPoint)
                    .position(x: dataPoint.xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: width), y: (height - dataPoint.yValue.convertToCoordinate(min: self.yAxisScaler.axisMinMax.min, max: self.yAxisScaler.axisMinMax.max, length: height)))
                    
           
                
            }
        }
        
    }
    
    private func selectorPointView()->some View {
        
        GeometryReader { geo in

            let xValue = self.selectedDataPoint?.xValue ?? self.dataPoints.first!.xValue
            
            let xPosition = self.touchingXPosition == nil ? xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: geo.size.width) :  self.selectorCurrentXPosition
            let path = self.pathFor(width: geo.size.width, height: geo.size.height, closeShape: false)
            let yPosition = path.point(to: xPosition).y
            self.selectorView
                .position(x: xPosition, y: yPosition)
                .animation(Animation.spring().speed(4), value: self.selectorCurrentXPosition)
                .opacity(self.selectedDataPoint == nil ? 0 : 1)
         
        }
    }
    
    private func updateSelectorCurrentXPosition(geo: GeometryProxy) {
        let minXPosition = self.dataPoints.first!.xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: geo.size.width)
        let maxXPosition = self.dataPoints.last!.xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: geo.size.width)
        self.selectorCurrentXPosition =  max(minXPosition, min(self.selectorLineOffset, maxXPosition))
    }
    
    private func gradient()->some View {
        GeometryReader { geo in
            self.settings.lineAreaGradient
                .padding(.bottom, 1)
                .mask(
                   GeometryReader { geo in
                       if self.dataPoints.count >= 2 {
                            self.pathFor(width: geo.size.width, height: geo.size.height, closeShape: true)
                        }
                    }
                )
                .shadow(color: settings.lineAreaGradientDropShadow?.color ?? .clear, radius: settings.lineAreaGradientDropShadow?.radius ?? 0, x:  settings.lineAreaGradientDropShadow?.x ?? 0, y:  settings.lineAreaGradientDropShadow?.y ?? 0)
        }
    }
    
    // selection point x and y axis marker lines
    private func selectedDataPointAxisLines()-> some View {
        
        GeometryReader { geo in
            let height = geo.size.height
            let width = geo.size.width
            let selectedDataPoint = self.selectedDataPoint!
            let xValue =  selectedDataPoint.xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: width)
            let yValue = height - selectedDataPoint.yValue.convertToCoordinate(min: self.yAxisScaler.axisMinMax.min, max:  self.yAxisScaler.axisMinMax.max, length: height)
            
            if let xLineColor = settings.xValueSelectedDataPointLineColor {
                Path { p in  // vertical from selected point to x-axis
                    p.move(to: CGPoint(x: xValue, y: yValue))
                    p.addLine(to: CGPoint(x: xValue, y: height))
                }.stroke(style:settings.xValueSelectedDataPointLineStrokeStyle)
                    .foregroundColor(xLineColor)
                    .opacity(self.touchingXPosition == nil ? 1 : 0)
            }
            
            if let yLineColor = settings.yValueSelectedDataPointLineColor {
                Path { p in  // horizontal from selected point to y-axis
                    p.move(to: CGPoint(x: xValue, y: yValue))
                    let xCoordinate = self.yAxisSettings.yAxisPosition  == .trailing ? width  : 0
                    p.addLine(to: CGPoint(x: xCoordinate, y: yValue))
                }.stroke(style: settings.yValueSelectedDataPointLineStrokeStyle)
                    .foregroundColor(yLineColor)
                    .opacity(self.touchingXPosition == nil  ? 1 : 0)
            }
        }
        
    }
    
    //MARK: Helpers
    
    
    var xValuesMinMax: (min: Double, max: Double) {
        let xValues = dataPoints.map({$0.xValue})
        let maxX = xValues.max() ?? 0
        let minX = xValues.min() ?? 0
        return (minX, maxX)
    }
    
    var yValuesMinMax: (min: Double, max: Double) {
        let yValues = dataPoints.map({$0.yValue})
        let maxY = yValues.max() ?? 0
        let minY = yValues.min() ?? 0
        return (minY, maxY)
    }
    
    private func fractionIndexFor(xPosition: CGFloat, width: CGFloat)->CGFloat {
        let convertedXValues = self.dataPoints.map({$0.xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: width)})
        for i in 0..<convertedXValues.count {
            let currentValue = convertedXValues[i]
            let lastValue = i > 0 ? convertedXValues[i - 1] : nil
            if xPosition == currentValue {
                return CGFloat(i)
            } else if let lastValue = lastValue, xPosition < currentValue, xPosition > lastValue {
                let normalizedFraction = Double.normalizationFactor(value: Double(xPosition), maxValue: Double(currentValue), minValue: Double(lastValue))
                 return CGFloat(i - 1) + CGFloat(normalizedFraction)
            } else if i == convertedXValues.count - 1 && xPosition > currentValue {  // swiping past last value (xAxis longer than last xValue of this line !
                return CGFloat(i)
            }
        }

        return 0
    }
    

    
    private func setSelected(index: CGFloat) {
        var selectedIndex:Int = Int(index)
        if index.truncatingRemainder(dividingBy: 1) >= 0.5 && index < CGFloat(self.dataPoints.count - 1) {
            selectedIndex = Int(index) + 1
        }
        //print("selected index now \(selectedIndex)")
        self.setSelected(index: selectedIndex)
    }
    
    func setSelected(index: Int) {
        if Range(0...self.dataPoints.count).contains(index) {
            withAnimation {
                self.selectedDataPoint = self.dataPoints[index]
                self.selectedIndex = index
            }
        }
    }
    
    
    
   
    //MARK: Path drawing
    
    func pathFor(width: CGFloat, height: CGFloat, closeShape: Bool)->Path {
        Path { path in

           path  = self.drawCompletePathWith(path: &path, height: height, width: width)
           
            // Finally close the subpath off by looping around to the beginning point.
            if closeShape {
                let yAxisMinMax = yAxisScaler.axisMinMax
                var y = height
                if yAxisMinMax.min <= 0 {
                    y = height - 0.convertToCoordinate(min: yAxisMinMax.min, max: yAxisMinMax.max, length: height)
                }
                let minX =  self.xValuesMinMax.min.convertToCoordinate(min: self.xAxisScaler.axisMinMax.min, max: self.xAxisScaler.axisMinMax.max, length: width)
                let maxX = self.xValuesMinMax.max.convertToCoordinate(min: self.xValuesMinMax.min, max: self.xAxisScaler.axisMinMax.max, length: width)
                path.addLine(to: CGPoint(x: maxX, y: y))
                path.addLine(to: CGPoint(x: minX, y: y))
                path.closeSubpath()
            }
        }
    }
    
    func drawPathWith(path: inout Path, index: Int, height: CGFloat, width: CGFloat) -> Path {
        
        let mappedYValue0 = dataPoints[index].yValue.convertToCoordinate(min: yAxisScaler.axisMinMax.min, max: yAxisScaler.axisMinMax.max, length: height)
        let mappedXValue0 = dataPoints[index].xValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: width)
            let point0 = CGPoint(x: mappedXValue0, y: height - mappedYValue0)
            path.move(to: point0)
        if index < self.dataPoints.count - 1 {
                let nextIndex = index + 1
                
                _ = self.connectPointsWith(path: &path, index: nextIndex, point0: point0, height: height, width: width)

            }

        return path
        
    }
    
    func drawCompletePathWith(path: inout Path, height: CGFloat, width: CGFloat)->Path {
        
        guard let firstYValue = dataPoints.first?.yValue else {return path}
      
        let firstXValue =  dataPoints.first!.xValue
        
        var point0 = CGPoint(x: firstXValue.convertToCoordinate(min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: width), y: height - firstYValue.convertToCoordinate(min: self.yAxisScaler.axisMinMax.min, max: self.yAxisScaler.axisMinMax.max, length: height))
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

        let mappedYValue = dataPoints[index].yValue.convertToCoordinate(min: self.yAxisScaler.axisMinMax.min, max: self.yAxisScaler.axisMinMax.max, length: height)
        let mappedXValue = dataPoints[index].xValue.convertToCoordinate( min: xAxisScaler.axisMinMax.min, max: xAxisScaler.axisMinMax.max, length: width)
        let point1 = CGPoint(x: mappedXValue, y: height - mappedYValue)
        if self.settings.interpolationType == .quadCurve {
            let midPoint = CGPoint.midPointForPoints(p1: point0, p2: point1)
            path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point0))
            path.addQuadCurve(to: point1, control: CGPoint.controlPointForPoints(p1: midPoint, p2: point1))
        }
        path.addLine(to: point1)
        return point1
    }

    
}


public typealias  DYLineParentViewProperties = (yAxisSettings: YAxisSettings, yAxisScaler: AxisScaler, xAxisScaler: AxisScaler,  touchingXPosition: Binding<CGFloat?>, selectorLineOffset: Binding<CGFloat>)


public protocol DYLineViewModifiableProperties {
    associatedtype LabelV: View
    associatedtype PointV: View
    associatedtype SelectorV: View
    var settings: DYLineSettings {get set}
    var colorPerLineSegment: ((DYDataPoint)->Color)? {get set}
}

public extension View where Self: DYLineViewModifiableProperties {
    
    func lineStyle(color: Color, strokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), shadow: Shadow? = nil, interpolationType: InterpolationType = .quadCurve)->DYLineView<PointV, LabelV, SelectorV>  {
        var modView = self
        modView.settings.lineColor = color
        modView.settings.lineStrokeStyle = strokeStyle
        modView.settings.lineDropShadow = shadow
        modView.settings.interpolationType = interpolationType
        return modView as! DYLineView<PointV, LabelV, SelectorV>
    }
    
    func animation(showAppearAnimation: Bool = true, duration:TimeInterval = 1.4)->DYLineView<PointV, LabelV, SelectorV> {
        var modView = self
        modView.settings.showAppearAnimation = showAppearAnimation
        modView.settings.lineAnimationDuration = duration
        return modView as! DYLineView<PointV, LabelV, SelectorV>
    }
    
    func userInteraction(enabled: Bool = true )->DYLineView<PointV, LabelV, SelectorV>  {
        var modView = self
        modView.settings.allowUserInteraction = enabled
        return modView as! DYLineView<PointV, LabelV, SelectorV>
    }
    
    func area(gradient: LinearGradient?, shadow: Shadow?)-> DYLineView<PointV, LabelV, SelectorV>  {
        var modView = self
        modView.settings.lineAreaGradient = gradient
        modView.settings.lineAreaGradientDropShadow = shadow
        return modView as! DYLineView<PointV, LabelV, SelectorV>
    }
    
    func selectedPointIndicatorLineStyle(xLineColor: Color? = nil, xLineStrokeStyle: StrokeStyle = StrokeStyle(lineWidth: 2, dash: [3]), yLineColor: Color? = nil, yLineStrokeStyle: StrokeStyle =  StrokeStyle(lineWidth: 2, dash: [3]))->DYLineView<PointV, LabelV, SelectorV>  {
        var modView = self
        modView.settings.xValueSelectedDataPointLineColor = xLineColor
        modView.settings.xValueSelectedDataPointLineStrokeStyle = xLineStrokeStyle
        modView.settings.yValueSelectedDataPointLineColor = yLineColor
        modView.settings.yValueSelectedDataPointLineStrokeStyle = yLineStrokeStyle
        return modView as! DYLineView<PointV, LabelV, SelectorV>
    }
    
    func colorPerLineSegment(_ closure: ((DYDataPoint)->Color)? = nil)->DYLineView<PointV, LabelV, SelectorV>  {
        var modView = self
        modView.colorPerLineSegment = closure
        return modView as! DYLineView<PointV, LabelV, SelectorV> 
    }
  
}


