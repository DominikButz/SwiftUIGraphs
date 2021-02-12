//
//  DYLegendView.swift
//  SwiftUIGraphsExample
//
//  Created by Dominik Butz on 2/2/2021.
//

import SwiftUI

public struct DYLegendView: View {
    @ObservedObject var orientationObserver = OrientationObserver()
    let title: String
    var dataPoints: [DYDataPoint]
    var xValueConverter: (Double)->String
    var yValueConverter:  (Double)->String
    
    @Binding var selectedIndex: Int
    
    public init(title: String, dataPoints: [DYDataPoint], selectedIndex: Binding<Int>, xValueConverter: @escaping (Double)->String, yValueConverter: @escaping (Double)->String) {
        self.title = title
        let sortedData = dataPoints.sorted(by: {$0.xValue < $1.xValue})
        self.dataPoints = sortedData
        self._selectedIndex = selectedIndex
        self.xValueConverter = xValueConverter
        self.yValueConverter = yValueConverter
    }
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 5) {
           
                Text(title).font(.title)

         
            if self.dataPoints.count >= 2 {
                if self.orientationObserver.orientation == .portrait {
                    self.maximumValueView
                    Divider()
                }
                
                HStack {
                    Text(yValueConverter(dataPoints[selectedIndex].yValue)).font(.body).bold()
                    Text(xValueConverter(dataPoints[selectedIndex].xValue)).foregroundColor(.secondary)
                    
                    if self.orientationObserver.orientation == .landscape  {
                        Text(" | ")
                        self.maximumValueView
                    }
                    
                    Spacer()
                }
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

struct DYLegendView_Previews: PreviewProvider {
    static var previews: some View {
        DYLegendView(title: "Example Line Chart", dataPoints: DYDataPoint.lineExampleData0, selectedIndex: .constant(0), xValueConverter: { (xValue) -> String in
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
