//
//  HelperDate.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 24.12.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation
import UIKit;

public class HelperDate
{
    public static func convertToSecondFromInterval(_ interval: Double) -> Double
    {
        let ms = Int((interval.truncatingRemainder(dividingBy: 1)) * 1000);
        return Double(ms) / 1000;
    }
}
