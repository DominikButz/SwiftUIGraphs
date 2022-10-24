//
//  DYFractionChartHeaderView.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import SwiftUI

/// DYFractionChartInfoView. a view that displays details of the selected DYChartFraction. 
public struct DYFractionChartInfoView: View {
    
    let title: String
    let data: [DYPieFraction]
    @Binding var selectedSlice: DYPieFraction?
    let valueConverter: (Double)->String
    
    /// DYFractionChartInfoView initializer
    /// - Parameters:
    ///   - title: a title.
    ///   - data: an array of DYChartFractions
    ///   - selectedSlice: the selected DYChartFraction
    ///   - valueConverter: implement a logic to convert the double value to a string.
    public init(title: String, data: [DYPieFraction], selectedSlice: Binding<DYPieFraction?>, valueConverter: @escaping (Double)->String) {
        self.title = title
        self.data = data
        self._selectedSlice = selectedSlice
        self.valueConverter = valueConverter
        
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            if self.title != "" {
                Text(self.title).font(.headline).bold()
            }
            if let fraction = selectedSlice {
                Text(fraction.title).font(.headline)
                Text(self.valueConverter(fraction.value) + " - " + fraction.value.percentageString(totalValue: data.reduce(0) { $0 + $1.value}) )
            }
        }
    }
    
    func fractionFor(id: String)->DYPieFraction? {
        return self.data.filter({$0.id == id}).first
    }
}

struct DYFractionChartHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        let data = DYPieFraction.exampleData()
        return DYFractionChartInfoView(title: "Example data", data: data, selectedSlice: .constant(data.first!), valueConverter: { value in
            value.toCurrencyString()
        })
    }
}
