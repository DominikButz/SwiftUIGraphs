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
    var yValueConverter: (Double)->String
    var xValueConverter: (Double)->String
    
    let generator = UISelectionFeedbackGenerator()
    
    @Binding var selectedIndex: Int
    @State private var barEnd = CGFloat.zero
    
    @StateObject var orientationObserver: OrientationObserver = OrientationObserver()
    @Namespace var namespace
    
    /// DYBarChartView initializer
    /// - Parameters:
    ///   - dataPoints: an array of DYDataPoints.
    ///   - selectedIndex: index of the selected data point.
    ///   - xValueConverter: Implement a logic in this closure that format the x-value as string.
    ///   - yValueConverter:  Implement a logic in this closure  that format the y-value as string.
    ///   - chartFrameHeight: the height of the chart (including x-axis, if applicable). If an the x-axis view is present, it is recommended to set this value, otherwise the height might be unpredictable.
    ///   - settings: DYBarChart settings.
    public init(dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, xValueConverter: @escaping (Double)->String, yValueConverter: @escaping (Double)->String, chartFrameHeight:CGFloat? = nil, settings: DYBarChartSettings = DYBarChartSettings()) {
        self._selectedIndex = selectedIndex
        self.xValueConverter = xValueConverter
        self.yValueConverter = yValueConverter
        // sort the data points according to x values
    
        let sortedData = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.dataPoints = sortedData
  
        self.chartFrameHeight = chartFrameHeight
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
                            self.yAxisView(geo: geo).padding(.trailing, 5).frame(width:settings.yAxisSettings.yAxisViewWidth)
                        }
                        ZStack {

                            if self.settings.yAxisSettings.showYAxisLines {
                                self.yAxisGridLines().opacity(0.5)
                            }

                            self.bars()

                        }.background(settings.chartViewBackgroundColor)

                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing {
                            self.yAxisView(geo: geo).padding(.leading, 5).frame(width:settings.yAxisSettings.yAxisViewWidth)
                               // .frame(height: chartFrameHeight)
                        }
                    }.frame(height: chartFrameHeight)

                    if self.settings.xAxisSettings.showXAxis {
                        self.xAxisView(totalWidth: geo.size.width - settings.yAxisSettings.yAxisViewWidth - marginSum)
                    }
                }
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
            
            HStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                ForEach(dataPoints) { dataPoint in
                    VStack( spacing: 0) {
                        let i = self.indexFor(dataPoint: dataPoint) ?? 0
                        if i == self.selectedIndex && (settings as! DYBarChartSettings).showSelectionIndicator {
                            Rectangle().fill((settings as! DYBarChartSettings).selectionIndicatorColor)
                                .frame(width:barWidth, height: 2)
                                .offset(y: -2)
                                .matchedGeometryEffect(id: "selectionIndicator", in: namespace)
                        }
                        Spacer(minLength: 0)
                        BarView(gradient: settings.gradient, width: barWidth, height: self.convertToYCoordinate(value: dataPoint.yValue, height: height), index: i, orientationObserver: self.orientationObserver, selectedIndex: self.$selectedIndex, selectionFeedbackGenerator: self.generator)
                    }
                    Spacer(minLength: 0)
                    
                }
  
            }
            .onAppear {
                self.generator.prepare()
            }
            
        }
        
        
    }
    
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
        .padding(.leading, settings.lateralPadding.leading )
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.trailing, settings.lateralPadding.trailing)

    }
    
    private func xAxisIntervalLabelViewFor(label: String, index: Int, totalWidth: CGFloat)-> some View {
        Text(label).font(.system(size: settings.xAxisSettings.xAxisFontSize)).position(x: self.convertToXCoordinate(index: index, totalWidth: totalWidth), y: 10)
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
    var width: CGFloat
    var height: CGFloat
    var index: Int
    @ObservedObject var orientationObserver: OrientationObserver
    
    @State var currentHeight: CGFloat = 0
    @State var scale:CGFloat = 1
    @Binding var selectedIndex: Int
    var selectionFeedbackGenerator: UISelectionFeedbackGenerator
    
    var body: some View {
        
        RoundedCornerRectangle(tl: 5, tr: 5, bl: 0, br: 0)
            .fill(gradient)
            .frame(width: width, height: self.currentHeight, alignment: .bottom)
            .scaleEffect(self.scale, anchor: .bottom) // for selection scale effect
            .onTapGesture {
                self.updateSelectionIfNeeded()
            }
            .onAppear {

                withAnimation(Animation.default.delay(0.1 * Double(index))) {
                    self.currentHeight = height
                }

            }
            .onChange(of: self.orientationObserver.orientation, perform: { _ in
                self.currentHeight = height
            })

    }
    
    func updateSelectionIfNeeded() {
        
        if self.selectedIndex != self.index {
            
            self.selectionFeedbackGenerator.selectionChanged() // haptic feedback
            
            withAnimation(Animation.spring()) {
                self.scale = 1.08
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(Animation.spring()) {
                    self.scale = 1
                    self.selectedIndex = index
                }
            }
            
        }
    }
}
