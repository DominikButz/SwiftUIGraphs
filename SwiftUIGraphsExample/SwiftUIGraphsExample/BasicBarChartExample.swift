//
//  BasicBarChartExample.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 17/2/2021.
//

import SwiftUI
import SwiftUIGraphs

struct BasicBarChartExample: View {
    @State private var selectedDataIndex: Int = 0
    
    var body: some View {
        let exampleData = DYDataPoint.exampleData1
        GeometryReader { proxy in
            VStack {
                DYGridChartHeaderView(title: "Workout Volume (KG)", dataPoints: exampleData, selectedIndex: self.$selectedDataIndex, isLandscape: proxy.size.height < proxy.size.width, xValueConverter: { (xValue) -> String in
                    return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy HH:mm")
                }, yValueConverter: { (yValue) -> String in
                    return  yValue.toDecimalString(maxFractionDigits: 1) + " KG"
                })
                
                DYBarChartView(dataPoints: exampleData, selectedIndex: $selectedDataIndex, xValueConverter: { (xValue) -> String in
                    return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
                }, yValueConverter: { (yValue) -> String in
                    return  yValue.toDecimalString(maxFractionDigits: 0)
                }, chartFrameHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65, settings: DYBarChartSettings(yAxisSettings: YAxisSettings(yAxisPosition: .trailing, yAxisMinMaxOverride: (min:0, max:nil)), xAxisSettings: BarChartXAxisSettings()))
                
                Spacer()
            }.padding()
            .navigationTitle("Workout Volume")
        }
    }
}

//struct BasicBarChartExample_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicBarChartExample()
//    }
//}
