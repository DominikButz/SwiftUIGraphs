//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 22/10/2022.
//

import SwiftUI

public struct DYSelectorPointView<S: Shape>: View {

    let shape: S
    let color: Color
    let shapeSize: CGFloat
    let shapeHaloSize: CGFloat
    
    public init(shape: S = Circle(), color: Color = .red, shapeSize: CGFloat = 14, shapeHaloSize: CGFloat = 26) {
        self.shape = shape
        self.color = color
        self.shapeSize = shapeSize
        self.shapeHaloSize = shapeHaloSize
    }
    
    public var body: some View {
        shape
            .frame(width: shapeHaloSize, height: shapeHaloSize, alignment: .center)
            .foregroundColor(color)
            .opacity(0.2)
            .overlay(
                shape
                    .fill()
                    .frame(width: shapeSize, height: shapeSize, alignment: .top)
                    .foregroundColor(color)
            )
    }
}

struct DYSelectorPointView_Previews: PreviewProvider {
    static var previews: some View {
        DYSelectorPointView()
    }
}
