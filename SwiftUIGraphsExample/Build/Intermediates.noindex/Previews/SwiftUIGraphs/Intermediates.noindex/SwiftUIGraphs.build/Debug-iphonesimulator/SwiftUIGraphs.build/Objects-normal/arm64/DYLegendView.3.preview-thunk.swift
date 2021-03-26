@_private(sourceFile: "DYLegendView.swift") import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension DYLegendView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 90)
        AnyView(__designTimeSelection(DYLegendView(title: __designTimeString("#18108.[2].[0].property.[0].[0].arg[0].value", fallback: "Example Line Chart"), dataPoints: __designTimeSelection(DYDataPoint.exampleData0, "#18108.[2].[0].property.[0].[0].arg[1].value"), selectedIndex: .constant(__designTimeInteger("#18108.[2].[0].property.[0].[0].arg[2].value.arg[0].value", fallback: 0)), isLandscape: __designTimeBoolean("#18108.[2].[0].property.[0].[0].arg[3].value", fallback: false), xValueConverter: { (xValue) -> String in
            let date = Date(timeIntervalSinceReferenceDate: __designTimeSelection(xValue, "#18108.[2].[0].property.[0].[0].arg[4].value.[0].value.arg[0].value"))
            let dateFormat = __designTimeString("#18108.[2].[0].property.[0].[0].arg[4].value.[1].value", fallback: "dd-MM-yyyy HH:mm")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            return __designTimeSelection(dateFormatter.string(from: __designTimeSelection(date, "#18108.[2].[0].property.[0].[0].arg[4].value.[4].modifier[0].arg[0].value")), "#18108.[2].[0].property.[0].[0].arg[4].value.[4]")
            
        }, yValueConverter: { (yValue) -> String in
            return yValue.toDecimalString(maxFractionDigits: 1) + " KG"
            
        }), "#18108.[2].[0].property.[0].[0]"))
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: maxDataPoint) private var __preview__maxDataPoint: DYDataPoint? {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 75)
        guard self.dataPoints.count > 0 else {return nil}
        
        let yValues = dataPoints.map({__designTimeSelection($0.yValue, "#18108.[1].[9].property.[0].[1].value.modifier[0].arg[0].value.[0]")})
        guard let maxY = yValues.max() else {return nil}
        
        if let index = yValues.indices.first(where: {yValues[$0] == maxY}) {
            return __designTimeSelection(dataPoints[__designTimeSelection(index, "#18108.[1].[9].property.[0].[3].[0].[0].[0].value")], "#18108.[1].[9].property.[0].[3].[0].[0]")
        } else {return  nil}
        
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: maximumValueView) private var __preview__maximumValueView: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 60)
        AnyView(__designTimeSelection(Group {
            if let maxDataPoint = self.maxDataPoint {
                    __designTimeSelection(HStack {
                        __designTimeSelection(Text(__designTimeString("#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[0].arg[0].value", fallback: "Maximum")).bold(), "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[0]")
                        __designTimeSelection(Text(__designTimeSelection(yValueConverter(__designTimeSelection(maxDataPoint.yValue, "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[1].arg[0].value.arg[0].value")), "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[1].arg[0].value")).bold(), "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[1]")
                        __designTimeSelection(Text(__designTimeSelection(xValueConverter(__designTimeSelection(maxDataPoint.xValue, "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[2].arg[0].value.arg[0].value")), "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[2].arg[0].value")).foregroundColor(.secondary), "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[2]")
                        __designTimeSelection(Spacer(), "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0].arg[0].value.[3]")
                    }
                    .font(.footnote), "#18108.[1].[8].property.[0].[0].arg[0].value.[0].[0].[0]")
                
            }
        }, "#18108.[1].[8].property.[0].[0]"))
    #sourceLocation()
    }
}

extension DYLegendView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYLegendView.swift", line: 32)
        
        AnyView(__designTimeSelection(VStack(alignment: .leading, spacing: __designTimeInteger("#18108.[1].[7].property.[0].[0].arg[1].value", fallback: 5)) {
           
                __designTimeSelection(Text(__designTimeSelection(title, "#18108.[1].[7].property.[0].[0].arg[2].value.[0].arg[0].value")).font(.headline), "#18108.[1].[7].property.[0].[0].arg[2].value.[0]")
            if self.dataPoints.count >= 2 {
                if self.isLandscape == false  {
                    __designTimeSelection(self.maximumValueView, "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[0].[0].[0]")
                    __designTimeSelection(Divider(), "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[0].[0].[1]")
                }
                
                __designTimeSelection(HStack {
                    if selectedIndex >= 0 && selectedIndex <= self.dataPoints.count {
                        __designTimeSelection(Text(__designTimeSelection(yValueConverter(dataPoints[selectedIndex].yValue), "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[0].[0].[0].arg[0].value")).font(.body).bold(), "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[0].[0].[0]")
                        __designTimeSelection(Text(__designTimeSelection(xValueConverter(dataPoints[selectedIndex].xValue), "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[0].[0].[1].arg[0].value")).foregroundColor(.secondary), "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[0].[0].[1]")
                    }
                    if self.isLandscape {
                        __designTimeSelection(Text(__designTimeString("#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[1].[0].[0].arg[0].value", fallback: " | ")), "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[1].[0].[0]")
                        __designTimeSelection(self.maximumValueView, "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[1].[0].[1]")
                    }
                    
                    __designTimeSelection(Spacer(), "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.[2]")
                }, "#18108.[1].[7].property.[0].[0].arg[2].value.[1].[0].[1]")
            }
            
        }, "#18108.[1].[7].property.[0].[0]"))
  
    #sourceLocation()
    }
}

import struct SwiftUIGraphs.DYLegendView
import struct SwiftUIGraphs.DYLegendView_Previews