//
//  UIScreen+Extension.swift
//  UIStoryView
//
//  Created by Volkan SÖNMEZ on 9.02.2021.
//

import Foundation
import UIKit

internal extension UIScreen {
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenWidth:  CGFloat {
        return UIScreen.main.bounds.width
    }
}
