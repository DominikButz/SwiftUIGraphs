//
//  DYStackedBarChartView.swift
//  
//
//  Created by Dominik Butz on 2/9/2022.
//

import SwiftUI

public struct DYStackedBarChartView: View, PlotAreaChart {


    var barDataSets: [DYBarDataSet]
    var settings: DYStackedBarChartSettings 
    var yAxisSettings: YAxisSettingsNew
    var xAxisSettings: XAxisSettings
    var yAxisScaler: YAxisScaler
    var yValueAsString: (Double)->String
    let generator = UISelectionFeedbackGenerator()
    
    //@State private var selectedIndex: Int?
    @Binding private var selectedBarDataSet: DYBarDataSet?
    @State var showBars: Bool = false
  
    public init(barDataSets: [DYBarDataSet], selectedBarDataSet: Binding<DYBarDataSet?>, settings: DYStackedBarChartSettings = DYStackedBarChartSettings(xAxisSettings: DYBarChartXAxisSettings()), yValueAsString: @escaping (Double) -> String) {
        self.settings = settings
        self.xAxisSettings = DYBarChartXAxisSettings()
        self.yAxisSettings = YAxisSettingsNew()
        self.barDataSets = barDataSets
        self._selectedBarDataSet = selectedBarDataSet
        self.yValueAsString = yValueAsString
        self.yAxisScaler = YAxisScaler(min:0, max: 0, maxTicks: 10) // initialize here otherwise error will be thrown
        self.configureYAxisScaler(min: barDataSets.map({$0.negativeYValue}).min() ?? 0, max: barDataSets.map({$0.positiveYValue}).max() ?? 0)

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
                                self.yAxisZeroGridLine()
                            }
                            
                            if self.showBars {
                                self.bars()
                            }

                        }.frame(width: geo.size.width - self.settings.yAxisSettings.yAxisViewWidth).background(settings.plotAreaBackgroundGradient)
                        

                        if self.settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing {
                            self.yAxisView(yValueAsString: self.yValueAsString, yAxisPosition: .trailing)

                        }
                    }

                    if self.settings.xAxisSettings.showXAxis {
                        self.xAxisView().frame(height: settings.xAxisSettings.xAxisViewHeight)
                    }
                }
                .onAppear {
                    self.showBars = true
                }
            } else {
                // placeholder grid in case not enough data is available
                self.placeholderGrid(xAxisLineCount: 12, yAxisLineCount: 10).opacity(0.5).padding().transition(AnyTransition.opacity)
            }
        }.onAppear {
            
            self.generator.prepare()
//            if let barDataSet = self.selectedBarDataSet {
//
//            }
        }
        
    }
    
    private func bars()->some View {
        GeometryReader {geo in
            let totalHeight = geo.size.height
            let totalWidth = geo.size.width
            let barWidth:CGFloat = self.barWidth(totalWidth: totalWidth)
            let yMinMax = self.yAxisScaler.axisMinMax
            let positiveBarYOrigin =  totalHeight - self.convertToCoordinate(value: max(0, yMinMax.min), min: yMinMax.min, max: yMinMax.max, length: totalHeight)
            let negativeBarYOrigin = totalHeight - self.convertToCoordinate(value: min(0, yMinMax.max), min: yMinMax.min, max: yMinMax.max, length: totalHeight)
 
            ForEach(barDataSets) { dataSet in
                
                let positiveBarHeight =  dataSet.positiveYValue / (yMinMax.max - yMinMax.min) * totalHeight
                let negativeBarHeight = abs(dataSet.negativeYValue) / (yMinMax.max - yMinMax.min) * totalHeight
                let positiveBarYPosition = self.barYPosition(barHeight: positiveBarHeight, totalHeight: totalHeight, originY: positiveBarYOrigin, valueNegative: false)
                let negativeBarYPosition = self.barYPosition(barHeight: negativeBarHeight, totalHeight: totalHeight, originY: negativeBarYOrigin, valueNegative: true)
                let totalBarHeight = positiveBarHeight + negativeBarHeight
                let barsYPosition = (positiveBarHeight / totalBarHeight) * positiveBarYPosition + (negativeBarHeight / totalBarHeight) * negativeBarYPosition
     
                let i = self.indexFor(dataSet: dataSet) ?? 0
                
                BarViewPair(dataSet: dataSet, index: i, selectedBarDataSet: self.$selectedBarDataSet, dataSetCount: self.barDataSets.count, totalHeight: totalHeight, barWidth: barWidth, positiveBarYPosition: positiveBarYPosition, negativeBarYPosition: negativeBarYPosition, settings: settings as! DYStackedBarChartSettings, yAxisScaler: yAxisScaler)
                .position(x: self.convertToXCoordinate(index: i, totalWidth: totalWidth), y: barsYPosition)
                
                .onTapGesture {
                    
                    guard self.settings.allowUserInteraction  else {return}
                    
                    self.generator.selectionChanged()
                    
                    guard self.selectedBarDataSet != dataSet else {
                        withAnimation {
                            self.selectedBarDataSet = nil
                        }
                        return
                    }
                    withAnimation {
           
                        self.selectedBarDataSet = dataSet
                    }
                    
                }
                
            }

        }
        
        
    }
    
    private func barYPosition(barHeight: CGFloat, totalHeight: CGFloat, originY: CGFloat, valueNegative: Bool)->CGFloat {
        let halfBarHeight = valueNegative ? -barHeight / 2 : +barHeight / 2
        return originY - halfBarHeight
   
    }
    
    private func xAxisView()-> some View {
        GeometryReader { proxy in
            let totalWidth = proxy.size.width
            
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

internal struct BarViewPair: View, DataPointConversion {

    let dataSet: DYBarDataSet
    let index: Int
    @Binding var selectedBarDataSet: DYBarDataSet?
    var dataSetCount: Int
    let totalHeight: CGFloat
    let barWidth: CGFloat
    let positiveBarYPosition: CGFloat
    let negativeBarYPosition: CGFloat
    let settings: DYStackedBarChartSettings
    var yAxisScaler: YAxisScaler
    @State var selectionScale: CGFloat = 1
    @State var showSelectionBorder: Bool = false
    
    var body: some View {
        let yMinMax = self.yAxisScaler.axisMinMax
        let positiveBarHeight =  dataSet.positiveYValue / (yMinMax.max - yMinMax.min) * totalHeight
        let negativeBarHeight = abs(dataSet.negativeYValue) / (yMinMax.max - yMinMax.min) * totalHeight

        let shouldShowPositiveLabel: Bool = positiveBarYPosition - positiveBarHeight / 2 + settings.labelViewOffset.height  > settings.minimumTopEdgeBarLabelMargin
        let shouldShowNegativeLabel = negativeBarYPosition + negativeBarHeight / 2 - settings.labelViewOffset.height < totalHeight - settings.minimumBottomEdgeBarLabelMargin
        let totalBarHeight = positiveBarHeight + negativeBarHeight
//        let barsYPosition = (positiveBarHeight / totalBarHeight) * positiveBarYPosition + (negativeBarHeight / totalBarHeight) * negativeBarYPosition
        let shadow = dataSet == selectedBarDataSet ? settings.selectedBarDropShadow ?? settings.barDropShadow : settings.barDropShadow

        VStack(spacing: 0) {
            // positive bar
           
            if positiveBarHeight > 0 {
                //Spacer(minLength: 0)
                StackedBarView(fractions: dataSet.positiveFractions, width: barWidth, height: positiveBarHeight, index: index, yAxisScaler: yAxisScaler, labelView: shouldShowPositiveLabel ?  dataSet.labelView?(dataSet.positiveYValue) : nil, labelViewOffset: settings.labelViewOffset)
                
            }
            
            // negative bar
            if negativeBarHeight > 0 {
                StackedBarView(fractions: dataSet.negativeFractions, width: barWidth, height: negativeBarHeight, index: index, yAxisScaler: yAxisScaler, labelView: shouldShowNegativeLabel ?  dataSet.labelView?(dataSet.negativeYValue) : nil, labelViewOffset: settings.labelViewOffset)
               // Spacer(minLength: 0)
            }
            
            
        }
        .frame(width: barWidth, height: totalBarHeight)
        .overlay( // selected bar border
            self.selectionBorder
        )
        .scaleEffect(self.selectionScale, anchor: scaleEffectAnchor)
        .shadow(color: shadow?.color ?? .clear, radius:  shadow?.radius ?? 0, x:  shadow?.x ?? 0, y: shadow?.y ?? 0)
        .onChange(of: self.selectedBarDataSet, perform: { newValue in
            if let selectedBarSet = newValue, selectedBarSet == dataSet {
                withAnimation(Animation.spring()) {
                    self.selectionScale = 1.08
                }
            
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    withAnimation(Animation.spring()) {
                        self.selectionScale = 1
                    }
                }
            }
        }).onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * TimeInterval( self.dataSetCount)) {
                withAnimation {
                    self.showSelectionBorder = true
                }
            }
        }
   
    }
    
    var selectionBorder: some View {
        Group {
            if self.showSelectionBorder {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(dataSet == selectedBarDataSet ? settings.selectedBarBorderColor : .clear, lineWidth: max(1, min(self.barWidth * 0.1, 3)))
                    .animation(.easeInOut, value: selectedBarDataSet)
            }
        }
    }
    
    var scaleEffectAnchor: UnitPoint {
        if dataSet.positiveYValue > 0 && dataSet.negativeYValue > 0 {
            return .center
        } else if dataSet.positiveYValue > 0 {
            return .bottom
        } else if dataSet.negativeYValue < 0 {
            return .top
        }
   
        return .center
    }
    
}

internal struct StackedBarView: View, DataPointConversion {
    
    let fractions: [DYBarDataFraction]
    let width: CGFloat
    let height: CGFloat
    let index: Int
    //@Binding var selectedIndex: Int?
    var yAxisScaler: YAxisScaler
    var labelView: AnyView?
    let labelViewOffset: CGSize
  //  let settings: DYStackedBarChartSettings

    @State private var barHeightFactor: CGFloat = 0
    @State private var showLabelView: Bool = false
    
    var body: some View {
        
        ZStack {

            VStack(spacing: 0) {
                ForEach(fractions) { fraction in
                    let fractionHeight = abs(fraction.value) /  abs(valueSum) * height
                    Rectangle().fill(fraction.gradient).frame(height: fractionHeight)
                        .overlay(MaxSizeOptionalView(maxSize: CGSize(width: self.width - 2, height: fractionHeight - 3), view: fraction.labelView?()))
                }
            }
            .frame(width: width, height: height)
            .clipShape(RoundedCornerRectangle(tl: 5, tr: 5, bl: 0, br: 0).rotation(Angle(degrees: valueSum > 0 ? 0 : 180)))
            .scaleEffect(x: 1,  y: self.barHeightFactor, anchor: valueSum >= 0 ? .bottom : .top)
            .overlay(self.labelOverlay())

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

    
    func labelOverlay()-> some View {
        Group {
            if let labelView = labelView, showLabelView {
                 labelView
                    .fixedSize()
                    .offset(x: barLabelTotalOffset.width, y: barLabelTotalOffset.height).transition(.opacity)
            }
        }
    }
    
    var valueSum: CGFloat {
        return fractions.map({$0.value}).reduce(0, +)
    }
    
    var barLabelTotalOffset: CGSize {
        
        let widthOffset: CGFloat = valueSum > 0 ? labelViewOffset.width :  -labelViewOffset.width
        let heightOffset: CGFloat = valueSum > 0 ?  -height / 2 + labelViewOffset.height : height / 2 - labelViewOffset.height
       
        return CGSize(width: widthOffset, height: heightOffset)

    }

}





//struct DYStackedBarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        DYStackedBarChartView()
//    }
//}
