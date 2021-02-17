//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 17/2/2021.
//

import SwiftUI

public struct DYBarChartView: View, GridChart {
    
    var dataPoints: [DYDataPoint]
    var yAxisScaler: YAxisScaler
    var settings: DYGridSettings
    var marginSum: CGFloat {
        return settings.lateralPadding.leading + settings.lateralPadding.trailing
    }
    var chartFrameHeight: CGFloat?
    var yValueConverter: (Double)->String
    var xValueConverter: (Double)->String
    
    @Binding var selectedIndex: Int
    
    
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
                        }
                    }.frame(height: chartFrameHeight)


                }
            } else {
                HStack {
                    //Spacer()
                    Text("Not enough data!").padding()
                    Spacer()
                }
            }
        }
        
    }
    
   private func bars()->some View {
        GeometryReader {geo in
            let height = geo.size.height - 1
            let width = geo.size.width - marginSum
            let barWidth:CGFloat = (width / 2) / CGFloat(self.dataPoints.count)
            
            HStack(spacing: 0) {
                
                Spacer(minLength: 0)
                
                ForEach(dataPoints.indices) { i in
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        self.barView(width: barWidth, height: self.convertToYCoordinate(value: dataPoints[i].yValue, height: height), index: i)
                    }
                    Spacer(minLength: 0)
                    
                }
  
            }.padding(.bottom, 1)
            
        }
        
        
    }
    
    
    func barView(width: CGFloat, height: CGFloat, index: Int)->some View {
        
        RoundedCornerRectangle(tl: 5, tr: 5, bl: 0, br: 0)
            .fill(settings.gradient)
            .frame(width: width, height: height, alignment: .center)
            .onTapGesture {
                self.selectedIndex = index
            }
    }
    
}

//struct DYBarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
