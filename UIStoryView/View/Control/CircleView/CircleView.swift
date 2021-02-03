//
//  CircleView.swift
//  UIStoryView
//
//  Created by Volkan SÖNMEZ on 30.01.2021.
//  Copyright © 2021 Porte. All rights reserved.
//

import Foundation
import UIKit

public class CircleView: UIView {
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setCircle()
    }
    
    private func setCircle() {
        print("width: \(frame.size.width)  height: \(frame.size.height)")
        layer.cornerRadius = frame.size.width / 2
        clipsToBounds = true
    }
}
