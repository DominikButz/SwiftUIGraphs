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
    @State var selectedBarDataSet: DYBarDataSet?
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                DYBarChartView(barDataSets: barDataSets, selectedBarDataSet: $selectedBarDataSet)
                .barDropShadow(Shadow(color: .gray, radius:8, x:-4, y:-3))
                .selectedBar(borderColor: .purple, dropShadow: Shadow(color: .black.opacity(0.7), radius:10, x:-7, y:-5))
                .yAxisLabelFont(self.font(xAxis: false))
                .markerGridLine(yCoordinate: 0, color: .red)
                .xAxisLabelFont(self.font())
                .frame(height:chartHeight(proxy: proxy))
                
            
                
                if self.barDataSets.isEmpty == false {
                    HStack {
                        self.selectedDataSetDetailView()
                        Spacer()
                    }
                }
                
                Spacer()
            }.padding()

        }.navigationTitle("Profits & Losses Mio. USD per Division per Year")
            .onAppear {
                self.generateExampleData()
            }
    }
    
    #if os(macOS)
    func font(xAxis: Bool = true)-> NSFont {
        let weight : NSFont.Weight = xAxis ? .bold : .regular
        return  NSFont.systemFont(ofSize: 10, weight: weight)
    }
    #else
    func font(xAxis: Bool = true)-> UIFont {
        let weight : UIFont.Weight = xAxis ? .bold : .regular
        let size: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
        return  UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    #endif

    
    func chartHeight(proxy: GeometryProxy)->CGFloat {
        return proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65
    }
    
    func selectedDataSetDetailView()->some View {
        Group {
            if let barDataSet = selectedBarDataSet {
                VStack(alignment: .leading) {
                    
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
                    Text(values[i].toDecimalString(maxFractionDigits: 1)).font(.footnote).lineLimit(1).foregroundColor(.white).eraseToAnyView()
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
