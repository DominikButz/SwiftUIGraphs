//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 22/10/2022.
//

import SwiftUI

public struct DYLinePointView<S: Shape>: View {
    
    
    /// DYLinePointView initializer
    /// - Parameters:
    ///   - shape: a Shape
    ///   - borderColor: border Color
    ///   - borderLineWidth: border line with
    ///   - fillColor: fill color
    ///   - edgeLength: size of the point
    public init(shape: S = Circle(), borderColor: Color = .orange, borderLineWidth: CGFloat = 2, fillColor: Color = Color.defaultPlotAreaBackgroundColor, edgeLength: CGFloat = 12) {
        self.shape = shape
        self.borderColor = borderColor
        self.borderLineWidth = borderLineWidth
        self.fillColor = fillColor
        self.edgeLength = edgeLength
    }
    
    
    let shape: S
    let borderColor: Color
    let borderLineWidth: CGFloat
    let fillColor: Color
    let edgeLength: CGFloat
    
    public var body: some View {
        shape
            .fill(fillColor)
            .frame(width: edgeLength, height: edgeLength, alignment: .center)
            .overlay(
                shape
                    .stroke(borderColor, lineWidth: borderLineWidth)
                    
            )
    }
}

struct DYLinePointView_Previews: PreviewProvider {
    static var previews: some View {
        DYLinePointView()
    }
}
