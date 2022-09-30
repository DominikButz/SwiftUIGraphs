//
//  ContentView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI
import SwiftUIGraphs


struct ContentView: View {

    @State private var linkActive: Bool = true
    let colors: [Color] = [.blue, .orange, .green]
    
    var body: some View {
        let multiLineDataSets = self.multiLineDataSets()
        NavigationView {
            List {
                Section(header: HStack {
                    Image(systemName: "waveform.path")
                    Text("Line Charts")
                }) {
                   // NavigationLink("Weight Lifting Volume per Workout", destination: BasicLineChartExample())
                    NavigationLink("Stock Prices (asyn data fetch)", destination: LineChartWithAsyncDataFetch())
                    NavigationLink("Area Chart Example", destination: CustomYAxisIntervalExampleLineChart(dataSet: self.areaLineChartDataSet()))
                    NavigationLink("Multi-Line Example", destination: MultiLineChartExample(blueDataSet: multiLineDataSets[0], orangeDataSet: multiLineDataSets[1], greenDataSet: multiLineDataSets[2]), isActive: $linkActive)
                }
         
                Section(header: HStack{
                    Image(systemName: "chart.bar.fill")
                    Text("Bar Charts")
                }) {
                    NavigationLink("Basic Example", destination: BasicBarChartExample())
                    NavigationLink("Multi-Bar Example", destination: MultiBarChartExample())
                }
                
                Section(header: HStack{
                    Image(systemName: "chart.pie.fill")
                    Text("Pie Charts")
                }) {
                    NavigationLink("Av. US Household Spending", destination: BasicPieChartExample())
                    NavigationLink("Sales per Country", destination: RingChartAndDetailPieChartExample())
                }

            }.navigationBarTitle("SwiftUIGraphs Examples", displayMode: .inline).padding()
            
            // add the first destination view in the list one more time as default for iPad in split view mode, otherwise the detail view will be empty
            if UIDevice.current.userInterfaceIdiom == .pad {
                LineChartWithAsyncDataFetch()
            }
        }


    }
    
    func areaLineChartDataSet()->DYLineDataSet {
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
    
    //LinearGradient(gradient: Gradient(colors: [.blue.opacity(0.7), Color.white.opacity(0.6)]), startPoint: .top, endPoint: .bottom)
    
    // Multi Line example
    func multiLineDataSets()->[DYLineDataSet] {
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
       // print("example data blue line x values \(dataSets[0].dataPoints.map({$0.xValue}))")
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
                Circle().pointStyle(color: colors[index], edgeLength: 12).cornerRadius(6).background(Color(.systemBackground)).clipShape(Circle())
                case 1:
                    Rectangle().pointStyle(color: colors[index], edgeLength: 10).background(Color(.systemBackground))
                default:
                Triangle().pointStyle(color: colors[index], edgeLength: 13).background(Color(.systemBackground)).clipShape(Triangle())
                    
            }
        }
    }
   
//    func labelView(dataPoint: DYDataPoint)-> AnyView {
//
//        return Text("Text").font(.caption).foregroundColor(.blue).eraseToAnyView()
//    }

    
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

struct Triangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.width / 2, y: 0))
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
            
        }
    }
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().colorScheme(.light)
    }
}
