//
//  OverlayView.swift
//  Progressive
//
//  Created by Dominik Butz on 15/1/2021.
//  Copyright © 2021 Duoyun. All rights reserved.
//

import SwiftUI

struct OverlayView<Content: View, Background: View>: View {
    
    var contentView:  ()->Content
    var background: ()->Background
    @Binding var show: Bool
    var size: CGSize?
    var settings: OverlayViewSettings
    
    init(content: @escaping ()->Content, background: @escaping ()->Background, show: Binding<Bool>, size: CGSize?, settings: OverlayViewSettings) {
        
        self.contentView = content
        self.background = background
        self._show = show
        self.size = size
        self.settings = settings

    }
    
    var body: some View {
        self.contentView()
            .frame(width: self.size?.width, height: self.size?.height)
            .background(background())
            .clipShape(RoundedRectangle(cornerRadius: settings.cornerRadius))
            .shadow(radius: 5)
    }
}

struct OverlayViewModifier<ContentView: View, Background: View> : ViewModifier {
    
    var content: ()->ContentView
    var background : ()->Background
    
    @Binding var  show: Bool
     var size: CGSize?
    var transition: AnyTransition
    var settings: OverlayViewSettings
    var zIndex: Double
    var dismissOnBackgroundTap: Bool
    
    func body(content: Content) -> some View {
        ZStack(alignment: settings.alignment) {
            
            content
                //.zIndex(0)
                .overlay(Color.black.opacity(self.show ? 0.3 : 0)
            .onTapGesture {
                if self.dismissOnBackgroundTap {
                    self.show.toggle()
                }
            })

            if self.show {
                OverlayView(content: self.content, background: self.background, show: self.$show, size: self.size, settings: settings)
                   .zIndex(zIndex)
                    .offset(settings.offset)
                    .transition(transition)

            }
            
        }.ignoresSafeArea()
    }
}

extension View {
    @ViewBuilder func overlayView<ContentView: View, Background: View>(content: @escaping ()->ContentView, background: @escaping ()->Background, show: Binding<Bool>, size: CGSize?, transition: AnyTransition, zIndex: Double = 1, settings: OverlayViewSettings = OverlayViewSettings(), dismissOnBackgroundTap: Bool = true)->some View {
        self.modifier(OverlayViewModifier(content: content, background: background, show: show, size: size, transition: transition, settings: settings, zIndex: zIndex, dismissOnBackgroundTap: dismissOnBackgroundTap))
    }
}

struct OverlayViewSettings {
    
    init(offset: CGSize = CGSize.zero, alignment: Alignment = Alignment.center, cornerRadius: CGFloat = 10) {
        self.offset = offset
        self.alignment = alignment
        self.cornerRadius = cornerRadius
    }
    var offset: CGSize
    var alignment: Alignment
    var cornerRadius: CGFloat
}


extension View {
    func applyIf<T: View>(_ condition: @autoclosure () -> Bool, apply: (Self) -> T) -> AnyView {
        if condition() {
            return apply(self).eraseToAnyView()
        } else {
            return self.eraseToAnyView()
        }
    }
    
    func eraseToAnyView()->AnyView {
        return AnyView(self)
    }
}

//struct OverlayView_Previews: PreviewProvider {
//    static var previews: some View {
//        OverlayView()
//    }
//}
