//
//  StorySectionView.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 24.12.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation
import UIKit

public class StorySectionView: UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackProgress: UIStackView!
    @IBOutlet weak var viewStory: UIView!
    
    public var onClose: ((_ storyIndex: Int) -> Void)?;
    public var onNext: (() -> Void)?;
    public var onPrevious: (() -> Void)?;

    public var stories: [IStory]?;
    public var isPause: Bool = true;
    public var isWillGoDetailPage = false
    
    private var storyTintColor: UIColor!;
    private var storyProgressColor: UIColor!;
    
    private var storiesView = [StoryView]();

    private var currentIndex: Int = 0;
    private var timer: Timer?;
    private var timerClickIndex: Int = 0;
    private var beginDate: Date?;
    private var beginLocation: CGPoint?
    private var endDate: Date?;
    
    public var canVideoPlay: Bool = false
    
    init(frame: CGRect, storiesModel: [IStory], storyTintColor: UIColor, storyProgressColor: UIColor, canVideoPlay: Bool)
    {
        super.init(frame: frame);
        self.stories = storiesModel;
        self.storyTintColor = storyTintColor;
        self.storyProgressColor = storyProgressColor;
        self.canVideoPlay = canVideoPlay
        self.setUp();
    }
    
    public required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
        self.setUp();
    }
    
    private func setUp()
    {
        let podBundle = Bundle(for: StoriesViewController.self)
        let bundleURL = podBundle.url(forResource: "UIStoryView", withExtension: "bundle")
        let bundle = Bundle(url: bundleURL!)!
        bundle.loadNibNamed("StorySectionView", owner: self, options: nil);
        self.addSubview(self.contentView);
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight];
        self.createViews();
    }
    
    @IBAction func btnClose_Click(_ sender: Any)
    {
        timer?.invalidate()
        self.onClose?(currentIndex);
    }
}

extension StorySectionView
{
    private func createViews()
    {
        guard let stories = self.stories, stories.isEmpty == false else { return }
        
        for index in 0...stories.count - 1 {
            self.stackProgress.addArrangedSubview(self.createProgressView());
            self.storiesView.append(self.createView(self.stories![index], isLastStory: (index == self.stories!.count - 1)));
        }
        
        self.canVideoPlay = stories[0].isTypeImage == false
        self.currentIndex = 0;
        self.addCurrentView();
    }
    
    private func createProgressView() -> UIProgressView
    {
        let progressView = UIProgressView();
        progressView.progress = 0.0;
        progressView.trackTintColor = self.storyTintColor;
        progressView.progressTintColor = self.storyProgressColor;
        return progressView;
    }
    
    private func createView(_ storyModel: IStory, isLastStory: Bool) -> StoryView
    {
        let storyView = StoryView(frame: self.contentView.bounds, storyModel: storyModel);
        storyView.isLastStory = isLastStory
        
        storyView.onTouchesBegan = { [weak self] touches, event in
            self?.handleTouchesBegan(touches, with: event)
        }
        
        storyView.onTouchesMoved = { [weak self] touches, event in
            self?.handleTouchesMoved(touches, with: event)
        }
        
        storyView.onTouchesEnd = { [weak self] touches, event in
            self?.handleTouchesEnded(touches, with: event)
        }
        
        return storyView;
    }
}

extension StorySectionView
{
    private func handleTouchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.beginDate = Date();
        self.isPause = true;
        self.storiesView[self.currentIndex].pause()
        
        self.beginLocation = touches.first?.location(in: self)
    }
    
    private func handleTouchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.endDate = Date();
        let ms = HelperDate.convertToSecondFromInterval(self.endDate! - self.beginDate!);
        self.isPause = false;
        if (ms <= 0.2)
        {
            if let touch = touches.first
            {
                self.resetTimer(touchLocation: touch.location(in: self));
            }
        } else {
            self.play()
        }
    }
    
    private func handleTouchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ms = HelperDate.convertToSecondFromInterval(Date() - self.beginDate!)
        
        if ms <= 0.3 {
            if let beginLocation = self.beginLocation, let currentLocation = touches.first?.location(in: self) {
                if checkForDetail(beginLocation: beginLocation, currentLocation: currentLocation) {
                    return
                }
                
                closeIfNeeded(beginLocation: beginLocation, currentLocation: currentLocation)
            }
        }
    }
    
    private func checkForDetail(beginLocation: CGPoint, currentLocation: CGPoint) -> Bool {
        if beginLocation.y - currentLocation.y >= 125 {
            let liveArea = CGRect(x: UIScreen.screenWidth / 3, y: UIScreen.screenHeight - 300,
                                  width: UIScreen.screenWidth / 3, height: 300)
            if beginLocation.x > liveArea.minX && beginLocation.x < liveArea.maxX &&
                beginLocation.y > liveArea.minY {
                onClose?(currentIndex)
                return true
            }
        }
        
        return false
    }
    
    private func closeIfNeeded(beginLocation: CGPoint, currentLocation: CGPoint) {
        if currentLocation.y - beginLocation.y >= 125 {
            onClose?(currentIndex)
        }
    }
    
    public func play() {
        self.storiesView[self.currentIndex].play()
    }
}

extension StorySectionView
{
    @objc private func timerClick()
    {
        if let _ = self.stories
        {
            if (!isPause && self.storiesView[self.currentIndex].getIsLoaded())
            {
                UIView.animate(withDuration: 0.1) {
                    let progressValue = self.currentProgressView(index: self.currentIndex).progress + Float(self.getStepValue);
                    self.currentProgressView(index: self.currentIndex).setProgress(progressValue, animated: true);
                }
                self.timerClickIndex += 1;
                if (self.timerClickIndex == self.getCurrentLimit)
                {
                    self.checkIsLastStory();
                    self.resetTimer();
                }
            }
        }
    }
}

extension StorySectionView
{
    private func resetTimer(touchLocation: CGPoint? = nil)
    {
        self.timer?.invalidate();
        self.timerClickIndex = 0;
        if (touchLocation == nil && self.currentIndex < self.stories!.count)
        {
            self.currentProgressView(index: self.currentIndex).setProgress(1.0, animated: false);
            self.currentIndex += 1;
            self.canVideoPlay = stories?[currentIndex].isTypeImage == false
            self.addCurrentView();
        }
        else if (touchLocation != nil)
        {
            self.changeCurrentIndex(touchLocation: touchLocation!);
        }
        self.storiesView[self.currentIndex].rePlay()
    }
    
    private func changeCurrentIndex(touchLocation: CGPoint)
    {
        if (self.isNext(touchLocation: touchLocation))
        {
            if (self.currentIndex < self.stories!.count)
            {
                self.currentProgressView(index: self.currentIndex).setProgress(1.0, animated: false);
                if (self.currentIndex < self.stories!.count - 1)
                {
                    self.currentIndex += 1;
                    self.canVideoPlay = stories?[currentIndex].isTypeImage == false
                    self.addCurrentView();
                }
                else
                {
                     self.checkIsLastStory();
                }
            }
        }
        else
        {
            self.currentProgressView(index: self.currentIndex).setProgress(0.0, animated: false);
            if (self.currentIndex > 0)
            {
                self.currentIndex -= 1;
                self.currentProgressView(index: self.currentIndex).setProgress(0.0, animated: false);
                self.canVideoPlay = stories?[currentIndex].isTypeImage == false
                self.addCurrentView();
            } else {
                self.onPrevious?()
            }
        }
    }
    
    public func removeStoryViews()
    {
        for view in self.viewStory.subviews
        {
            if let storyView = view as? StoryView {
                storyView.pause()
            }
            view.removeFromSuperview();
        }
    }
    
    private func addCurrentView()
    {
        print("\(self.currentIndex)");
        if (self.currentIndex < self.stories!.count)
        {
            self.removeStoryViews();
            self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerClick), userInfo: nil, repeats: true);
            self.viewStory.addSubview(self.storiesView[self.currentIndex]);
            if canVideoPlay {
                self.play()
            }
            if (self.currentIndex > 0)
            {
                self.storiesView[self.currentIndex].alpha = 0.0;
                UIView.animate(withDuration: 0.2, animations: {
                    self.storiesView[self.currentIndex].alpha = 1.0;
                }) { (finish) in
                    
                }
            }
        }
    }
    
    public func pauseVideos()
    {
        for view in self.viewStory.subviews
        {
            if let storyView = view as? StoryView {
                storyView.pause()
            }
        }
    }
}

extension StorySectionView
{
    private var getCurrentDuration: Int
    {
        if (self.stories != nil && self.stories!.count > 0)
        {
            return self.stories![self.currentIndex].getDuration();
        }
        return 0;
    }
    
    private var getCurrentLimit : Int
    {
        return self.getCurrentDuration * 10;
    }
    
    private var getStepValue: Double
    {
        if (self.stories != nil && self.stories!.count > 0)
        {
            let currentLimit = (self.getCurrentLimit > 0) ? Double(self.getCurrentLimit) : 1;
            return Double(1) / currentLimit;
        }
        return 1
    }
    
    private func currentProgressView(index: Int) -> UIProgressView
    {
        let progressView = self.stackProgress.arrangedSubviews[index] as! UIProgressView;
        return progressView;
    }
    
    private func isNext(touchLocation: CGPoint) -> Bool
    {
        if (touchLocation.x <= 50)
        {
            return false;
        }
        return true;
    }
}

extension StorySectionView
{
    private func checkIsLastStory()
    {
        if self.storiesView[self.currentIndex].isLastStory!
        {
            self.timer?.invalidate();
            self.currentIndex = 0;
            self.timerClickIndex = 0;
            self.resetSection();
            self.isPause = true;
            self.onNext?();
        }
    }
    
    public func resetSection()
    {
        self.timer?.invalidate();
        self.currentIndex = 0;
        self.timerClickIndex = 0;
        self.clearProgresses();
        self.addCurrentView();
    }
    
    private func clearProgresses()
    {
        for index in 0...self.stories!.count - 1
        {
            let progressView = self.stackProgress.arrangedSubviews[index] as! UIProgressView
            progressView.setProgress(0, animated: false);
        }
    }
}
