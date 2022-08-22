//
//  TabbedLineCharts.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 22/8/2022.
//

import SwiftUI
import SwiftUIGraphs


struct TabbedLineViews: View {
    @StateObject var viewModel = TabbedLinesViewModel()

    var body: some View {
        
        TabView {
            ForEach(0..<3) {index in
                
                LineChartExampleInTabbedView(viewModel: viewModel, currentIndex: index).tag(index)
                
            }
        }.tabViewStyle(.page)
        
    }
}

struct LineChartExampleInTabbedView: View {
    
    @ObservedObject var viewModel:TabbedLinesViewModel
    var currentIndex: Int

    
    var body: some View {
        return  GeometryReader { proxy in
          VStack {
              DYGridChartHeaderView(title: "Workout Time per Week athlete \(currentIndex + 1)", dataPoints: viewModel.exampleData(), selectedIndex: .constant(0), isLandscape: proxy.size.height < proxy.size.width,  xValueConverter: { (xValue) -> String in
                 return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy HH:mm")
             }, yValueConverter: { (yValue) -> String in
            
                return TimeInterval(yValue).toString() ?? ""
             })
         
              DYLineChartView(dataPoints: self.viewModel.dataPoints, selectedIndex:.constant(0), xValueConverter: { (xValue) -> String in
                 // this is for the x-Axis values - date should be short
                 return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
                 
             }, labelView: nil, yValueConverter: { (yValue) -> String in
                 return TimeInterval(yValue).toString() ?? ""  //{ dataPoint in self.dataPointSegmentColor(dataPoint: dataPoint)}
             }, colorPerPoint: nil, colorPerLineSegment: nil, chartFrameHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65,  settings: lineChartSettings)  // 604800 seconds per week
 //             Button {
 //                 let yValue = Int.random(in: 6000 ..< 12000)
 //                 let xValues = self.exampleData.map{$0.xValue}
 //                 let maxValue = xValues.max()!
 //                 let maxIndex = xValues.firstIndex(where: {$0 == maxValue})!
 //                 let xValue =  self.exampleData[maxIndex].xValue + 86400 * 5 // add 5 days
 //                 let dataPoint = DYDataPoint(xValue: xValue, yValue: Double(yValue))
 //                 withAnimation {
 //                     exampleData.append(dataPoint)
 //                 }
 //             } label: {
 //                 Text("add data")
 //             }

             Spacer()
          }.padding()
          .navigationTitle("Workout Time Per Week")
          .onAppear {

              self.viewModel.updateDataIfNeeded()
              
          }
        }
    }
    
    var color: Color {
        return [.orange, .green, .blue][currentIndex]
    }
    
    var lineChartSettings: DYLineChartSettings {
        DYLineChartSettings(lineStrokeStyle: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0), lineColor: self.color, showAppearAnimation: true, showGradient: true, gradient: LinearGradient(gradient: Gradient(colors: [self.color.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom), gradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7), pointColor: self.color, selectorLineColor: .clear, selectorLinePointColor: .clear, interpolationType: .linear, allowUserInteraction: false, yAxisSettings:  yAxisSettings, xAxisSettings: xAxisSettings)
    }
    
    var xAxisSettings: DYLineChartXAxisSettings {
        DYLineChartXAxisSettings(showXAxis: true, showXAxisDataPointLines: false, xAxisInterval: 604800, xAxisFontSize: fontSize)
    }
    
    var yAxisSettings: YAxisSettings {
        YAxisSettings(showYAxis: true, yAxisPosition: .trailing, yAxisViewWidth: self.yAxisWidth,  yAxisFontSize: fontSize, yAxisMinMaxOverride: (min: 0, max: Double(Int(viewModel.dataPoints.map({$0.yValue}).max() ?? 0).nearest(multipleOf: 1800, up: true))), yAxisIntervalOverride: 1800)
    }
    
    var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
    }
    var yAxisWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 40 : 45
    }
}

//struct TabbedLineCharts_Previews: PreviewProvider {
//    static var previews: some View {
//        LineChartExampleInTabbedView()
//    }
//}

class TabbedLinesViewModel: ObservableObject {
    
    @Published var tabIndex:Int = 0
    var loadedTabs: [Int] = []
    @Published var dataPoints: [DYDataPoint] = []
    
    func updateDataIfNeeded() {
        guard loadedTabs.contains(tabIndex) == false else {
            
            return
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {  // simulating delay from loading data remotely
            self.dataPoints = self.exampleData()

        }
        loadedTabs.append(tabIndex)
    }
    
    func exampleData()-> [DYDataPoint] {
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

        return dataPoints
    }
    
    
}
