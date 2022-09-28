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
    
    @ObservedObject var dataSet: DYLineDataSet
//    @State var selectedDataPoint: DYDataPoint?
    
    var body: some View {
        
       return  GeometryReader { proxy in
           VStack {
   
                   
                   DYLineInfoView(selectedDataPoint: $dataSet.selectedDataPoint, selectedYValueAsString:  { yValue in
                       TimeInterval(yValue).toString() ?? ""
                   }, selectedXValueAsString: { xValue in
                       Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy")
                   }, minValueLabels: self.minValueLabels, maxValueLabels: self.maxValueLabels)
                   .selectedDataPointLabelSettings(yColor: .blue)

                   
                   DYMultiLineChartView(lineDataSets: [self.dataSet], settings: DYLineChartSettingsNew(xAxisSettings: xAxisSettings, yAxisSettings: yAxisSettings), xValueAsString: {xValue in  Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")}, yValueAsString: { yValue in  TimeInterval(yValue).toString() ?? ""})
                   .frame(height: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.75)
               
//proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65
            Spacer()
         }.padding()
         .navigationTitle("Workout Time Per Week")
//         .onAppear {
//             self.exampleDataSet = createExampleLineDataSet()
//         }
        
       }
        
        

    }
    
//    var selectedValueLabels: (y:Text, x: Text)? {
//        guard let selectedDataPoint = self.exampleDataSets.first?.selectedDataPoint else  {
//            return nil
//        }
//
//        let xString = Date(timeIntervalSinceReferenceDate: selectedDataPoint.xValue).toString(format:"dd-MM-yyyy HH:mm")
//        let yString = TimeInterval(selectedDataPoint.yValue).toString() ?? ""
//        return (y:Text(yString).foregroundColor(.blue).bold(), x:Text(xString).foregroundColor(.gray))
//    }
    
    var minValueLabels: (y: Text, x:Text)? {
        let minX = self.dataSet.xValuesMinMax.min
            
        let minY =  self.dataSet.yValuesMinMax.min
        
        let xString = Date(timeIntervalSinceReferenceDate: minX).toString(format:"dd-MM-yyyy")
        let yString = "Min: " +   (TimeInterval(minY).toString() ?? "")
        return (y:Text(yString).font(.caption).bold(), x:Text(xString).font(.caption).foregroundColor(.gray))
    }
    
    var maxValueLabels: (y: Text, x:Text)? {
        let maxX = self.dataSet.xValuesMinMax.max
        let maxY =  self.dataSet.yValuesMinMax.max
        
        let xString = Date(timeIntervalSinceReferenceDate: maxX).toString(format:"dd-MM-yyyy")
        let yString = "Max: " +  (TimeInterval(maxY).toString() ?? "")
        return (y:Text(yString).font(.caption).bold(), x:Text(xString).font(.caption).foregroundColor(.gray))
    }
    
//    var lineChartSettings: DYLineChartSettings {
//        DYLineChartSettings(lineStrokeStyle: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: .blue, showAppearAnimation: true, showGradient: true, gradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), gradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), lateralPadding: (0, 0), pointColor: .blue, selectorLineColor: .blue, selectorLinePointColor: .blue, allowUserInteraction: true, yAxisSettings:  yAxisSettings, xAxisSettings: xAxisSettings)
//    }
    
    var xAxisSettings: DYLineChartXAxisSettingsNew {
        DYLineChartXAxisSettingsNew(showXAxis: true, xAxisInterval: 604800, xAxisFontSize: fontSize)
    }
    
//    var xAxisGridLineStrokeStyle: StrokeStyle
//    var xAxisGridLineColor: Color
//    var xAxisFontSize: CGFloat
//    var xAxisInterval: Double
    
    var yAxisSettings: YAxisSettingsNew {
        YAxisSettingsNew(showYAxis: true, yAxisPosition: .trailing, yAxisViewWidth: self.yAxisWidth,  yAxisFontSize: fontSize, yAxisMinMaxOverride: (min: 0, max: Double(Int(dataSet.dataPoints.map({$0.yValue}).max() ?? 0).nearest(multipleOf: 1800, up: true))), yAxisIntervalOverride: 1800)
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
        
        if let index = dataSet.dataPoints.firstIndex(where: { (cDataPoint) in
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
    
    func createExampleLineDataSet()->DYLineDataSet {
        var dataPoints:[DYDataPoint] = []
        
        var endDate = Date().add(units: -3, component: .hour)
        
        for _ in 0..<50 {
            let yValue = Int.random(in: 6000 ..< 12000)
            let xValue =  endDate.timeIntervalSinceReferenceDate
            let dataPoint = DYDataPoint(xValue: xValue, yValue: Double(yValue))
            dataPoints.append(dataPoint)
            let randomDayDifference = Int.random(in: 1 ..< 8)
            endDate = endDate.add(units: -randomDayDifference, component: .day)
        }

        return DYLineDataSet(dataPoints: dataPoints, selectedDataPoint: nil, pointView: { _ in
            DYLineDataSet.defaultPointView(color: .blue)
        }, selectorView: DYLineDataSet.defaultSelectorPointView(color: .red),  settings: DYLineSettings(lineColor: .blue,   showAppearAnimation: true, lineAreaGradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), lineAreaGradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), xValueSelectedDataPointLineColor: .red, yValueSelectedDataPointLineColor: .red))
    }
    
//    var lineChartSettings: DYLineChartSettings {
//        DYLineChartSettings(lineStrokeStyle: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: .blue, showAppearAnimation: true, showGradient: true, gradient: LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), gradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), lateralPadding: (0, 0), pointColor: .blue, selectorLineColor: .blue, selectorLinePointColor: .blue, allowUserInteraction: true, yAxisSettings:  yAxisSettings, xAxisSettings: xAxisSettings)
//    }
    
}

//struct WorkoutTimeExampleLineChart_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomYAxisIntervalExampleLineChart()
//    }
//}
