@_private(sourceFile: "DYChartLegendView.swift") import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension SwiftUIView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYChartLegendView.swift", line: 32)
        AnyView(DYChartLegendView(data: DYChartFraction.exampleData()))
    #sourceLocation()
    }
}

extension DYChartLegendView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/DYChartLegendView.swift", line: 15)
        AnyView(HStack(spacing: __designTimeInteger("#34993.[1].[1].property.[0].[0].arg[0].value", fallback: 10)) {
            ForEach(data) { fraction in
                
                VStack(spacing: __designTimeInteger("#34993.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[0].value", fallback: 5)) {
                    Circle().fill(fraction.color).frame(width: __designTimeInteger("#34993.[1].[1].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[1].value.[0].modifier[1].arg[0].value", fallback: 20))
                    
                    Text(fraction.title).font(.callout).bold()
                    
                }
                
            }
        })
    #sourceLocation()
    }
}

import struct SwiftUIGraphs.DYChartLegendView
import struct SwiftUIGraphs.SwiftUIView_Previews