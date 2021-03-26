@_private(sourceFile: "DYFractionChartHeaderView.swift") import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension DYFractionChartHeaderView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYFractionChartHeaderView.swift", line: 41)
        let data = DYChartFraction.exampleData()
        return AnyView(DYFractionChartHeaderView(title: __designTimeString("#40830.[2].[0].property.[0].[1].arg[0].value", fallback: "Example data"), data: data, selectedId: .constant(data.first!.id), valueConverter: { value in
            DYChartFraction.exampleFormatter(value: value)
        }))
    #sourceLocation()
    }
}

extension DYFractionChartHeaderView {
    @_dynamicReplacement(for: fractionFor(id:)) private func __preview__fractionFor(id: String)->DYChartFraction? {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYFractionChartHeaderView.swift", line: 35)
        return self.data.filter({$0.id == id}).first
    #sourceLocation()
    }
}

extension DYFractionChartHeaderView {
    @_dynamicReplacement(for: body) private var __preview__body: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYFractionChartHeaderView.swift", line: 25)
        AnyView(VStack(alignment: .leading, spacing: __designTimeInteger("#40830.[1].[5].property.[0].[0].arg[1].value", fallback: 5)) {
            Text(self.title).font(.title).bold()
            if let selectedId = selectedId, let fraction = self.fractionFor(id: selectedId) {
                Text(fraction.title).font(.callout).bold()
                Text(self.valueConverter(fraction.value))
            }
        })
    #sourceLocation()
    }
}

import struct SwiftUIGraphs.DYFractionChartHeaderView
import struct SwiftUIGraphs.DYFractionChartHeaderView_Previews