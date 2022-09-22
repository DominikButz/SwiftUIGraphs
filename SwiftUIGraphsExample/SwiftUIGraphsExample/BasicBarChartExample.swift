//
//  BasicBarChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 17/2/2021.
//

import SwiftUI
import SwiftUIGraphs

struct BasicBarChartExample: View {
    @State var selectedDataIndex: Int = 0
    @State private var barDataSets: [DYBarDataSet] = []
    @State var selectedIndex: Int?
    
    var body: some View {
       
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                
                DYStackedBarChartView(barDataSets: barDataSets, selectedIndex: $selectedIndex, settings: DYStackedBarChartSettings(xAxisSettings: DYBarChartXAxisSettings(showXAxis: true, xAxisFontSize: self.fontSize), yAxisSettings: YAxisSettingsNew(yAxisPosition:.trailing, yAxisFontSize: self.fontSize, yAxisMinMaxOverride: (min: 0, max:nil)), selectedBarBorderColor: .blue, barDropShadow: self.dropShadow), chartViewHeight: self.chartHeight(proxy: proxy)) { yValue in
                    return yValue.toDecimalString(maxFractionDigits: 0)
                }.frame(height: self.chartHeight(proxy: proxy))
                
                self.selectedDataSetView().padding()

                Spacer()
            }.padding()
            .navigationTitle("Weight Lifting Volume per Week (kg)")
            .onAppear{
                self.generateExampleData()
            }
        }
    }
    
    var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
    }
    
    var dropShadow: Shadow {
       return Shadow(color: .gray, radius:8, x:-4, y:-3)
    }
    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65
    }
    
    func selectedDataSetView()->some View {
        
        Group {
            if let selectedIndex = selectedIndex {
                let barDataSet = self.barDataSets[selectedIndex]
                let startDate = barDataSet.xValue!
                let endDate = startDate.advanced(by: 604800)
                VStack(alignment: .leading) {
                    Text("\(Date(timeIntervalSinceReferenceDate: startDate).toString(format:"dd MMM")) - \(Date(timeIntervalSinceReferenceDate: endDate).toString(format:"dd MMM YYYY"))").bold()
                    
                    Text(barDataSet.positiveYValue.toDecimalString(maxFractionDigits: 1) + " kg")
                }
            }
        }
    }
    
    
    func generateExampleData() {
        var barDataSets: [DYBarDataSet] = []
        var endDate = Date().add(units: -105, component: .day)
        for _ in 0..<4 {
            let yValue = Double.random(in: 1500 ..< 1940)
           let xValue = endDate.timeIntervalSinceReferenceDate
            let xValueLabel = Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
            
            let dataSet = DYBarDataSet(fractions: [DYBarDataFraction(value: yValue, gradient: LinearGradient(colors: [Color.orange, Color.orange.opacity(0.7)], startPoint: .top, endPoint: .bottom))], xValue: xValue, xAxisLabel: xValueLabel, labelView: { value in
                return Text(value.toDecimalString(maxFractionDigits: 0)).font(.footnote).eraseToAnyView()
            })
            barDataSets.append(dataSet)
            let dayDifference = 7
            endDate = endDate.add(units: dayDifference, component: .day)
        }
        self.barDataSets = barDataSets
    }
    
}

//struct BasicBarChartExample_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicBarChartExample()
//    }
//}
