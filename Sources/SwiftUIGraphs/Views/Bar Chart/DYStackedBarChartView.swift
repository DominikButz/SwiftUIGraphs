//
//  DYStackedBarChartView.swift
//  
//
//  Created by Dominik Butz on 2/9/2022.
//

import SwiftUI

public struct DYStackedBarChartView: View, PlotAreaChart {

    var barDataSets: [DYBarDataSet]
    var settings: DYPlotAreaSettings
    var plotAreaHeight: CGFloat?
    var yAxisScaler: YAxisScaler
    var yValueAsString: (Double)->String
    let generator = UISelectionFeedbackGenerator()
    
    @State var showBars: Bool = false
    
    public init(barDataSets: [DYBarDataSet], settings: DYStackedBarChartSettings = DYStackedBarChartSettings(xAxisSettings: DYBarChartXAxisSettings()), plotAreaHeight: CGFloat? = nil, yValueAsString: @escaping (Double) -> String) {
        self.settings = settings
        self.barDataSets = barDataSets
        self.plotAreaHeight = plotAreaHeight
        self.yValueAsString = yValueAsString
        var min =  barDataSets.map({$0.negativeYValue}).min() ?? 0
        if let overrideMin = settings.yAxisSettings.yAxisMinMaxOverride?.min, overrideMin < min {
            min = overrideMin
        }
        var max = self.barDataSets.map({$0.positiveYValue}).max() ?? 0
        if let overrideMax = settings.yAxisSettings.yAxisMinMaxOverride?.max, overrideMax > max {
            max = overrideMax
        }
        self.yAxisScaler = YAxisScaler(min:min, max: max, maxTicks: 10) // initialize here otherwise error will be thrown
    }
    
    public var body: some View {
        GeometryReader { geo in
            
            if self.barDataSets.count >= 1 {
                VStack(spacing: 0) {
                    HStack(spacing:0) {
                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading {
                            self.yAxisView(yValueAsString: self.yValueAsString)

                        }
                        ZStack {

                            if self.settings.yAxisSettings.showYAxisGridLines {
                                self.yAxisGridLines()
                            }
                            
                            if self.showBars {
                                self.bars()
                            }

                        }.frame(width: geo.size.width - self.settings.yAxisSettings.yAxisViewWidth).background(settings.plotAreaBackgroundGradient)
                        

                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing {
                            self.yAxisView(yValueAsString: self.yValueAsString, yAxisPosition: .trailing)

                        }
                    }.frame(height: plotAreaHeight)

                    if self.settings.xAxisSettings.showXAxis {
                        self.xAxisView(totalWidth: geo.size.width - settings.yAxisSettings.yAxisViewWidth)
                    }
                }.onAppear {
                    self.showBars = true
                }
//                .onChange(of: self.orientationObserver.orientation, perform: { _ in
//                    self.showBars = false
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                        self.showBars = true
//                    }
//                })
            } else {
                // placeholder grid in case not enough data is available
                self.placeholderGrid(xAxisLineCount: 12, yAxisLineCount: 10).frame(height: self.plotAreaHeight).opacity(0.5).padding().transition(AnyTransition.opacity)
            }
        }
        
    }
    
    private func bars()->some View {
         GeometryReader {geo in
             let totalHeight = geo.size.height
             let totalWidth = geo.size.width
             let barWidth:CGFloat = self.barWidth(totalWidth: totalWidth)
             let yMinMax = self.yAxisMinMax(settings: settings.yAxisSettings)
             let zeroYcoord = totalHeight - self.convertToCoordinate(value: 0, min: yMinMax.min, max: yMinMax.max, length: totalHeight)
             
             ZStack {

                 ForEach(barDataSets) { dataSet in

                     let positiveBarHeight =  dataSet.positiveYValue / (yMinMax.max - yMinMax.min) * totalHeight
                     let negativeBarHeight = abs(dataSet.negativeYValue) / (yMinMax.max - yMinMax.min) * totalHeight
                     let dropShadow = (settings as! DYStackedBarChartSettings).barDropShadow
                     let positiveBarYPosition = self.barYPosition(barHeight: positiveBarHeight, totalHeight: totalHeight, zeroYCoord: zeroYcoord, valueNegative: false)
                     let negativeBarYPosition = self.barYPosition(barHeight: negativeBarHeight, totalHeight: totalHeight, zeroYCoord: zeroYcoord, valueNegative: true)
                     let shouldShowPositiveLabel: Bool = positiveBarYPosition - positiveBarHeight / 2 + (settings as! DYStackedBarChartSettings).labelViewOffset.height  > (settings as! DYStackedBarChartSettings).minimumTopEdgeBarLabelMargin
                     let shouldShowNegativeLabel = negativeBarYPosition + negativeBarHeight / 2 - (settings as! DYStackedBarChartSettings).labelViewOffset.height < totalHeight - (settings as! DYStackedBarChartSettings).minimumBottomEdgeBarLabelMargin
                     
                     let i = self.indexFor(dataSet: dataSet) ?? 0
                     ZStack {
                         // positive bar
                         StackedBarView(fractions: dataSet.positiveFractions, width: barWidth, height: positiveBarHeight, index: i, yAxisScaler: yAxisScaler, labelView: shouldShowPositiveLabel ?  dataSet.labelView?(dataSet.positiveYValue) : nil, settings: settings as! DYStackedBarChartSettings)
                            .position(x: self.convertToXCoordinate(index: i, totalWidth: totalWidth), y: positiveBarYPosition)
                         // negative bar
                         StackedBarView(fractions: dataSet.negativeFractions, width: barWidth, height: negativeBarHeight, index: i, yAxisScaler: yAxisScaler, labelView: shouldShowNegativeLabel ?  dataSet.labelView?(dataSet.negativeYValue) : nil, settings: settings as! DYStackedBarChartSettings)
                            .position(x: self.convertToXCoordinate(index: i, totalWidth: totalWidth), y: negativeBarYPosition)
                         
                     }
                     .shadow(color: dropShadow?.color ?? .clear, radius:  dropShadow?.radius ?? 0, x:  dropShadow?.x ?? 0, y: dropShadow?.y ?? 0)
             
                     
                     
                 }

             }
             .onAppear {
                 self.generator.prepare()
             }
             
         }
         
         
     }
    
    private func barYPosition(barHeight: CGFloat, totalHeight: CGFloat, zeroYCoord: CGFloat, valueNegative: Bool)->CGFloat {
        let halfBarHeight = valueNegative ? -barHeight / 2 : +barHeight / 2
        return zeroYCoord - halfBarHeight
   
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
       // .padding(.leading, settings.lateralPadding.leading )
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)

    }
    
    private func xAxisIntervalLabelViewFor(label: String, index: Int, totalWidth: CGFloat)-> some View {
        Text(label).font(.system(size: settings.xAxisSettings.labelFontSize)).position(x: self.convertToXCoordinate(index: index, totalWidth: totalWidth), y: 10)
    }
    
    // MARK: Helper Funcs
    
    private func barWidth(totalWidth:CGFloat)->CGFloat {
       return (totalWidth / 2) / CGFloat(self.barDataSets.count)
    }
    
    public func xAxisLabelStrings()->[String] {
        return self.barDataSets.map({$0.xAxisLabel})
    }
    
   private func indexFor(labelString:String)->Int {
       return self.xAxisLabelStrings().firstIndex(where: {$0 == labelString}) ?? 0
   }
    
    private func indexFor(dataSet: DYBarDataSet)->Int? {
        return self.barDataSets.firstIndex(where: {$0.id == dataSet.id})
    }
    
    private func convertToXCoordinate(index:Int, totalWidth: CGFloat)->CGFloat {

        let barWidth = self.barWidth(totalWidth: totalWidth)
        let barCount = CGFloat(self.barDataSets.count)
        
        let spacerWidth = (totalWidth - barWidth * CGFloat(barCount)) / CGFloat(barCount + 1)
        
        let startPosition:CGFloat = spacerWidth + barWidth / 2.0

        return startPosition + CGFloat(index) * (spacerWidth + barWidth)

    }
}

internal struct StackedBarView: View, DataPointConversion {
    
    let fractions: [DYBarDataFraction]
    let width: CGFloat
    let height: CGFloat
    let index: Int
    var yAxisScaler: YAxisScaler
    var labelView: AnyView?
    let settings: DYStackedBarChartSettings

    @State private var barHeightFactor: CGFloat = 0
    @State private var showLabelView: Bool = false
    
    var body: some View {
        
        ZStack {

            VStack(spacing: 0) {
                ForEach(fractions) { fraction in
                    let fractionHeight = abs(fraction.value) /  abs(valueSum) * height
                    Rectangle().fill(fraction.gradient).frame(height: fractionHeight)
                        .overlay(MaxHeightOptionalView(maxHeight: fractionHeight - 3, view: fraction.labelView?()))
                }
            }
            .frame(width: width, height: height)
            .clipShape(RoundedCornerRectangle(tl: 5, tr: 5, bl: 0, br: 0).rotation(Angle(degrees: valueSum > 0 ? 0 : 180)))
            .scaleEffect(x: 1,  y: self.barHeightFactor, anchor: valueSum >= 0 ? .bottom : .top)
            
            if let labelView = labelView, showLabelView {
                 labelView
                    .offset(x: barLabelTotalOffset.width, y: barLabelTotalOffset.height).transition(.opacity)
            }
            
        }
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
    
    var valueSum: CGFloat {
        return fractions.map({$0.value}).reduce(0, +)
    }
    
    var barLabelTotalOffset: CGSize {
        
        let widthOffset: CGFloat = valueSum > 0 ? settings.labelViewOffset.width :  -settings.labelViewOffset.width
        let heightOffset: CGFloat = valueSum > 0 ?  -height / 2 + settings.labelViewOffset.height : height / 2 - settings.labelViewOffset.height
       
        return CGSize(width: widthOffset, height: heightOffset)

    }
    


    
}



//struct DYStackedBarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        DYStackedBarChartView()
//    }
//}
