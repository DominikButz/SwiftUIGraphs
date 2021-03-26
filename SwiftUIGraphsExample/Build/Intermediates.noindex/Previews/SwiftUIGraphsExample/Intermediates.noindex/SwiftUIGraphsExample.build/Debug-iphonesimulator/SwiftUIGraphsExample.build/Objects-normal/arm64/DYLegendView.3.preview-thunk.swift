@_private(sourceFile: "DYLegendView.swift") import SwiftUIGraphsExample
import SwiftUI
import SwiftUI

extension DYLegendView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLegendView.swift", line: 62)
        AnyView(__designTimeSelection(DYLegendView(title: __designTimeString("#3751.[2].[0].property.[0].[0].arg[0].value", fallback: "Example Line Chart"), dataPoints: __designTimeSelection(DYDataPoint.exampleData, "#3751.[2].[0].property.[0].[0].arg[1].value"), xValueConverter: { (xValue) -> String in
            let date = Date(timeIntervalSinceReferenceDate: __designTimeSelection(xValue, "#3751.[2].[0].property.[0].[0].arg[2].value.[0].value.arg[0].value"))
            let dateFormat = __designTimeString("#3751.[2].[0].property.[0].[0].arg[2].value.[1].value", fallback: "dd-MM-yyyy HH:mm")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            return __designTimeSelection(dateFormatter.string(from: __designTimeSelection(date, "#3751.[2].[0].property.[0].[0].arg[2].value.[4].modifier[0].arg[0].value")), "#3751.[2].[0].property.[0].[0].arg[2].value.[4]")
  
        }, yValueConverter: { (yValue) -> String in
            return yValue.toDecimalString(maxFractionDigits: 1) + " KG"
           
        }, selectedIndex: .constant(__designTimeInteger("#3751.[2].[0].property.[0].[0].arg[4].value.arg[0].value", fallback: 0))), "#3751.[2].[0].property.[0].[0]"))
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: maxDataPoint) private var __preview__maxDataPoint: DYDataPoint? {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLegendView.swift", line: 47)
        guard self.dataPoints.count > 0 else {return nil}
        
        let yValues = dataPoints.map({__designTimeSelection($0.yValue, "#3751.[1].[6].property.[0].[1].value.modifier[0].arg[0].value.[0]")})
        guard let maxY = yValues.max() else {return nil}
        
        if let index = yValues.indices.first(where: {yValues[$0] == maxY}) {
            return __designTimeSelection(dataPoints[__designTimeSelection(index, "#3751.[1].[6].property.[0].[3].[0].[0].[0].value")], "#3751.[1].[6].property.[0].[3].[0].[0]")
        } else {return  nil}
        
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphs/DYLegendView.swift", line: 20)
        if self.dataPoints.count >= 1 {
            __designTimeSelection(VStack(alignment: .leading, spacing: __designTimeInteger("#3751.[1].[5].property.[0].[0].[0].[0].arg[1].value", fallback: 5)) {
                
                __designTimeSelection(Text(__designTimeSelection(title, "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[0].arg[0].value")).font(.title), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[0]")
                __designTimeSelection(HStack {
                    __designTimeSelection(Text(__designTimeSelection(yValueConverter(dataPoints[selectedIndex].yValue), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[1].arg[0].value.[0].arg[0].value")).font(.body).bold(), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[1].arg[0].value.[0]")
                    __designTimeSelection(Text(__designTimeSelection(xValueConverter(dataPoints[selectedIndex].xValue), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[1].arg[0].value.[1].arg[0].value")).foregroundColor(.secondary), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[1].arg[0].value.[1]")
                    __designTimeSelection(Spacer(), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[1].arg[0].value.[2]")
                }, "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[1]")
                if let maxDataPoint = self.maxDataPoint {
                    __designTimeSelection(Divider(), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[0]")
                    __designTimeSelection(Text(__designTimeString("#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[1].arg[0].value", fallback: "Maximum")).bold(), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[1]")
                    __designTimeSelection(HStack {
                        __designTimeSelection(Text(__designTimeSelection(yValueConverter(__designTimeSelection(maxDataPoint.yValue, "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2].arg[0].value.[0].arg[0].value.arg[0].value")), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2].arg[0].value.[0].arg[0].value")).bold(), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2].arg[0].value.[0]")
                        __designTimeSelection(Text(__designTimeSelection(xValueConverter(__designTimeSelection(maxDataPoint.xValue, "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2].arg[0].value.[1].arg[0].value.arg[0].value")), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2].arg[0].value.[1].arg[0].value")).foregroundColor(.secondary), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2].arg[0].value.[1]")
                        __designTimeSelection(Spacer(), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2].arg[0].value.[2]")
                    }.font(.footnote), "#3751.[1].[5].property.[0].[0].[0].[0].arg[2].value.[2].[0].[2]")
                }
   
            }, "#3751.[1].[5].property.[0].[0].[0].[0]")
        }
        else {
            __designTimeSelection(Text(__designTimeString("#3751.[1].[5].property.[0].[0].[1].[0].arg[0].value", fallback: "No data found")), "#3751.[1].[5].property.[0].[0].[1].[0]")
        }
    #sourceLocation()
    }
}

import struct SwiftUIGraphsExample.DYLegendView
import struct SwiftUIGraphsExample.DYLegendView_Previews