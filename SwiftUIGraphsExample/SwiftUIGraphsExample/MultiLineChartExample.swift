//
//  MultiLineChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 22/8/2022.
//

import SwiftUI
import SwiftUIGraphs

struct MultiLineChartExample: View {
    
    let colors: [Color] = [.blue, .orange, .green]
    
    var body: some View {
        GeometryReader { proxy in
            DYMultiLineChartView(lineDataSets: self.exampleData0, plotAreaSettings: DYPlotAreaSettings(xAxisSettings: xAxisSettings), plotAreaHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65) { xValue in
                return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"M")
            } yValueAsString: { yValue in
                let formatter = NumberFormatter()
                formatter.allowsFloats = true
                formatter.maximumFractionDigits = 1
                return formatter.string(for: yValue)!
            }.padding()

        }.navigationTitle("Degrees centigrade 1st day per month 2021-2022")
    }
    
    var xAxisSettings: DYLineChartXAxisSettingsNew {
        DYLineChartXAxisSettingsNew(showXAxis: true, xAxisInterval: 2678400, xAxisFontSize: fontSize)  // seconds per 31 days
        
    }
    
    var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
    }
    var yAxisWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 40 : 45
    }
    
    
    // e.g. daily average degrees centigrade on the specified date
    var exampleData0: [DYLineDataSet] {
        var dataSets: [DYLineDataSet] = []
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        
    
        
        for i in 0..<3 {
            var date = formatter.date(from: "2021/07/01 10:00")!
            var dataPoints: [DYDataPoint] = []
            for _ in 0..<13 {
                date = date.add(units: 1, component: .month)
                let xValue = date.timeIntervalSince1970
                let yValue = Double.random(in: -10...40)
                let dataPoint = DYDataPoint(xValue: xValue, yValue: yValue)
                dataPoints.append(dataPoint)
            }
            
            let dataSet = DYLineDataSet(dataPoints: dataPoints, selectedIndex: .constant(0), pointView: { _ in
                return self.pointView(index: i)
            }, selectorView: selectorPointView(index: i), settings: DYLineSettings(lineColor: colors[i]))
            dataSets.append(dataSet)
        }
     
        return dataSets
    }
    
    func pointView(index: Int)->AnyView {
        Rectangle()
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
            .frame(width: 10, height: 10, alignment: .center)
            .foregroundColor(colors[index])
            .background(Color(.systemBackground))
            .eraseToAnyView()
    }
    
    func selectorPointView(index: Int)->AnyView {
        Circle()
            .frame(width: 24, height: 24, alignment: .center)
            .foregroundColor(colors[index])
            .opacity(0.2)
            .overlay(
                Circle()
                    .fill()
                    .frame(width: 12, height: 12, alignment: .center)
                    .foregroundColor(colors[index])
            ).eraseToAnyView()
    }
}

struct MultiLineChartExample_Previews: PreviewProvider {
    static var previews: some View {
        MultiLineChartExample()
    }
}
