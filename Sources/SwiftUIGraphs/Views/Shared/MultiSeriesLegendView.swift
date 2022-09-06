//
//  File.swift
//  
//
//  Created by Dominik Butz on 6/9/2022.
//

import Foundation
import SwiftUI

public struct MultiSeriesLegendView<C: View>: View {

    
    var legendItems: [LegendItem<C>] = []
    
    public init(legendItems: [LegendItem<C>] = []) {
        self.legendItems = legendItems
    }
    
    public var body: some View {
        Group {
            ForEach(legendItems) { item in
                HStack {
                    item.colorSymbol
                    Text(item.title)
                    Spacer()
                }
            }
           Spacer()
        }
        
    }
    

}

public struct LegendItem<C: View>: Identifiable {

    public let id: UUID = UUID()
    let colorSymbol: C
    let title: String
    
    public init(colorSymbol: C, title: String) {
        self.colorSymbol = colorSymbol
        self.title = title
    }
}
