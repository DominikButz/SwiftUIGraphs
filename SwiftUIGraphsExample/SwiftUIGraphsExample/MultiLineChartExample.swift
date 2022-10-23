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
    @State private var dataPointArrays: Array<[DYDataPoint]> = []
    
    @State private var blueSelectedDataPoint: DYDataPoint?
    @State private var orangeSelectedDataPoint: DYDataPoint?
    @State private var greenSelectedDataPoint: DYDataPoint?

    var body: some View {
  
        GeometryReader { proxy in
            VStack {
                
                DYMultiLineChartView(allDataPoints: Array(self.dataPointArrays.joined())) { parentProps in
                    let selectedPoints = [$blueSelectedDataPoint, $orangeSelectedDataPoint, $greenSelectedDataPoint]
                    ForEach(0..<dataPointArrays.count, id:\.self) { i in
                        
                        DYLineView(dataPoints: dataPointArrays[i], selectedDataPoint: selectedPoints[i], pointView: { _ in
                            self.pointViewFor(index: i)
                        }, selectorView: self.selectorPointViewFor(index: i), parentViewProperties: parentProps)
                        .lineStyle(color: colors[i])
                        .selectedPointIndicatorLineStyle(xLineColor: colors[i], yLineColor: colors[i])
                        
                    }
              
                    
                } xValueAsString: { xValue in
                    self.stringified(value: xValue, allowFloat: false)
                } yValueAsString: { yValue in
                    self.stringified(value:yValue, allowFloat: true)
                }
                .yAxisStyle(fontSize: UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10, zeroGridLineColor: .red)
                .xAxisStyle(fontSize: UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10)
                .frame(height: self.chartHeight(proxy: proxy))
                .padding()
                

                 

                self.legendView.padding()
                
                
                Spacer()
            }

        }.navigationTitle("Some Random Data Sets")
            .onAppear {
                generateDataPoints()
            }

    }
    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.75
    }
    
    var legendView: some View {

        return HStack(spacing:15) {
            let selectedPoints = [blueSelectedDataPoint, orangeSelectedDataPoint, greenSelectedDataPoint]
            ForEach(0..<selectedPoints.count, id:\.self) { i in
                if let dataPoint =  selectedPoints[i] {
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
    
    
    func generateDataPoints() {
        var dataPointArrays: Array<[DYDataPoint]> = []
        for _ in 0..<3 {
            
            var dataPoints: [DYDataPoint] = []
            var xValue = Double.random(in: 1...1.5)
            for _ in 0..<12 {
                
                let yValue = Double.random(in: -10...40)
                let dataPoint = DYDataPoint(xValue: xValue, yValue: yValue)
                dataPoints.append(dataPoint)
                xValue += Double.random(in: 0.5...1)
            }
            dataPointArrays.append(dataPoints)
        }
        self.dataPointArrays = dataPointArrays
    }
    

    
    func pointViewFor(index: Int)-> some View {
        Group {
            switch index {
                case 0:
                DYLinePointView(borderColor: colors[index])
           
                case 1:
                DYLinePointView(shape: Rectangle(), borderColor: colors[index], edgeLength: 10)
          
                default:
                DYLinePointView(shape: Triangle(), borderColor: colors[index])
                
            }
        }
    }
    
    func selectorPointViewFor(index: Int)-> some View {
        Group {
            switch index {
                case 0:
                DYSelectorPointView()
                case 1:
                DYSelectorPointView(shape: Rectangle(), shapeSize: 12, shapeHaloSize: 24)
                default:
                DYSelectorPointView(shape: Triangle(), haloOffset: CGSize(width: 0, height: -14 / 6))
                
            }
        }
    }
    

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
