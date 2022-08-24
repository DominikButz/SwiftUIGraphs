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
                DYMultiLineChartView(lineDataSets: self.exampleData, selectedIndices: selectedIndices, plotAreaSettings: DYPlotAreaSettings(xAxisSettings: xAxisSettings), plotAreaHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65) { xValue in
                    self.stringified(value: xValue, allowFloat: false)
                } yValueAsString: { yValue in
                    self.stringified(value:yValue, allowFloat: true)
                }
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
    
    var legendView: some View {
        VStack {
            HStack {
                Text("Blue xValue: \(self.stringified(value: self.exampleData[0].dataPoints[blueLineSelectedIndex].xValue, allowFloat: true))")
                Text("Blue yValue: \(self.stringified(value: self.exampleData[0].dataPoints[blueLineSelectedIndex].yValue, allowFloat: true))")
                Spacer()
            }

            HStack {
                Text("Orange xValue: \(self.stringified(value: self.exampleData[1].dataPoints[orangeLineSelectedIndex].xValue, allowFloat: true))")
                Text("Orange yValue: \(self.stringified(value: self.exampleData[1].dataPoints[orangeLineSelectedIndex].yValue, allowFloat: true))")
                Spacer()
            }

            HStack {
                Text("Green xValue: \(self.stringified(value: self.exampleData[2].dataPoints[greenLineSelectedIndex].xValue, allowFloat: true))")
                Text("Green yValue: \(self.stringified(value: self.exampleData[2].dataPoints[greenLineSelectedIndex].yValue, allowFloat: true))")
                Spacer()
            }

     

        }.background(Color.gray)
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
            }, selectorView: selectorPointView(index: i), settings: DYLineSettings(lineColor: colors[i], interpolationType: .quadCurve, lineAreaGradient: nil))
            dataSets.append(dataSet)
        }
     //LinearGradient(colors: [colors[i], .white], startPoint: .top, endPoint: .bottom)
        return dataSets
    }
    
    func pointView(index: Int)->AnyView {

        Group {
            self.pointViewFor(index: index, edgeLength: 10)
        }.eraseToAnyView()
    }
    
    func pointViewFor(index: Int, edgeLength: CGFloat)-> some View {
        Group {
            switch index {
                case 0:
                Circle().pointStyle(color: colors[index], edgeLength: edgeLength).cornerRadius(edgeLength / 2)
                case 1:
                    Rectangle().pointStyle(color: colors[index], edgeLength: edgeLength)
                default:
                self.triangle(edgeLength: edgeLength).pointStyle(color: colors[index], edgeLength: edgeLength).clipShape(self.triangle(edgeLength: edgeLength))
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
