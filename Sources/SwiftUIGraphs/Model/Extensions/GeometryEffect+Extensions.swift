//
//  File.swift
//  
//
//  Created by Dominik Butz on 16/8/2022.
//

import Foundation
import SwiftUI

struct VerticalCompress: GeometryEffect {
    var heightFactor: CGFloat
    var animatableData: CGFloat {
        get { heightFactor }
        set { heightFactor = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        
        return ProjectionTransform(CGAffineTransform(scaleX: 1, y: animatableData))
    }
    
}



extension AnyTransition {
//    static var moveAndFade: AnyTransition {
//        let insertion = AnyTransition.move(edge: .trailing)
//            .combined(with: .opacity)
//        let removal = AnyTransition.scale(scale: 0, anchor: .top)
//        return .asymmetric(insertion: insertion, removal: removal)
//    }
    
    static var verticalExpandCompress: AnyTransition {
        AnyTransition.modifier(active: VerticalCompress(heightFactor: 0), identity: VerticalCompress(heightFactor: 1))
    }

}
