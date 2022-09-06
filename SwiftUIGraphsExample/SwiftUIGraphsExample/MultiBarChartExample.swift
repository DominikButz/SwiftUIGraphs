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
                DYStackedBarChartView(barDataSets: barDataSets, settings: DYStackedBarChartSettings(xAxisSettings: DYBarChartXAxisSettings(showXAxis: true, xAxisFontSize: self.fontSize), yAxisSettings: YAxisSettingsNew(yAxisPosition:.trailing, yAxisZeroGridLineColor: .red, yAxisFontSize: self.fontSize),  barDropShadow: self.dropShadow),  plotAreaHeight: chartHeight(proxy: proxy), yValueAsString: { yValue in
                    return yValue.toDecimalString(maxFractionDigits: 0)
                }).frame(height:chartHeight(proxy: proxy)  + 30)
                

                VStack(alignment: .leading, spacing: 5) {
                    MultiSeriesLegendView(legendItems: [LegendItem(colorSymbol: Rectangle().fill(.blue).frame(width: 20, height: 20), title: "Energy"), LegendItem(colorSymbol: Rectangle().fill(.orange).frame(width: 20, height: 20), title: "Pharmaceutical"), LegendItem(colorSymbol: Rectangle().fill(.green).frame(width: 20, height: 20), title: "Agriculture")])
                  
                }.padding()
                Spacer()
            }

        }.navigationTitle("Profits & Losses Mio. USD per Division per Year")
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
       var currentYear = 2012
        let colors = [Color.blue, Color.orange, Color.green]
        
        for _ in 0..<10 {
            let firstValue = Double.random(in: -30 ..< 30)
            let secondValue = Double.random(in: -30 ..< 30)
            let thirdValue = Double.random(in: -30 ..< 30)
            let values = [firstValue, secondValue, thirdValue]
            let xValueLabel = "\(currentYear)"
            var fractions: [DYBarDataFraction] = []
            for i in 0..<values.count {
                let fraction = DYBarDataFraction(value: values[i], gradient: LinearGradient(colors: [colors[i], colors[i].opacity(0.7)], startPoint: .top, endPoint: .bottom)) {
                    Text(values[i].toDecimalString(maxFractionDigits: 1)).font(.footnote).foregroundColor(.white).eraseToAnyView()
                }
                fractions.append(fraction)
            }
            
            let dataSet = DYBarDataSet(fractions: fractions, xAxisLabel: xValueLabel, labelView: { value in
                let text = value != 0 ? value.toDecimalString(maxFractionDigits: 1) : ""
                return Text(text).font(.footnote).eraseToAnyView()
            })
            barDataSets.append(dataSet)

            currentYear += 1
        }
        self.barDataSets = barDataSets
    }
}



struct MultiBarChartExample_Previews: PreviewProvider {
    static var previews: some View {
        MultiBarChartExample()
    }
}
