//
//  BasicBarChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 17/2/2021.
//

import SwiftUI
import SwiftUIGraphs

struct BasicBarChartExample: View {
    @State private var selectedBarDataSet: DYBarDataSet?
    @State private var barDataSets: [DYBarDataSet] = []

    var body: some View {
       
        GeometryReader { proxy in
            VStack(alignment: .leading) {
                
                DYStackedBarChartView(barDataSets: barDataSets, selectedBarDataSet: $selectedBarDataSet) { yValue in
                    return yValue.toDecimalString(maxFractionDigits: 0)
                }  //yAxisMinMaxOverride: (min: 200, max:1800)
                .barDropShadow(Shadow(color: .gray, radius:8, x:-4, y:-3))
                .selectedBar(borderColor: .blue)
                .xAxisLabelFontSize(UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10)
                .yAxisPosition(.trailing)
                .yAxisStyle(fontSize: UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10)
                .frame(height: self.chartHeight(proxy: proxy))
                
                self.selectedDataSetView().padding()

                Spacer()
            }.padding()
            .navigationTitle("Weight Lifting Volume per Week (kg)")
            .onAppear{
                self.createBarDataSets()
            }
        }
    }
    
//    DYStackedBarChartSettings(xAxisSettings: DYBarChartXAxisSettings(showXAxis: true, xAxisFontSize: self.fontSize), yAxisSettings: YAxisSettingsNew(yAxisPosition:.trailing, yAxisFontSize: self.fontSize), selectedBarBorderColor: .blue, barDropShadow: self.dropShadow)
    

    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.75
    }
    
    func selectedDataSetView()->some View {
        
        Group {
            if let barDataSet = selectedBarDataSet {
      
                let startDate = barDataSet.xValue!
                let endDate = startDate.advanced(by: 604800)
                VStack(alignment: .leading) {
                    Text("\(Date(timeIntervalSinceReferenceDate: startDate).toString(format:"dd MMM")) - \(Date(timeIntervalSinceReferenceDate: endDate).toString(format:"dd MMM YYYY"))").bold()
                    
                    Text(barDataSet.positiveYValue.toDecimalString(maxFractionDigits: 1) + " kg")
                }
            }
        }
    }
    
    
    func createBarDataSets() {
        var barDataSets: [DYBarDataSet] = []
        var endDate = Date().add(units: -105, component: .day)
        for _ in 0..<14 {
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
