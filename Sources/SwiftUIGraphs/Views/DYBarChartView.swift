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
    
    @State private var barEnd = CGFloat.zero
    
    public init(dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, xValueConverter: @escaping (Double)->String, yValueConverter: @escaping (Double)->String, chartFrameHeight:CGFloat? = nil, settings: DYBarChartSettings = DYBarChartSettings()) {
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
                               // .frame(height: chartFrameHeight)
                        }
                    }.frame(height: chartFrameHeight)

                    if (self.settings as! DYBarChartSettings).xAxisSettings.showXAxis {
                        self.xAxisView()
                    }
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
                        BarView(gradient: settings.gradient, width: barWidth, height: self.convertToYCoordinate(value: dataPoints[i].yValue, height: height), index: i, selectedIndex: self.$selectedIndex)
//                            .shadow(color: self.selectedIndex == i ? Color.gray : Color.clear, radius: 3, x: 3, y: 3).shadow(color: self.selectedIndex == i ? Color.gray : Color.clear, radius: 3, x: -3, y:-3)
//                            .animation(.easeInOut)
                    }
                    Spacer(minLength: 0)
                    
                }
  
            }.padding(.bottom, 1)
          //  .frame(height: chartFrameHeight)
            
        }
        
        
    }
    
    private func xAxisView()-> some View {

        HStack(alignment: .center) {
           // GeometryReader { geo in
                Spacer()
                ForEach(self.dataPoints.map({$0.xValue}), id:\.self) { value in
                    Text(self.xValueConverter(value)).font((settings as! DYBarChartSettings).xAxisSettings.xAxisFont)
                    Spacer()
                }
          //  }

        }
        .padding(.leading, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .leading ?  settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.leading, settings.lateralPadding.leading )
        .padding(.trailing, settings.yAxisSettings.showYAxis && settings.yAxisSettings.yAxisPosition == .trailing ? settings.yAxisSettings.yAxisViewWidth : 0)
        .padding(.trailing, settings.lateralPadding.trailing)

    }

}
//struct DYBarChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}

internal struct BarView: View {
    
    var gradient: LinearGradient
    var width: CGFloat
    var height: CGFloat
    
    @State var currentHeight: CGFloat = 0
    var index: Int
    @Binding var selectedIndex: Int
    
    var body: some View {
        
        RoundedCornerRectangle(tl: 5, tr: 5, bl: 0, br: 0)
            .fill(gradient)
            .frame(width: width, height: height, alignment: .center)
            
            .onTapGesture {
                self.selectedIndex = index
            }
            .onAppear {
                withAnimation(Animation.easeIn(duration: 0.3).delay( 0.1 * Double(index))) {
                    self.currentHeight = height
                }
            }
    }
}
