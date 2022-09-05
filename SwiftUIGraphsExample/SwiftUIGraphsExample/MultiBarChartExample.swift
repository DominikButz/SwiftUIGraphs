//
//  MultiBarChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/9/2022.
//

import SwiftUI
import SwiftUIGraphs

struct MultiBarChartExample: View {
    
    let colors: [Color] = [.blue, .orange, .green]
    @State var barDataSets: [DYBarDataSet] = []
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                DYStackedBarChartView(barDataSets: barDataSets, settings: DYStackedBarChartSettings(xAxisSettings: DYBarChartXAxisSettings(showXAxis: true, xAxisFontSize: self.fontSize), yAxisSettings: YAxisSettingsNew(yAxisPosition:.trailing, yAxisFontSize: self.fontSize)), plotAreaHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65) { yValue in
                    return yValue.toDecimalString(maxFractionDigits: 0)
                }
                Spacer()
            }

        }.navigationTitle("Some Random Data Sets")
            .onAppear {
                self.generateExampleData()
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
    
    
    func generateExampleData() {
        var barDataSets: [DYBarDataSet] = []
        var endDate = Date().add(units: -3, component: .hour)
        for _ in 0..<10 {
            let yValue = Double.random(in: -100 ..< 100)
            print("var yValue: \(yValue)")
            let xValueLabel = Date(timeIntervalSinceReferenceDate: endDate.timeIntervalSinceReferenceDate).toString(format:"dd-MM")
            
            let dataSet = DYBarDataSet(fractions: [DYBarDataFraction(value: yValue, gradient: LinearGradient(colors: [Color.orange, Color.orange.opacity(0.7)], startPoint: .top, endPoint: .bottom))], xAxisLabel: xValueLabel)
            barDataSets.append(dataSet)
            let randomDayDifference = Int.random(in: 1 ..< 8)
            endDate = endDate.add(units: -randomDayDifference, component: .day)
        }
        self.barDataSets = barDataSets
    }
}

struct MultiBarChartExample_Previews: PreviewProvider {
    static var previews: some View {
        MultiBarChartExample()
    }
}
