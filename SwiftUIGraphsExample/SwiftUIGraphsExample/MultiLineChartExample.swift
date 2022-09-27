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
    
    @ObservedObject var blueDataSet: DYLineDataSet
    @ObservedObject var orangeDataSet: DYLineDataSet
    @ObservedObject var greenDataSet: DYLineDataSet
    
    var body: some View {
  
        GeometryReader { proxy in
            VStack {
                DYMultiLineChartView(lineDataSets: [blueDataSet, orangeDataSet, greenDataSet], settings: DYLineChartSettingsNew(xAxisSettings: xAxisSettings), plotAreaHeight: nil) { xValue in
                    self.stringified(value: xValue, allowFloat: false)
                } yValueAsString: { yValue in
                    self.stringified(value:yValue, allowFloat: true)
                }.frame(height: self.chartHeight(proxy: proxy))
                .padding()
                
       
                self.legendView.padding()
                
                
                Spacer()
            }

        }.navigationTitle("Some Random Data Sets")

    }
    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.75
    }
    
    var legendView: some View {

        return HStack(spacing:15) {
            let dataSets = [blueDataSet, orangeDataSet, greenDataSet]
            ForEach(0..<dataSets.count, id:\.self) { i in
                if let dataPoint =  dataSets[i].selectedDataPoint {
                    HStack {
                        self.pointViewFor(index: i)
                        Text("X: \(self.stringified(value: dataPoint.xValue, allowFloat: true))")
                        Text("Y: \(self.stringified(value: dataPoint.yValue, allowFloat: true))")
                        
                    }.font(UIDevice.current.userInterfaceIdiom == .pad ? .body : .caption)
                }
            }
            Spacer()
        }
    }
    
    func stringified(value: Double, allowFloat: Bool)->String {
        let formatter = NumberFormatter()
        formatter.allowsFloats = allowFloat
        formatter.maximumFractionDigits = 1
        return formatter.string(for: value)!
    }
    
    var xAxisSettings: DYLineChartXAxisSettingsNew {
        DYLineChartXAxisSettingsNew(showXAxis: true, xAxisInterval: 1, xAxisFontSize: fontSize)  // seconds per 31 days
        
    }
    
    var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
    }
//    var yAxisWidth: CGFloat {
//        UIDevice.current.userInterfaceIdiom == .phone ? 40 : 45
//    }
    
    
    // e.g. daily average degrees centigrade on the specified date
    func generateExampleData()->[DYLineDataSet] {
        var dataSets: [DYLineDataSet] = []
        
        for i in 0..<3 {
 
            var dataPoints: [DYDataPoint] = []
            var xValue = Double.random(in: 1...1.5)
            for _ in 0..<12 {
            
                let yValue = Double.random(in: -10...40)
                let dataPoint = DYDataPoint(xValue: xValue, yValue: yValue)
                dataPoints.append(dataPoint)
                xValue += Double.random(in: 0.5...1)
            }
            
            let dataSet = DYLineDataSet(dataPoints: dataPoints, selectedDataPoint: nil, pointView: { _ in
                return self.pointView(index: i)
            },  selectorView: DYLineDataSet.defaultSelectorPointView(color:.red),  settings: DYLineSettings(lineColor: colors[i], lineDropShadow: Shadow(color: .gray, radius: 5, x: -5, y: -5), interpolationType: .quadCurve,  xValueSelectedDataPointLineColor: colors[i], yValueSelectedDataPointLineColor: colors[i]))
            //lineAreaGradient: LinearGradient(colors: [colors[i].opacity(0.7), .clear], startPoint: .top, endPoint: .bottom),
            //lineAreaGradientDropShadow: Shadow(color: .gray, radius: 7, x: -7, y: -7),
            dataSets.append(dataSet)
        }
        print("example data blue line x values \(dataSets[0].dataPoints.map({$0.xValue}))")
     //LinearGradient(colors: [colors[i], .white], startPoint: .top, endPoint: .bottom)
        return dataSets
    }
    
    func pointView(index: Int)->AnyView {

        Group {
            self.pointViewFor(index: index)
        }.eraseToAnyView()
    }
    
    func pointViewFor(index: Int)-> some View {
        Group {
            switch index {
                case 0:
                Circle().pointStyle(color: colors[index], edgeLength: 12).cornerRadius(6).background(Color(.systemBackground))
                case 1:
                Rectangle().pointStyle(color: colors[index], edgeLength: 10).background(Color(.systemBackground))
                default:
                Triangle().pointStyle(color: colors[index], edgeLength: 12)
                
            }
        }
    }
   
//    func labelView(dataPoint: DYDataPoint)-> AnyView {
//
//        return Text("Text").font(.caption).foregroundColor(.blue).eraseToAnyView()
//    }
//
//
//    func selectorPointView(index: Int)->AnyView {
//
//        Circle()
//            .frame(width: 26, height: 26, alignment: .center)
//            .foregroundColor(.red)
//            .opacity(0.2)
//            .overlay(
//                Circle()
//                    .fill()
//                    .frame(width: 14, height: 14, alignment: .center)
//                    .foregroundColor(.red)
//            ).eraseToAnyView()
//    }
//

//
//    func dataPointSegmentColor(index: Int)->Color {
//            let nIndex = index + 1
//
//            if nIndex == 1 || nIndex % 3 == 0 {
//                return Color.purple
//            } else if nIndex % 2 == 0 {
//                return Color.red
//            } else {
//                return Color.green
//            }
//
//    }
    

}

//struct MultiLineChartExample_Previews: PreviewProvider {
//    static var previews: some View {
//        if #available(iOS 15.0, *) {
//            MultiLineChartExample()
//                .previewInterfaceOrientation(.portrait)
//        } else {
//            MultiLineChartExample()
//        }
//    }
//}
