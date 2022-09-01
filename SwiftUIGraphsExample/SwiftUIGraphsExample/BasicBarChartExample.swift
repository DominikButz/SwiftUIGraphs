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
    
    let exampleData = DYDataPoint.exampleData1.sorted(by: {$0.xValue < $1.xValue})
    
    var body: some View {
       
        GeometryReader { proxy in
            VStack {
                DYGridChartHeaderView(title: "Weight Volume (KG)", dataPoints: exampleData, selectedIndex: self.$selectedDataIndex, selectedYValueTextColor: Color.green, isLandscape: proxy.size.height < proxy.size.width, xValueConverter: { (xValue) -> String in
                    return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM-yyyy HH:mm")
                }, yValueConverter: { (yValue) -> String in
                    return  yValue.toDecimalString(maxFractionDigits: 1) + " KG"
                })
                
                DYBarChartView(dataPoints: exampleData, selectedIndex: $selectedDataIndex, labelView: {dataPoint in self.labelView(dataPoint: dataPoint)}, xValueConverter: { (xValue) -> String in
                    return Date(timeIntervalSinceReferenceDate: xValue).toString(format:"dd-MM")
                }, yValueConverter: { (yValue) -> String in
                    return  yValue.toDecimalString(maxFractionDigits: 0)
                }, chartFrameHeight: proxy.size.height > proxy.size.width ? proxy.size.height * 0.4 : proxy.size.height * 0.65, settings: DYBarChartSettings(selectedBarGradient: LinearGradient(colors: [.green, .green.opacity(0.8)], startPoint: .top, endPoint: .bottom), lateralPadding: (0, 0), barDropShadow: self.dropShadow, showSelectionIndicator: false, selectionIndicatorColor: .green, yAxisSettings: YAxisSettings(yAxisPosition: .trailing, yAxisFontSize: fontSize, yAxisMinMaxOverride: (min:0, max:nil)), xAxisSettings: DYBarChartXAxisSettings(showXAxis: true, xAxisFontSize: fontSize)))
                
                Spacer()
            }.padding()
            .navigationTitle("Weight Lifting Volume")
        }
    }
    
    var fontSize: CGFloat {
        UIDevice.current.userInterfaceIdiom == .phone ? 8 : 10
    }
    
    var dropShadow: Shadow {
       return Shadow(color: .gray, radius:8, x:-4, y:-3)
    }
    
    func labelView(dataPoint: DYDataPoint)-> AnyView {
        
        let yValue = dataPoint.yValue
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        var color: Color?
        if let index = self.exampleData.firstIndex(where: {$0.id == dataPoint.id}), index == self.selectedDataIndex {
            color = .green
        }
        return Text(formatter.string(for: yValue) ?? "").font(.caption).foregroundColor(color).eraseToAnyView()
    }
    
    func gradientPerBar(_ dataPoint: DYDataPoint)->LinearGradient {
        
        let index = exampleData.firstIndex(where: { (cDataPoint) in
            cDataPoint.id == dataPoint.id
        })!
        
        let nIndex = index + 1
        
        if nIndex == 1 || nIndex % 3 == 0 {
            return LinearGradient(gradient: Gradient(colors: [Color.purple, Color.purple.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
        } else if nIndex % 2 == 0 {
            return LinearGradient(gradient: Gradient(colors: [Color.red, Color.red.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
        } else {
            return LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
        }

    }
    
}

//struct BasicBarChartExample_Previews: PreviewProvider {
//    static var previews: some View {
//        BasicBarChartExample()
//    }
//}
