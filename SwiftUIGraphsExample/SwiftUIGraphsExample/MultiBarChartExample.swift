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
    let titles = ["Energy", "Pharmaceutical", "Agriculture"]
    @State var barDataSets: [DYBarDataSet] = []
    @State var selectedIndex: Int? 
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                DYStackedBarChartView(barDataSets: barDataSets, selectedIndex: $selectedIndex, settings: DYStackedBarChartSettings(xAxisSettings: DYBarChartXAxisSettings(showXAxis: true, xAxisFontSize: self.fontSize), yAxisSettings: YAxisSettingsNew(yAxisPosition:.leading, yAxisZeroGridLineColor: .red, yAxisFontSize: self.fontSize),  barDropShadow: self.dropShadow), plotAreaHeight: chartHeight(proxy: proxy), yValueAsString: { yValue in
                    return yValue.toDecimalString(maxFractionDigits: 0)
                }).frame(height:chartHeight(proxy: proxy)  + 30)
                
                HStack {
                    self.selectedDataSetDetailView()
                    Spacer()
                }
                
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
    
    var selectedDropShadow: Shadow {
        return Shadow(color: .black.opacity(0.7), radius:10, x:-7, y:-5)
    }
    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65
    }
    
    func selectedDataSetDetailView()->some View {
        Group {
            if let selectedIndex = selectedIndex {
                VStack(alignment: .leading) {
                    
                    let barDataSet = self.barDataSets[selectedIndex]
                    
                    Text(barDataSet.xAxisLabel).font(.callout).bold()
                    HStack {
                        if barDataSet.netValue >= 0 {
                            Text("Net Profit:")
                        } else {
                            Text("Net Loss:").foregroundColor(.red).bold()
                        }
                        Text(abs(barDataSet.netValue).toCurrencyString(maxDigits:1) + " million").foregroundColor(barDataSet.netValue >= 0 ? .primary : .red)
                        Spacer()
                    }
                    
                    VStack(spacing: 0) {
                        ForEach(0..<barDataSet.fractions.count, id:\.self) { i in
                            let fraction = barDataSet.fractions[i]
                            HStack(spacing: 0) {
                                HStack {
                                    Rectangle().fill(colors[i]).frame(width: 15, height: 15)
                                    Text(fraction.title + ": ")
                                    Spacer()
                                }
                                
                                Text(fraction.value.toCurrencyString(maxDigits:1) + " million").foregroundColor(fraction.value >= 0 ? .primary : .red)
                                Spacer()
                            }.font(.callout)
                            
                        }

                    }.transition(AnyTransition.opacity)
                    
                    
                }.frame(maxWidth: 300).padding()
 
            }
        }
    }
    
    
    func generateExampleData() {
        var barDataSets: [DYBarDataSet] = []
        var currentYear = 2012
        
        for _ in 0..<10 {
            let firstValue = Double.random(in: -10 ..< 50)
            let secondValue = Double.random(in: -20 ..< 40)
            let thirdValue = Double.random(in: -30 ..< 30)
            let values = [firstValue, secondValue, thirdValue]
            let xValueLabel = "\(currentYear)"
            var fractions: [DYBarDataFraction] = []
            for i in 0..<values.count {
                let fraction = DYBarDataFraction(value: values[i], title:titles[i], gradient: LinearGradient(colors: [colors[i]], startPoint: .top, endPoint: .bottom)) {
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
