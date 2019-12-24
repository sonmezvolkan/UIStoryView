//
//  UIDateExtension.swift
//  StoryLibrary
//
//  Created by Volkan Sonmez on 26.09.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation

extension Date
{
    static func - (start: Date, end: Date) -> TimeInterval
    {
        return start.timeIntervalSinceReferenceDate - end.timeIntervalSinceReferenceDate;
    }
}
