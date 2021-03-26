//
//  DYChartLegendView.swift
//  
//
//  Created by Dominik Butz on 25/3/2021.
//

import SwiftUI

public struct DYFractionChartLegendView: View {
 var data: [DYChartFraction]
    var verticalAlignment: Bool = true
    var font: Font
    var textColor: Color
    
    public init(data:  [DYChartFraction], font: Font, textColor: Color) {
        self.data = data
        self.font = font
        self.textColor = textColor
    }
    
    public var body: some View {
            Group {
                if verticalAlignment == false  {
                    HStack(spacing: 5) {
                        ForEach(data) { fraction in
                            Spacer(minLength: 0)
                            VStack(spacing: 5) {
                                self.content(fraction: fraction)
                            }
                            Spacer(minLength: 0)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(data) { fraction in
                          
                            HStack(spacing: 5) {
                                self.content(fraction: fraction)
                            }
                         
                        }
                        
                    }
                    
                }
            }
        
    }
    
   private func content(fraction: DYChartFraction)->some View {
        Group {
            Circle().fill(fraction.color).frame(width: 20)
            Text(fraction.title).font(self.font).foregroundColor(self.textColor)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DYFractionChartLegendView(data: DYChartFraction.exampleData(), font: Font.caption, textColor: .primary)
            .frame(width: 250, height: 250)
    }
}