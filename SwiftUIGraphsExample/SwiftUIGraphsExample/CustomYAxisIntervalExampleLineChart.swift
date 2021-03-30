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
    
    var body: some View {
        let exampleData = DYDataPoint.exampleData0
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
                
            }, yValueConverter: { (yValue) -> String in
       
                return TimeInterval(yValue).toString() ?? ""
            }, chartFrameHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65,  settings: DYLineChartSettings(lineColor: .blue, gradient: LinearGradient(gradient: Gradient(colors: [.blue, Color.white]), startPoint: .top, endPoint: .bottom), pointColor: .blue, selectorLineColor: .blue, selectorLinePointColor: .blue, yAxisSettings: YAxisSettings(showYAxis: true, yAxisPosition: .trailing, yAxisViewWidth: self.yAxisWidth, yAxisFontSize: fontSize, yAxisMinMaxOverride: (min: 0, max: Double(Int(exampleData.map({$0.yValue}).max() ?? 0).nearest(multipleOf: 1800, up: true))), yAxisIntervalOverride: 1800), xAxisSettings: DYLineChartXAxisSettings(showXAxis: true, xAxisInterval: 604800, xAxisFontSize: fontSize)))  // 604800 seconds per week
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
}

struct WorkoutTimeExampleLineChart_Previews: PreviewProvider {
    static var previews: some View {
        CustomYAxisIntervalExampleLineChart()
    }
}
