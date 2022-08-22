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
    let haloOffset: CGSize
    
    public init(shape: S = Circle(), color: Color = .red, shapeSize: CGFloat = 14, shapeHaloSize: CGFloat = 26, haloOffset: CGSize = .zero) {
        self.shape = shape
        self.color = color
        self.shapeSize = shapeSize
        self.shapeHaloSize = shapeHaloSize
        self.haloOffset = haloOffset
        
    }
    
    public var body: some View {
        ZStack {
            shape
                .frame(width: shapeHaloSize, height: shapeHaloSize, alignment: .center)
                .foregroundColor(color)
                .opacity(0.2)
                .offset(haloOffset)
            
            shape
                .fill()
                .frame(width: shapeSize, height: shapeSize, alignment: .top)
                .foregroundColor(color)
               
            
        }

    }
}

struct DYSelectorPointView_Previews: PreviewProvider {
    static var previews: some View {
        DYSelectorPointView(shape: Triangle(), color: .green, shapeSize: 25, shapeHaloSize: 50, haloOffset: CGSize(width: 0, height: -25 / 6))
    }
}
