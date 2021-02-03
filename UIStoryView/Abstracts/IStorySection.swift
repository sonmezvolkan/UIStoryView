//
//  IStorySection.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 7.01.2020.
//  Copyright © 2020 Porte. All rights reserved.
//

import UIKit

public protocol IStorySection: class {
    
    var title: String? { get set }
    
    var thumbnail: String? { get set }
    
    var borderColor: UIColor? { get set }
    
    var isWatched: Bool { get set }
    
    func getStories() -> [IStory]
}
