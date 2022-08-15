//
//  DYLegendView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI

/// DYGridChartHeaderView. header view for DYBarChart and DYLineChart
public struct DYGridChartHeaderView: View {

    let title: String
    var dataPoints: [DYDataPoint]
    var xValueConverter: (Double)->String
    var yValueConverter:  (Double)->String
    var selectedYValueTextColor: Color?
    @Binding var selectedIndex: Int
    var isLandscape: Bool
    
    /// DYGridChartHeaderView
    /// - Parameters:
    ///   - title: title of the header view
    ///   - dataPoints: array of DYDataPoints
    ///   - selectedIndex: index of the selected DYDataPoint
    ///   - isLandscape: set to true if the parent view is in landscape mode. Determines where the maximum value subview will be displayed.
    ///   - xValueConverter: implement a logic to convert the double x-value to a string.
    ///   - yValueConverter: implement a logic to convert the double y-value to a string.
    public init(title: String, dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, selectedYValueTextColor: Color? = nil, isLandscape: Bool,  xValueConverter: @escaping (Double)->String, yValueConverter: @escaping (Double)->String) {
        self.title = title
        let sortedData = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.dataPoints = sortedData
        self._selectedIndex = selectedIndex
        self.selectedYValueTextColor = selectedYValueTextColor
        self.isLandscape = isLandscape
        self.xValueConverter = xValueConverter
        self.yValueConverter = yValueConverter
    }
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
           
            HStack {
                Text(title).font(.headline)
                Spacer()
            }
            if self.dataPoints.count >= 2 {
                Group {
                    if self.isLandscape == false  {
                        self.maximumValueView
                        Divider()
                    }
                    
                    HStack {
                        if selectedIndex >= 0 && selectedIndex <= self.dataPoints.count {
                            Text(yValueConverter(dataPoints[selectedIndex].yValue)).font(.body).foregroundColor(self.selectedYValueTextColor).bold()
                            Text(xValueConverter(dataPoints[selectedIndex].xValue)).foregroundColor(.secondary)
                        }
                        if self.isLandscape {
                            Text(" | ")
                            self.maximumValueView
                        }
                        
                        Spacer()
                    }
                }.transition(AnyTransition.opacity)
            }
            
        }
  
    }
    
    var maximumValueView: some View {
        Group {
            if let maxDataPoint = self.maxDataPoint {
                    HStack {
                        Text("Maximum").bold()
                        Text(yValueConverter(maxDataPoint.yValue)).bold()
                        Text(xValueConverter(maxDataPoint.xValue)).foregroundColor(.secondary)
                        Spacer()
                    }
                    .font(.footnote)
                
            }
        }
    }
    
    var maxDataPoint: DYDataPoint? {
        guard self.dataPoints.count > 0 else {return nil}
        
        let yValues = dataPoints.map({$0.yValue})
        guard let maxY = yValues.max() else {return nil}
        
        if let index = yValues.indices.first(where: {yValues[$0] == maxY}) {
            return dataPoints[index]
        } else {return  nil}
        
    }
    
}

struct DYChartHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        DYGridChartHeaderView(title: "Example Line Chart", dataPoints: DYDataPoint.exampleData0, selectedIndex: .constant(0), isLandscape: false, xValueConverter: { (xValue) -> String in
            let date = Date(timeIntervalSinceReferenceDate: xValue)
            let dateFormat = "dd-MM-yyyy HH:mm"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: date)
            
        }, yValueConverter: { (yValue) -> String in
            return yValue.toDecimalString(maxFractionDigits: 1) + " KG"
            
        })
    }
}
