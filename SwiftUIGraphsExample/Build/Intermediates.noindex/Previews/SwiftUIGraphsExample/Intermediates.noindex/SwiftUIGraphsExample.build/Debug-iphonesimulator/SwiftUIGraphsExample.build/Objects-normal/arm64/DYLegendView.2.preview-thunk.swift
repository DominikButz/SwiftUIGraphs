@_private(sourceFile: "DYLegendView.swift") import SwiftUIGraphsExample
import SwiftUI
import SwiftUI

extension DYLegendView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLegendView.swift", line: 62)
        AnyView(DYLegendView(title: __designTimeString("#3751.[2].[0].property.[0].[0].arg[0].value", fallback: "Example Line Chart"), dataPoints: DYDataPoint.exampleData, xValueConverter: { (xValue) -> String in
            let date = Date(timeIntervalSinceReferenceDate: xValue)
            let dateFormat = __designTimeString("#3751.[2].[0].property.[0].[0].arg[2].value.[1].value", fallback: "dd-MM-yyyy HH:mm")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: date)
  
        }, yValueConverter: { (yValue) -> String in
            return yValue.toDecimalString(maxFractionDigits: 1) + " KG"
           
        }, selectedIndex: .constant(__designTimeInteger("#3751.[2].[0].property.[0].[0].arg[4].value.arg[0].value", fallback: 0))))
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: maxDataPoint) private var __preview__maxDataPoint: DYDataPoint? {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLegendView.swift", line: 47)
        guard self.dataPoints.count > 0 else {return nil}
        
        let yValues = dataPoints.map({$0.yValue})
        guard let maxY = yValues.max() else {return nil}
        
        if let index = yValues.indices.first(where: {yValues[$0] == maxY}) {
            return dataPoints[index]
        } else {return  nil}
        
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLegendView.swift", line: 20)
        if self.dataPoints.count >= 1 {
            VStack(alignment: .leading, spacing: __designTimeInteger("#3751.[1].[5].property.[0].[0].[0].[0].arg[1].value", fallback: 5)) {
                
                Text(title).font(.title)
                HStack {
                    Text(yValueConverter(dataPoints[selectedIndex].yValue)).font(.body).bold()
                    Text(xValueConverter(dataPoints[selectedIndex].xValue)).foregroundColor(.secondary)
                    Spacer()
                }
                if let maxDataPoint = self.maxDataPoint {
                    Divider()
                    Text(__designTimeString("#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[1].arg[0].value", fallback: "Maximum")).bold()
                    HStack {
                        Text(yValueConverter(maxDataPoint.yValue)).bold()
                        Text(xValueConverter(maxDataPoint.xValue)).foregroundColor(.secondary)
                        Spacer()
                    }.font(.footnote)
                }
   
            }
        }
        else {
            Text(__designTimeString("#3751.[1].[5].property.[0].[0].[1].[0].arg[0].value", fallback: "No data found"))
        }
    #sourceLocation()
    }
}

import struct SwiftUIGraphsExample.DYLegendView
import struct SwiftUIGraphsExample.DYLegendView_Previews