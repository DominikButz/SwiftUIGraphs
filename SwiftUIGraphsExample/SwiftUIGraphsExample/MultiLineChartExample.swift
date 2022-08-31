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
    
    @State var blueLineSelectedIndex: Int = 0
    @State var orangeLineSelectedIndex: Int = 0
    @State var greenLineSelectedIndex: Int = 0
    
    @State var exampleData: [DYLineDataSet] = []
    
    var body: some View {
        let selectedIndices = [$blueLineSelectedIndex, $orangeLineSelectedIndex, $greenLineSelectedIndex]
        GeometryReader { proxy in
            VStack {
                DYMultiLineChartView(lineDataSets: self.exampleData, selectedIndices: selectedIndices, plotAreaSettings: DYPlotAreaSettings(xAxisSettings: xAxisSettings), plotAreaHeight: chartHeight(proxy: proxy)) { xValue in
                    self.stringified(value: xValue, allowFloat: false)
                } yValueAsString: { yValue in
                    self.stringified(value:yValue, allowFloat: true)
                }.frame(height: self.chartHeight(proxy: proxy) + 30)
                .padding()
                
                if self.exampleData.isEmpty == false {
                    self.legendView.padding()
                
                }
                Spacer()
            }

        }.navigationTitle("Some Random Data Sets")
            .onAppear {
                self.exampleData = generateExampleData()
            }
    }
    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65
    }
    
    var legendView: some View {
        VStack {
            HStack {
                self.pointViewFor(index: 0)
                Text("X: \(self.stringified(value: self.exampleData[0].dataPoints[blueLineSelectedIndex].xValue, allowFloat: true))")
                Text("Y: \(self.stringified(value: self.exampleData[0].dataPoints[blueLineSelectedIndex].yValue, allowFloat: true))")
                Spacer()
            }

            HStack {
                self.pointViewFor(index: 1)
                Text("X: \(self.stringified(value: self.exampleData[1].dataPoints[orangeLineSelectedIndex].xValue, allowFloat: true))")
                Text("Y: \(self.stringified(value: self.exampleData[1].dataPoints[orangeLineSelectedIndex].yValue, allowFloat: true))")
                Spacer()
            }

            HStack {
                self.pointViewFor(index: 2)
                Text("X: \(self.stringified(value: self.exampleData[2].dataPoints[greenLineSelectedIndex].xValue, allowFloat: true))")
                Text("Y: \(self.stringified(value: self.exampleData[2].dataPoints[greenLineSelectedIndex].yValue, allowFloat: true))")
                Spacer()
            }

     

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
    var yAxisWidth: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 40 : 45
    }
    
    
    // e.g. daily average degrees centigrade on the specified date
    func generateExampleData()->[DYLineDataSet] {
        var dataSets: [DYLineDataSet] = []
        
        for i in 0..<3 {
 
            var dataPoints: [DYDataPoint] = []
            var xValue:Double = 1
            for _ in 0..<12 {
            
                let yValue = Double.random(in: -10...40)
                let dataPoint = DYDataPoint(xValue: xValue, yValue: yValue)
                dataPoints.append(dataPoint)
                xValue += Double.random(in: 0.5...1)
            }
            
            let dataSet = DYLineDataSet(dataPoints: dataPoints, pointView: { _ in
                return self.pointView(index: i)
            }, selectorView: selectorPointView(index: i), settings: DYLineSettings(lineColor: colors[i], interpolationType: .quadCurve, lineAreaGradient: nil, xValueSelectedDataPointLineColor: colors[i], yValueSelectedDataPointLineColor: colors[i]))
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
                Circle().pointStyle(color: colors[index], edgeLength: 12).cornerRadius(6)
                case 1:
                    Rectangle().pointStyle(color: colors[index], edgeLength: 10)
                default:
                self.triangle(edgeLength: 13).pointStyle(color: colors[index], edgeLength: 13)
                    .clipShape(self.triangle(edgeLength: 13))
            }
        }
    }
   

    
    func selectorPointView(index: Int)->AnyView {

        Circle()
            .frame(width: 26, height: 26, alignment: .center)
            .foregroundColor(.red)
            .opacity(0.2)
            .overlay(
                Circle()
                    .fill()
                    .frame(width: 14, height: 14, alignment: .center)
                    .foregroundColor(.red)
            ).eraseToAnyView()
    }
    
    func triangle(edgeLength: CGFloat)->Path {
        
        Path { path in
            path.move(to: CGPoint(x: edgeLength / 2, y: 0))
            path.addLine(to: CGPoint(x: edgeLength, y: edgeLength))
            path.addLine(to: CGPoint(x: 0, y: edgeLength))
            path.closeSubpath()
            
        }
    }
}

extension Shape {
    func pointStyle(color: Color, edgeLength: CGFloat)-> some View {
            self
            .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 80, dash: [], dashPhase: 0))
            .foregroundColor(color)
            .frame(width: edgeLength, height: edgeLength, alignment: .center)
            .background(Color(.systemBackground))
          
    }
}





struct MultiLineChartExample_Previews: PreviewProvider {
    static var previews: some View {
        MultiLineChartExample()
    }
}