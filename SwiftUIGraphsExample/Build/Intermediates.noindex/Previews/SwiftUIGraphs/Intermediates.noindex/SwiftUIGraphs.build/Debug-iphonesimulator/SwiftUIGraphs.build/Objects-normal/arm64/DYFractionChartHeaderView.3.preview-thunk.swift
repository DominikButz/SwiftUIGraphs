@_private(sourceFile: "DYFractionChartHeaderView.swift") import SwiftUIGraphs
import SwiftUI
import SwiftUI

extension DYFractionChartHeaderView_Previews {
    @_dynamicReplacement(for: previews) private static var __preview__previews: some View {
        #sourceLocation(file: "/Users/Dominik/Documents/Programmieren/Libraries/SwiftUIGraphs/Sources/SwiftUIGraphs/Views/Pie Chart/DYFractionChartHeaderView.swift", line: 41)
        let data = DYChartFraction.exampleData()
        return AnyView(__designTimeSelection(DYFractionChartHeaderView(title: __designTimeString("#40830.[2].[0].property.[0].[1].arg[0].value", fallback: "Example data"), data: __designTimeSelection(data, "#40830.[2].[0].property.[0].[1].arg[1].value"), selectedId: .constant(data.first!.id), valueConverter: { value in
            __designTimeSelection(DYChartFraction.exampleFormatter(value: __designTimeSelection(value, "#40830.[2].[0].property.[0].[1].arg[3].value.[0].arg[0].value")), "#40830.[2].[0].property.[0].[1].arg[3].value.[0]")
        }), "#40830.[2].[0].property.[0].[1]"))
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
        AnyView(__designTimeSelection(VStack(alignment: .leading, spacing: __designTimeInteger("#40830.[1].[5].property.[0].[0].arg[1].value", fallback: 5)) {
            __designTimeSelection(Text(__designTimeSelection(self.title, "#40830.[1].[5].property.[0].[0].arg[2].value.[0].arg[0].value")).font(.title).bold(), "#40830.[1].[5].property.[0].[0].arg[2].value.[0]")
            if let selectedId = selectedId, let fraction = self.fractionFor(id: selectedId) {
                __designTimeSelection(Text(__designTimeSelection(fraction.title, "#40830.[1].[5].property.[0].[0].arg[2].value.[1].[0].[0].arg[0].value")).font(.callout).bold(), "#40830.[1].[5].property.[0].[0].arg[2].value.[1].[0].[0]")
                __designTimeSelection(Text(__designTimeSelection(self.valueConverter(__designTimeSelection(fraction.value, "#40830.[1].[5].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value.modifier[0].arg[0].value")), "#40830.[1].[5].property.[0].[0].arg[2].value.[1].[0].[1].arg[0].value")), "#40830.[1].[5].property.[0].[0].arg[2].value.[1].[0].[1]")
            }
        }, "#40830.[1].[5].property.[0].[0]"))
    #sourceLocation()
    }
}

import struct SwiftUIGraphs.DYFractionChartHeaderView
import struct SwiftUIGraphs.DYFractionChartHeaderView_Previews