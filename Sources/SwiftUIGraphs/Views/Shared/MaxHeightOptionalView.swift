//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 6/9/2022.
//

import SwiftUI

internal struct MaxHeightOptionalView<V: View>: View {
    @State var height: CGFloat = 0
    @State var opacity: CGFloat = 1
    let maxHeight: CGFloat
    
    var view: V?
    
    var body: some View {
        view?.measureSize(perform: { size in
            self.height = size.height
        }).opacity(opacity)
        .onChange(of: height, perform: { newValue in
            self.opacity =  newValue > maxHeight ? 0 : 1
        })
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
