//
//  WorkoutTimeExampleLineChart.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 13/2/2021.
//

import SwiftUI
import SwiftUIGraphs

struct CustomYAxisIntervalExampleLineChart: View {
    
   //  @State private var selectedDataIndex: Int = 0

    @State var selectedDataPoint: DYDataPoint?
    @State var dataPoints: [DYDataPoint] = []
    
    var body: some View {
        
       return  GeometryReader { proxy in
           VStack {
   
                   
                   DYLineInfoView(selectedDataPoint: $selectedDataPoint, selectedYValueAsString:  { yValue in
                       TimeInterval(yValue).toString() ?? ""
                   }, selectedXValueAsString: { xValue in
                       Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy")
                   }, minValueLabels: self.minValueLabels, maxValueLabels: self.maxValueLabels)
                   .selectedDataPointLabelSettings(yColor: .blue)

                   
               DYMultiLineChartView(allDataPoints: self.dataPoints, lineViews: { parentViewProperties in
                   
        
                       DYLineView(dataPoints: self.dataPoints, selectedDataPoint: $selectedDataPoint, pointView: { _ in
                           DYLinePointView(borderColor: .blue)
                       }, selectorView: DYSelectorPointView(),  parentViewProperties: parentViewProperties)
                       .lineStyle(color: .blue)
                       .area(gradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), shadow: Shadow(color: .gray, radius: 7, x: -7, y: -7))
                       .selectedPointIndicatorLineStyle(xLineColor: .red, yLineColor: .red)
                   
                   
               }, xValueAsString: {xValue in  Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")}, yValueAsString: { yValue in  TimeInterval(yValue).toString() ?? ""})
               .yAxisScalerOverride(minMax:  (min: 0, max: Double(Int(dataPoints.map({$0.yValue}).max() ?? 0).nearest(multipleOf: 1800, up: true))), interval: 1800)  // 1800 seconds = 30 min
               .yAxisPosition(.trailing)
               .yAxisViewWidth(UIDevice.current.userInterfaceIdiom == .phone ? 40 : 45)
               .yAxisStyle(fontSize:  UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10)
               .xAxisScalerOverride(minMax: (min: self.dataPoints.map({$0.xValue}).min(), max: self.dataPoints.map({$0.xValue}).max()), interval: 604800)  // 604800 seconds per week
                .frame(height: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.75)
               
                  
//               var yAxisSettings: YAxisSettingsNew {
//                   YAxisSettingsNew(showYAxis: true, yAxisPosition: .trailing, yAxisViewWidth: self.yAxisWidth,  yAxisFontSize: fontSize, yAxisMinMaxOverride: (min: 0, max: Double(Int(dataPoints.map({$0.yValue}).max() ?? 0).nearest(multipleOf: 1800, up: true))), yAxisIntervalOverride: 1800)
//               }
               
               
//proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65
            Spacer()
         }.padding()
         .navigationTitle("Workout Time Per Week")
         .onAppear {
             self.dataPoints = createDataPoints()
         }
        
       }
        
        

    }
    
    func createDataPoints()->[DYDataPoint]{
        var dataPoints:[DYDataPoint] = []
        
        var endDate = Date().add(units: -3, component: .hour)
        
        for _ in 0..<50 {
            let yValue = Int.random(in: 6000 ..< 12000)
            let xValue =  endDate.timeIntervalSinceReferenceDate
            let dataPoint = DYDataPoint(xValue: xValue, yValue: Double(yValue))
            dataPoints.append(dataPoint)
//            let randomDayDifference = Int.random(in: 1 ..< 8)
            let dayDifference = 7
            endDate = endDate.add(units: -dayDifference, component: .day)
        }
        
        return dataPoints

//        return DYLineDataSet(dataPoints: dataPoints, selectedDataPoint: nil, pointView: { _ in
//            DYLineDataSet.defaultPointView(color: .blue)
//        }, selectorView: DYLineDataSet.defaultSelectorPointView(color: .red),  settings: DYLineSettings(lineColor: .blue,   showAppearAnimation: true, lineAreaGradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), lineAreaGradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), xValueSelectedDataPointLineColor: .red, yValueSelectedDataPointLineColor: .red))
    }
    

    
    var minValueLabels: (y: Text, x:Text)? {
    
        let minY =  self.dataPoints.map({$0.yValue}).min() ?? 0
        let minYDataPoint = self.dataPoints.filter({$0.yValue == minY}).first
        
        let xString = Date(timeIntervalSinceReferenceDate: minYDataPoint?.xValue ?? 0).toString(format:"dd-MM-yyyy")
        let yString = "Min: " +   (TimeInterval(minY).toString() ?? "")
        return (y:Text(yString).font(.caption).bold(), x:Text(xString).font(.caption).foregroundColor(.gray))
    }
    
    var maxValueLabels: (y: Text, x:Text)? {
   
        let maxY =  self.dataPoints.map({$0.yValue}).max() ?? 0
        let maxYDataPoint = self.dataPoints.filter({$0.yValue == maxY}).first
        
        let xString = Date(timeIntervalSinceReferenceDate: maxYDataPoint?.xValue ?? 0).toString(format:"dd-MM-yyyy")
        let yString = "Max: " +  (TimeInterval(maxY).toString() ?? "")
        return (y:Text(yString).font(.caption).bold(), x:Text(xString).font(.caption).foregroundColor(.gray))
    }
    
//    var lineChartSettings: DYLineChartSettings {
//        DYLineChartSettings(lineStrokeStyle: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: .blue, showAppearAnimation: true, showGradient: true, gradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), gradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), lateralPadding: (0, 0), pointColor: .blue, selectorLineColor: .blue, selectorLinePointColor: .blue, allowUserInteraction: true, yAxisSettings:  yAxisSettings, xAxisSettings: xAxisSettings)
//    }
    
//    var xAxisSettings: DYLineChartXAxisSettingsNew {
//        DYLineChartXAxisSettingsNew(showXAxis: true, xAxisInterval: 604800, xAxisFontSize: fontSize)
//    }
    

    
    func labelView(dataPoint: DYDataPoint)-> AnyView {
        
        return Text("Text").font(.caption).foregroundColor(.blue).eraseToAnyView()
    }
    
    func dataPointSegmentColor(dataPoint: DYDataPoint)->Color {
        
        if let index = dataPoints.firstIndex(where: { (cDataPoint) in
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
    
//    func createExampleLineDataSet()->DYLineDataSet {
//        var dataPoints:[DYDataPoint] = []
//        
//        var endDate = Date().add(units: -3, component: .hour)
//        
//        for _ in 0..<50 {
//            let yValue = Int.random(in: 6000 ..< 12000)
//            let xValue =  endDate.timeIntervalSinceReferenceDate
//            let dataPoint = DYDataPoint(xValue: xValue, yValue: Double(yValue))
//            dataPoints.append(dataPoint)
//            let randomDayDifference = Int.random(in: 1 ..< 8)
//            endDate = endDate.add(units: -randomDayDifference, component: .day)
//        }
//
//        return DYLineDataSet(dataPoints: dataPoints, selectedDataPoint: nil, pointView: { _ in
//            DYLineDataSet.defaultPointView(color: .blue)
//        }, selectorView: DYLineDataSet.defaultSelectorPointView(color: .red),  settings: DYLineSettings(lineColor: .blue,   showAppearAnimation: true, lineAreaGradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), lineAreaGradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), xValueSelectedDataPointLineColor: .red, yValueSelectedDataPointLineColor: .red))
//    }
    
//    var lineChartSettings: DYLineChartSettings {
//        DYLineChartSettings(lineStrokeStyle: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: .blue, showAppearAnimation: true, showGradient: true, gradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), gradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), lateralPadding: (0, 0), pointColor: .blue, selectorLineColor: .blue, selectorLinePointColor: .blue, allowUserInteraction: true, yAxisSettings:  yAxisSettings, xAxisSettings: xAxisSettings)
//    }
    
}

//struct WorkoutTimeExampleLineChart_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomYAxisIntervalExampleLineChart()
//    }
//}
