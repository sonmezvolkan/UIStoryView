//
//  StoryModel.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 24.12.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation

public class StoryModel
{
    private var storyType: StoryType?;
    private var path: String?;
    private var duration: Int?;
    
    public init(storyType: StoryType, path: String, duration: Int)
    {
        self.storyType = storyType;
        self.path = path;
        self.duration = duration;
    }
    
    public var isTypeImage: Bool
    {
        if let type = self.storyType
        {
            return (type == StoryType.Image) ? true : false;
        }
        return false;
    }
    
    public func getPath() -> String
    {
        return self.path ?? "";
    }
    
    public func getDuration() -> Int
    {
        return self.duration ?? 0;
    }
}
