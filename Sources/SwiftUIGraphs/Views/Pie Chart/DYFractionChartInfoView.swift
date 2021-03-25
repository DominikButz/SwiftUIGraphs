//
//  DYFractionChartHeaderView.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import SwiftUI

public struct DYFractionChartInfoView: View {
    
    let title: String
    let data: [DYChartFraction]
    @Binding var selectedId: String?
    let valueConverter: (Double)->String
    public init(title: String, data: [DYChartFraction], selectedId: Binding<String?>, valueConverter: @escaping (Double)->String) {
        self.title = title
        self.data = data
        self._selectedId = selectedId
        self.valueConverter = valueConverter
        
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(self.title).font(.headline).bold()
            if let selectedId = selectedId, let fraction = self.fractionFor(id: selectedId) {
                Text(fraction.title).font(.callout).bold()
                Text(self.valueConverter(fraction.value))
                Text(fraction.value.percentageString(totalValue: data.reduce(0) { $0 + $1.value}))
            }
        }
    }
    
    func fractionFor(id: String)->DYChartFraction? {
        return self.data.filter({$0.id == id}).first
    }
}

struct DYFractionChartHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let data = DYChartFraction.exampleData()
        return DYFractionChartInfoView(title: "Example data", data: data, selectedId: .constant(data.first!.id), valueConverter: { value in
            DYChartFraction.exampleFormatter(value: value)
        })
    }
}
