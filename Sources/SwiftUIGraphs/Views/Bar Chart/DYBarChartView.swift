//
//  DYBarChartView.swift
//  
//
//  Created by Dominik Butz on 17/2/2021.
//

import SwiftUI

public struct DYBarChartView: View, DYGridChart {
    
    var dataPoints: [DYDataPoint]
    var yAxisScaler: YAxisScaler
    var settings: DYGridChartSettings 
    var marginSum: CGFloat {
        return settings.lateralPadding.leading + settings.lateralPadding.trailing
    }
    var chartFrameHeight: CGFloat?
    var labelView:((DYDataPoint)->AnyView?)?
    var yValueConverter: (Double)->String
    var xValueConverter: (Double)->String
    var gradientPerBar: ((DYDataPoint)->LinearGradient)?
    
    let generator = UISelectionFeedbackGenerator()
    @State var showBars: Bool = false
    @Binding var selectedIndex: Int
    @State private var barEnd = CGFloat.zero
    
    @StateObject var orientationObserver: OrientationObserver = OrientationObserver()
    @Namespace var namespace
    
    /// DYBarChartView initializer
    /// - Parameters:
    ///   - dataPoints: an array of DYDataPoints.
    ///   - selectedIndex: index of the selected data point.
    ///   - labelView: A custom view that should appear above the respective point. Default value is nil.
    ///   - xValueConverter: Implement a logic in this closure that format the x-value as string.
    ///   - yValueConverter:  Implement a logic in this closure  that format the y-value as string.
    ///   - gradientPerBar: overrides the gradient in the DYBarChartSettings for each individual bar. Default value is nil (all bars are filled with the gradient of the DYBarChartSettings.
    ///   - chartFrameHeight: the height of the chart (including x-axis, if applicable). If an the x-axis view is present, it is recommended to set this value, otherwise the height might be unpredictable.
    ///   - settings: DYBarChart settings.
    public init(dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, labelView: ((DYDataPoint)->AnyView?)? = nil, xValueConverter: @escaping (Double)->String, yValueConverter: @escaping (Double)->String,  gradientPerBar: ((DYDataPoint)->LinearGradient)? = nil, chartFrameHeight:CGFloat? = nil,  settings: DYBarChartSettings = DYBarChartSettings()) {
        self._selectedIndex = selectedIndex
        self.xValueConverter = xValueConverter
        self.yValueConverter = yValueConverter
        self.gradientPerBar = gradientPerBar
        // sort the data points according to x values
        let sortedData = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.dataPoints = sortedData
  
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
            
            if self.dataPoints.count >= 2 {
                VStack(spacing: 0) {
                    HStack(spacing:0) {
                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading {
                            self.yAxisViewNew(yValueConverter: self.yValueConverter)

                        }
                        ZStack {

                            if self.settings.yAxisSettings.showYAxisGridLines {
                                self.yAxisGridLines().opacity(0.5)
                            }
                            
                            if self.showBars {
                                self.bars()
                            }

                        }.frame(width: geo.size.width - self.settings.yAxisSettings.yAxisViewWidth).background(settings.chartViewBackgroundColor)

                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing {
                            self.yAxisViewNew(yValueConverter: self.yValueConverter, yAxisPosition: .trailing)

                        }
                    }.frame(height: chartFrameHeight)

                    if self.settings.xAxisSettings.showXAxis {
                        self.xAxisView(totalWidth: geo.size.width - settings.yAxisSettings.yAxisViewWidth - marginSum)
                    }
                }.onAppear {
                    self.showBars = true
                }
                .onChange(of: self.orientationObserver.orientation, perform: { _ in
                    self.showBars = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.showBars = true
                    }
                })
            } else {
                // placeholder grid in case not enough data is available
                self.placeholderGrid(xAxisLineCount: 12, yAxisLineCount: 10).frame(height: self.chartFrameHeight).opacity(0.5).padding()
            }
        }
        
    }
    
    private func bars()->some View {
         GeometryReader {geo in
             let height = geo.size.height
             let width = geo.size.width - marginSum
             let barWidth:CGFloat = self.barWidth(totalWidth: width)
             
             ZStack {

                 ForEach(dataPoints) { dataPoint in
                     ZStack {
                         let i = self.indexFor(dataPoint: dataPoint) ?? 0
                         
                         if i == self.selectedIndex && (settings as! DYBarChartSettings).showSelectionIndicator {
                             Rectangle().fill((settings as! DYBarChartSettings).selectionIndicatorColor)
                                 .frame(width:barWidth, height: 2)
                                 .position(x:self.settings.lateralPadding.leading + self.convertToXCoordinate(index: i, totalWidth: width), y:0)
                                 .offset(y: -2)
                                 .matchedGeometryEffect(id: "selectionIndicator", in: namespace)
                             
                         }
                         
                         BarView(gradient: gradientPerBar?(dataPoint) ?? settings.gradient, settings: self.settings as! DYBarChartSettings, width: barWidth, height: self.convertToYCoordinate(value: dataPoint.yValue, height: height), index: i, labelView: self.labelView?(dataPoint), labelOffset: self.settings.labelViewDefaultOffset, showLabelView: self.settings.showAppearAnimation ? false : true, barHeightFactor: self.settings.showAppearAnimation ? 0 : 1, selectedIndex: self.$selectedIndex, allowUserInteraction: self.settings.allowUserInteraction, selectionFeedbackGenerator: self.generator)
                             .position(x: self.settings.lateralPadding.leading + self.convertToXCoordinate(index: i, totalWidth: width), y: height  - self.convertToYCoordinate(value: dataPoint.yValue, height: height) / 2)
                     }
                 }

             }
             .onAppear {
                 self.generator.prepare()
             }
             
         }
         
         
     }
    

    
    /// not working properly
//    private func selectedDataPointYAxisLine()-> some View {
//
//        GeometryReader { geo in
//            let height = geo.size.height
//            let width = geo.size.width - marginSum
//            let selectedDataPoint = self.dataPoints[self.selectedIndex]
//            let point = self.barPointPosition(dataPoint: selectedDataPoint, totalWidth: width, totalHeight: height)
//
//            if self.settings.yAxisSettings.showYAxisSelectedDataPointLine {
//                Path { p in  // horizontal from selected point to y-axis
//                    p.move(to: point)
//                    let xCoordinate = self.settings.yAxisSettings.yAxisPosition  == .trailing ? width : self.settings.lateralPadding.leading
//                    p.addLine(to: CGPoint(x: xCoordinate, y: point.y))
//                }.stroke(style:self.settings.yAxisSettings.yAxisSelectedDataPointLineStrokeStyle)
//                    .foregroundColor(self.settings.yAxisSettings.yAxisSelectedDataPointLineColor)
//
//            }
//        }
//
//    }
    
    /// not working properly
//    private func yAxisPointMarkerLines()->some View {
//
//        let yAxisSettings = self.settings.yAxisSettings
//        let strokeStyle = yAxisSettings.yAxisDataPointLinesStrokeStyle
//        let color = yAxisSettings.yAxisDataPointLinesColor
//
//        return GeometryReader { geo in
//            let totalHeight = geo.size.height
//            let totalWidth = geo.size.width - marginSum
//
//                Path { p in
//                    for point in self.dataPoints {
//                        let point = self.barPointPosition(dataPoint: point, totalWidth: totalWidth, totalHeight: totalHeight)
//                        p.move(to: point)
//
//                        let xValue  = self.settings.yAxisSettings.yAxisPosition == .trailing ? totalWidth : self.settings.lateralPadding.leading
//                        p.addLine(to: CGPoint(x: xValue, y: point.y))
//
//                    }
//
//                }.stroke(style: strokeStyle)
//                    .foregroundColor(color)
//
//        }
//    }
    
    private func xAxisView(totalWidth: CGFloat)-> some View {

        ZStack(alignment: .center) {

            let labels = self.xAxisLabelStrings()
            let labelSteps = self.xAxisLabelSteps(totalWidth: totalWidth)
            ForEach(labels, id:\.self) { label in
                let i = self.indexFor(labelString: label)
                if  i % labelSteps == 0 {
                    self.xAxisIntervalLabelViewFor(label: label, index: i, totalWidth: totalWidth)
                }
            
            }
        }
        .padding(.leading, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading ?  settings.yAxisSettings.yAxisViewWidth : 0)
       // .padding(.leading, settings.lateralPadding.leading )
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)

    }
    
    private func xAxisIntervalLabelViewFor(label: String, index: Int, totalWidth: CGFloat)-> some View {
        Text(label).font(.system(size: settings.xAxisSettings.labelFontSize)).position(x:self.settings.lateralPadding.leading + self.convertToXCoordinate(index: index, totalWidth: totalWidth), y: 10)
    }
    

    
    // MARK: Helper Funcs
    
    private func barWidth(totalWidth:CGFloat)->CGFloat {
       return (totalWidth / 2) / CGFloat(self.dataPoints.count)
    }

 
    private func convertToXCoordinate(index:Int, totalWidth: CGFloat)->CGFloat {

        let barWidth = self.barWidth(totalWidth: totalWidth)
        let barCount = CGFloat(self.dataPoints.count)
        
        let spacerWidth = (totalWidth - barWidth * CGFloat(barCount)) / CGFloat(barCount + 1)
        
        let startPosition:CGFloat = spacerWidth + barWidth / 2.0

        return startPosition + CGFloat(index) * (spacerWidth + barWidth)

    }


}

internal struct BarView: View {
    
    var gradient: LinearGradient
    var settings: DYBarChartSettings
    var width: CGFloat
    var height: CGFloat
    var index: Int
    var labelView:AnyView?
    var labelOffset: CGSize
    //@ObservedObject var orientationObserver: OrientationObserver
    
 //   @State var currentHeight: CGFloat = 0
    @State var showLabelView: Bool = false
    @State var barHeightFactor: CGFloat = 0
    @State var selectionScale:CGFloat = 1
    @Binding var selectedIndex: Int
    var allowUserInteraction: Bool
    var selectionFeedbackGenerator: UISelectionFeedbackGenerator
    
    var body: some View {
        ZStack {
                RoundedCornerRectangle(tl: 5, tr: 5, bl: 0, br: 0)
                .fill(selectedIndex == index ? (settings.selectedBarGradient ?? gradient) : gradient)
                    .frame(width: width, height: self.height)
                    .scaleEffect(x: 1,  y: self.barHeightFactor, anchor: .bottom)  // for show animation
                    .shadow(color: self.index == selectedIndex ? self.settings.selectedBarDropShadow?.color ?? self.settings.barDropShadow?.color ??  .clear : self.settings.barDropShadow?.color ?? .clear, radius:  self.index == selectedIndex ? self.settings.selectedBarDropShadow?.radius ?? self.settings.barDropShadow?.radius ?? 0 : self.settings.barDropShadow?.radius ?? 0, x:  self.index == selectedIndex ? self.settings.selectedBarDropShadow?.x ?? self.settings.barDropShadow?.x ?? 0 : self.settings.barDropShadow?.x ?? 0, y:  self.index == selectedIndex ? self.settings.selectedBarDropShadow?.y ?? self.settings.barDropShadow?.y ?? 0 : self.settings.barDropShadow?.y ?? 0)
                        .onTapGesture {
                            self.updateSelectionIfNeeded()
                        }
            
            if self.showLabelView {
                self.labelView
                    .offset(x: 0, y: -height / 2)
                    .offset(x: labelOffset.width, y: labelOffset.height).transition(.opacity)
            }
 
        }.scaleEffect(self.selectionScale, anchor: .bottom) // for selection scale effect
        .onAppear {
            
            withAnimation(Animation.default.delay(0.1 * Double(index))) {
                self.barHeightFactor = 1
            }
            if let _ = self.labelView {
                withAnimation(Animation.default.delay(0.11 * Double(index))) {
                    self.showLabelView = true
                }
            }
            

        }


    }
    
    func updateSelectionIfNeeded() {
        
        if self.selectedIndex != self.index && self.allowUserInteraction  {
            
            self.selectionFeedbackGenerator.selectionChanged() // haptic feedback
            
            withAnimation(Animation.spring()) {
                self.selectionScale = 1.08
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(Animation.spring()) {
                    self.selectedIndex = index
                    self.selectionScale = 1
                }
            }
            
        }
    }
}
