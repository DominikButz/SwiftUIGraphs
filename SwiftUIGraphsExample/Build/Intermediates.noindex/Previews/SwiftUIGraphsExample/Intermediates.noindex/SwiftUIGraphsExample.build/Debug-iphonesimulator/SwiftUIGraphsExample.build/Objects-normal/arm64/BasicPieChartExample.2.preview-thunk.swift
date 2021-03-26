@_private(sourceFile: "BasicPieChartExample.swift") import SwiftUIGraphsExample
import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension BasicPieChartExample_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/BasicPieChartExample.swift", line: 27)
        AnyView(BasicPieChartExample())
    #sourceLocation()
    }
}

extension BasicPieChartExample {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/BasicPieChartExample.swift", line: 15)
        AnyView(DYPieChartView(data: [DYChartFraction(value: __designTimeInteger("#9407.[2].[0].property.[0].[0].arg[0].value.[0].arg[0].value", fallback: 30), color: Color.blue, title: __designTimeString("#9407.[2].[0].property.[0].[0].arg[0].value.[0].arg[2].value", fallback: "First")), DYChartFraction(value: __designTimeInteger("#9407.[2].[0].property.[0].[0].arg[0].value.[1].arg[0].value", fallback: 40), color: .green, title: __designTimeString("#9407.[2].[0].property.[0].[0].arg[0].value.[1].arg[2].value", fallback: "Second")), DYChartFraction(value: __designTimeInteger("#9407.[2].[0].property.[0].[0].arg[0].value.[2].arg[0].value", fallback: 30), color: .orange, title: __designTimeString("#9407.[2].[0].property.[0].[0].arg[0].value.[2].arg[2].value", fallback: "Third"))]) { (value) -> String in
            let formatter = NumberFormatter()
            formatter.currencySymbol = "USD"
            formatter.maximumFractionDigits = 2
            return formatter.string(for: value)!
            
        })
    #sourceLocation()
    }
}

import struct SwiftUIGraphsExample.BasicPieChartExample
import struct SwiftUIGraphsExample.BasicPieChartExample_Previews