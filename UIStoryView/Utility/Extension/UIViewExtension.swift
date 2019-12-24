//
//  UIViewExtension.swift
//  StoryLibrary
//
//  Created by Volkan Sonmez on 26.09.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation
import UIKit;

extension UIView
{
    public var allSubviews: [UIView]
    {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
    
    public var globalPoint: CGPoint?
    {
        if let point = self.superview?.convert(self.frame.origin, to: nil)
        {
            return point;
        }
        return nil;
    }
}
