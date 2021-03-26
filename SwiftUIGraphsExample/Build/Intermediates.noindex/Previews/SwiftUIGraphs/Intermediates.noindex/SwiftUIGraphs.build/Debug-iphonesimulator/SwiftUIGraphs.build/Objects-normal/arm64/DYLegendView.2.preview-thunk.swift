@_private(sourceFile: "DYLegendView.swift") import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension DYLegendView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 90)
        AnyView(DYLegendView(title: __designTimeString("#18108.[2].[0].property.[0].[0].arg[0].value", fallback: "Example Line Chart"), dataPoints: DYDataPoint.exampleData0, selectedIndex: .constant(__designTimeInteger("#18108.[2].[0].property.[0].[0].arg[2].value.arg[0].value", fallback: 0)), isLandscape: __designTimeBoolean("#18108.[2].[0].property.[0].[0].arg[3].value", fallback: false), xValueConverter: { (xValue) -> String in
            let date = Date(timeIntervalSinceReferenceDate: xValue)
            let dateFormat = __designTimeString("#18108.[2].[0].property.[0].[0].arg[4].value.[1].value", fallback: "dd-MM-yyyy HH:mm")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: date)
            
        }, yValueConverter: { (yValue) -> String in
            return yValue.toDecimalString(maxFractionDigits: 1) + " KG"
            
        }))
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: maxDataPoint) private var __preview__maxDataPoint: DYDataPoint? {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 75)
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
    @_dynamicReplacement(for: maximumValueView) private var __preview__maximumValueView: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 60)
        AnyView(Group {
            if let maxDataPoint = self.maxDataPoint {
                    HStack {
                        Text(__designTimeString("#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[0].arg[0].value", fallback: "Maximum")).bold()
                        Text(yValueConverter(maxDataPoint.yValue)).bold()
                        Text(xValueConverter(maxDataPoint.xValue)).foregroundColor(.secondary)
                        Spacer()
                    }
                    .font(.footnote)
                
            }
        })
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 32)
        
        AnyView(VStack(alignment: .leading, spacing: __designTimeInteger("#18108.[1].[7].property.[0].[0].arg[1].value", fallback: 5)) {
           
                Text(title).font(.headline)
            if self.dataPoints.count >= 2 {
                if self.isLandscape == false  {
                    self.maximumValueView
                    Divider()
                }
                
                HStack {
                    if selectedIndex >= 0 && selectedIndex <= self.dataPoints.count {
                        Text(yValueConverter(dataPoints[selectedIndex].yValue)).font(.body).bold()
                        Text(xValueConverter(dataPoints[selectedIndex].xValue)).foregroundColor(.secondary)
                    }
                    if self.isLandscape {
                        Text(__designTimeString("#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[1].[0].[0].arg[0].value", fallback: " | "))
                        self.maximumValueView
                    }
                    
                    Spacer()
                }
            }
            
        })
  
    #sourceLocation()
    }
}

import struct SwiftUIGraphs.DYLegendView
import struct SwiftUIGraphs.DYLegendView_Previews