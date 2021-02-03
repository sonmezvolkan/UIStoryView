//
//  Bundle+Extension.swift
//  UIStoryView
//
//  Created by Volkan SÖNMEZ on 30.01.2021.
//  Copyright © 2021 Porte. All rights reserved.
//

import Foundation
import UIKit

extension Bundle {
    
    public static var podBundle: Bundle {
        let podBundle = Bundle(for: UIStoryView.self)
        let bundleURL = podBundle.url(forResource: "UIStoryView", withExtension: "bundle")
        return Bundle(url: bundleURL!)!
    }
}
