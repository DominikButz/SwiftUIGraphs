@_private(sourceFile: "ContentView.swift") import SwiftUIGraphsExample
import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension ContentView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/ContentView.swift", line: 39)
        AnyView(__designTimeSelection(ContentView().colorScheme(.light), "#1697.[3].[0].property.[0].[0]"))
    #sourceLocation()
    }
}

extension ContentView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphsExample/SwiftUIGraphsExample/ContentView.swift", line: 15)
        let exampleData = DYDataPoint.exampleData
       return  AnyView(__designTimeSelection(GeometryReader { proxy in
         __designTimeSelection(VStack {
            __designTimeSelection(DYLegendView(title: __designTimeString("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[0].value", fallback: "Example Chart"), dataPoints: __designTimeSelection(exampleData, "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[1].value"), selectedIndex: __designTimeSelection(self.$selectedDataIndex, "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[2].value"), xValueConverter: { (xValue) -> String in
                return __designTimeSelection(Date(timeIntervalSinceReferenceDate: __designTimeSelection(xValue, "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[3].value.[0].arg[0].value")).toString(format:__designTimeString("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[3].value.[0].modifier[0].arg[0].value", fallback: "dd-MM-yyyy HH:mm")), "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0].arg[3].value.[0]")
            }, yValueConverter: { (yValue) -> String in
                return yValue.toDecimalString(maxFractionDigits: 1) + " KG"
            }), "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[0]")
        
            __designTimeSelection(DYLineChartView(dataPoints: __designTimeSelection(exampleData, "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[0].value"), selectedIndex: __designTimeSelection($selectedDataIndex, "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[1].value"), xValueConverter: { (xValue) -> String in
                return __designTimeSelection(Date(timeIntervalSinceReferenceDate: __designTimeSelection(xValue, "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[2].value.[0].arg[0].value")).toString(format:__designTimeString("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[2].value.[0].modifier[0].arg[0].value", fallback: "dd-MM-yyyy HH:mm")), "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[2].value.[0]")
            }, yValueConverter: { (yValue) -> String in
                return __designTimeSelection(yValue.toDecimalString(maxFractionDigits: __designTimeInteger("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[3].value.[0].modifier[0].arg[0].value", fallback: 1)), "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[3].value.[0]")
            }, settings: __designTimeSelection(DYLineChartSettings(showGradient: __designTimeBoolean("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[4].value.arg[0].value", fallback: false), showYAxisLines: __designTimeBoolean("#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[4].value.arg[1].value", fallback: false), overrideYAxisMinMax: (min: 0, max: nil)), "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1].arg[4].value")), "#1697.[2].[1].property.[0].[1].arg[0].value.[0].arg[0].value.[1]")
            
                //
         }.frame(maxHeight: proxy.size.height > proxy.size.width ?  proxy.size.height * 0.5 : proxy.size.height * 0.9).padding(), "#1697.[2].[1].property.[0].[1].arg[0].value.[0]")
       }, "#1697.[2].[1].property.[0].[1]"))

    #sourceLocation()
    }
}

import struct SwiftUIGraphsExample.ContentView
import struct SwiftUIGraphsExample.ContentView_Previews