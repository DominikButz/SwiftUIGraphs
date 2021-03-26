@_private(sourceFile: "BasicPieChartExample.swift") import SwiftUIGraphsExample
import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension BasicPieChartExample_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/BasicPieChartExample.swift", line: 27)
        AnyView(__designTimeSelection(BasicPieChartExample(), "#9407.[3].[0].property.[0].[0]"))
    #sourceLocation()
    }
}

extension BasicPieChartExample {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/BasicPieChartExample.swift", line: 15)
        AnyView(__designTimeSelection(DYPieChartView(data: [__designTimeSelection(DYChartFraction(value: __designTimeInteger("#9407.[2].[0].property.[0].[0].arg[0].value.[0].arg[0].value", fallback: 30), color: __designTimeSelection(Color.blue, "#9407.[2].[0].property.[0].[0].arg[0].value.[0].arg[1].value"), title: __designTimeString("#9407.[2].[0].property.[0].[0].arg[0].value.[0].arg[2].value", fallback: "First")), "#9407.[2].[0].property.[0].[0].arg[0].value.[0]"), __designTimeSelection(DYChartFraction(value: __designTimeInteger("#9407.[2].[0].property.[0].[0].arg[0].value.[1].arg[0].value", fallback: 40), color: .green, title: __designTimeString("#9407.[2].[0].property.[0].[0].arg[0].value.[1].arg[2].value", fallback: "Second")), "#9407.[2].[0].property.[0].[0].arg[0].value.[1]"), __designTimeSelection(DYChartFraction(value: __designTimeInteger("#9407.[2].[0].property.[0].[0].arg[0].value.[2].arg[0].value", fallback: 30), color: .orange, title: __designTimeString("#9407.[2].[0].property.[0].[0].arg[0].value.[2].arg[2].value", fallback: "Third")), "#9407.[2].[0].property.[0].[0].arg[0].value.[2]")]) { (value) -> String in
            let formatter = NumberFormatter()
            formatter.currencySymbol = "USD"
            formatter.maximumFractionDigits = 2
            return formatter.string(for: value)!
            
        }, "#9407.[2].[0].property.[0].[0]"))
    #sourceLocation()
    }
}

import struct SwiftUIGraphsExample.BasicPieChartExample
import struct SwiftUIGraphsExample.BasicPieChartExample_Previews