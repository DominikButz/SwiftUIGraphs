//
//  WorkoutTimeExampleLineChart.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 13/2/2021.
//

import SwiftUI
import SwiftUIGraphs

struct CustomYAxisIntervalExampleLineChart: View {
    
    @State private var selectedDataIndex: Int = 0
    
    let exampleData = DYDataPoint.exampleData0
    
    var body: some View {
        
       return  GeometryReader { proxy in
         VStack {
            DYGridChartHeaderView(title: "Workout Time per Week", dataPoints: exampleData, selectedIndex: self.$selectedDataIndex, isLandscape: proxy.size.height < proxy.size.width, xValueConverter: { (xValue) -> String in
                return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy HH:mm")
            }, yValueConverter: { (yValue) -> String in
           
               return TimeInterval(yValue).toString() ?? ""
            })
        
            DYLineChartView(dataPoints: exampleData, selectedIndex: $selectedDataIndex, xValueConverter: { (xValue) -> String in
                // this is for the x-Axis values - date should be short
                return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
                
            }, labelView: nil, yValueConverter: { (yValue) -> String in
                return TimeInterval(yValue).toString() ?? ""
            }, colorPerPoint: nil, colorPerLineSegment: nil, chartFrameHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65,  settings: DYLineChartSettings(lineColor: .blue, showGradient: true, gradient: LinearGradient(gradient: Gradient(colors: [.blue, Color.white]), startPoint: .top, endPoint: .bottom), pointColor: .blue, selectorLineColor: .blue, selectorLinePointColor: .blue, yAxisSettings: YAxisSettings(showYAxis: true, yAxisPosition: .trailing, yAxisViewWidth: self.yAxisWidth, showYAxisDataPointLines: false, showYAxisSelectedDataPointLine: true,  yAxisFontSize: fontSize, yAxisMinMaxOverride: (min: 0, max: Double(Int(exampleData.map({$0.yValue}).max() ?? 0).nearest(multipleOf: 1800, up: true))), yAxisIntervalOverride: 1800), xAxisSettings: DYLineChartXAxisSettings(showXAxis: true, showXAxisDataPointLines: false, showXAxisSelectedDataPointLine: true, xAxisInterval: 604800, xAxisFontSize: fontSize)))  // 604800 seconds per week
            Spacer()
         }.padding()
         .navigationTitle("Workout Time Per Week")
       }
    }
    var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
    }
    var yAxisWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 40 : 45
    }
    
    func labelView(dataPoint: DYDataPoint)-> AnyView {
        
        return Text("Text").font(.caption).foregroundColor(.blue).eraseToAnyView()
    }
    
    func dataPointSegmentColor(dataPoint: DYDataPoint)->Color {
        
        if let index = exampleData.firstIndex(where: { (cDataPoint) in
            cDataPoint.id == dataPoint.id
        }) {
           
            let nIndex = index + 1
            
            if nIndex == 1 || nIndex % 3 == 0 {
                return Color.purple
            } else if nIndex % 2 == 0 {
                return Color.red
            } else {
                return Color.green
            }
           
       }
        
        return Color.green
    }
    
}

struct WorkoutTimeExampleLineChart_Previews: PreviewProvider {
    static var previews: some View {
        CustomYAxisIntervalExampleLineChart()
    }
}
