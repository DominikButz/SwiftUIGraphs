//
//  SwiftUIView.swift
//  
//
//  Created by Dominik Butz on 6/9/2022.
//

import SwiftUI

internal struct MaxSizeOptionalView<V: View>: View {
    @State var size: CGSize = CGSize.zero
    @State var opacity: CGFloat = 1
    let maxSize: CGSize
    
    var view: V?
    
    var body: some View {
        view?.measureSize(perform: { size in
            self.size = size
        }).opacity(opacity)
        .onChange(of: size, perform: { newValue in
            if newValue.height > maxSize.height || newValue.width > maxSize.width {
                self.opacity = 0
            } else {
                self.opacity = 1
            }
           
        })
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        SwiftUIView()
//    }
//}
