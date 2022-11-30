//
//  OrientationInfo.swift
//  
//
//  Created by Dominik Butz on 19/2/2021.
//

import Foundation
import SwiftUI

#if os(iOS) 
public final class OrientationObserver: ObservableObject {
    enum Orientation {
        case portrait
        case landscape
    }
    
    @Published var orientation: Orientation
    
    private var _observer: NSObjectProtocol?
    
    public init() {
   
        if UIDevice.current.orientation.isLandscape {

            self.orientation = .landscape
        }
        else {
            self.orientation = .portrait
        }
        
        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] notification in
            guard let device = notification.object as? UIDevice else {
                return
            }
            if device.orientation.isPortrait {
                self.orientation = .portrait
            } else {
                self.orientation = .landscape
            }

        }
        
    }
    
    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
}
#endif
