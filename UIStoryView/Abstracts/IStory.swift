//
//  IStory.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 7.01.2020.
//  Copyright © 2020 Porte. All rights reserved.
//

public protocol IStory: class
{
    var isTypeImage: Bool { get };
       
    func getPath() -> String;
       
    func getDuration() -> Int;
}
