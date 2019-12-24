//
//  StorySectionModel.swift
//  StoryLibrary
//
//  Created by Volkan Sonmez on 26.09.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation

public class StorySectionModel
{
    private var stories: [StoryModel]?;
    
    public init(stories: [StoryModel])
    {
        self.stories = stories;
    }
    
    public func getStories() -> [StoryModel]
    {
        return self.stories!;
    }
}
