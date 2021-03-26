@_private(sourceFile: "ContentView.swift") import SwiftUIGraphsExample
import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension ContentView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/ContentView.swift", line: 39)
        AnyView(ContentView().colorScheme(.light))
    #sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/ContentView.swift", line: 15)
        let exampleData = DYDataPoint.exampleData
       return  AnyView(GeometryReader { proxy in
         VStack {
            DYLegendView(title: __designTimeString("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[0].value", fallback: "Example Chart"), dataPoints: exampleData, selectedIndex: self.$selectedDataIndex, xValueConverter: { (xValue) -> String in
                return Date(timeIntervalSinceReferenceDate: xValue).toString(format:__designTimeString("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[3].value.[0].modifier[0].arg[0].value", fallback: "dd-MM-yyyy HH:mm"))
            }, yValueConverter: { (yValue) -> String in
                return yValue.toDecimalString(maxFractionDigits: 1) + " KG"
            })
        
            DYLineChartView(dataPoints: exampleData, selectedIndex: $selectedDataIndex, xValueConverter: { (xValue) -> String in
                return Date(timeIntervalSinceReferenceDate: xValue).toString(format:__designTimeString("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[2].value.[0].modifier[0].arg[0].value", fallback: "dd-MM-yyyy HH:mm"))
            }, yValueConverter: { (yValue) -> String in
                return yValue.toDecimalString(maxFractionDigits: __designTimeInteger("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[3].value.[0].modifier[0].arg[0].value", fallback: 1))
            }, settings: DYLineChartSettings(showGradient: __designTimeBoolean("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[4].value.arg[0].value", fallback: false), showYAxisLines: __designTimeBoolean("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[4].value.arg[1].value", fallback: false), overrideYAxisMinMax: (min: 0, max: nil)))
            
                //
         }.frame(maxHeight: proxy.size.height > proxy.size.width ?  proxy.size.height * 0.5 : proxy.size.height * 0.9).padding()
       })

    #sourceLocation()
    }
}

import struct SwiftUIGraphsExample.ContentView
import struct SwiftUIGraphsExample.ContentView_Previews