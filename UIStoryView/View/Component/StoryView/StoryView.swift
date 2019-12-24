//
//  StoryView.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 24.12.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation
import UIKit;

public class StoryView: UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    public var onLoadDidEnd: ((Bool) -> Void)?;
    public var isLastStory: Bool?;
    
    private var storyModel: StoryModel?;
    private var isLoaded: Bool = false;
    
    init(frame: CGRect, storyModel: StoryModel)
    {
        super.init(frame: frame);
        self.storyModel = storyModel;
        self.setUp();
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        self.setUp();
    }
    
    public override func layoutSubviews()
    {
        super.layoutSubviews();
        self.setControls();
    }
    
    private func setUp()
    {
        let podBundle = Bundle(for: StoriesViewController.self)
        let bundleURL = podBundle.url(forResource: "UIStoryView", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        bundle.loadNibNamed("StoryView", owner: self, options: nil);
        self.addSubview(self.contentView);
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        self.getStory();
    }
    
    private func setControls()
    {
        self.imgView.frame = self.bounds;
    }
    
    private func getStory()
    {
        if let storyModel = self.storyModel, storyModel.isTypeImage
        {
            self.imgView.downloadImageWithoutPlaceHolder(link: storyModel.getPath()) { (flag) in
                self.isLoaded = true;
                self.onLoadDidEnd?(true);
            }
        }
    }
}

extension StoryView
{
    public func getIsLoaded() -> Bool
    {
        return self.isLoaded;
    }
}
