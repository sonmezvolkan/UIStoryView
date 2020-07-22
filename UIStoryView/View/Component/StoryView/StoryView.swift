//
//  StoryView.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 24.12.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation
import UIKit;
import AVKit

public class StoryView: UIView
{
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    public var onLoadDidEnd: ((Bool) -> Void)?;
    public var isLastStory: Bool?;
    
    private var storyModel: IStory?;
    private var isLoaded: Bool = false;
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    
    private var isStalled: Bool = false
    
    init(frame: CGRect, storyModel: IStory)
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
        guard let storyModel = self.storyModel else { return }
        storyModel.isTypeImage ? setImageStoryControls() : setVideoStoryControls()
    }
    
    private func setImageStoryControls()
    {
        self.imgView.frame = self.bounds;
    }
    
    private func setVideoStoryControls()
    {
        imgView.isHidden = true
        
        playerLayer?.frame = self.contentView.bounds
    }
    
    private func getStory()
    {
        guard let storyModel = self.storyModel else { return }
        storyModel.isTypeImage ? getImageStory() : getVideoStory()
    }
    
    private func getImageStory() {
        if let storyModel = self.storyModel
        {
            self.imgView.downloadImageWithoutPlaceHolder(link: storyModel.getPath()) { (flag) in
                self.isLoaded = true;
                self.onLoadDidEnd?(true);
            }
        }
    }
    
    private func getVideoStory() {
        guard let storyModel = self.storyModel, let url = URL(string: storyModel.getPath()) else { return }
        
        player = AVPlayer(url: url)
        self.playerLayer = AVPlayerLayer(player: player)
        NotificationCenter.default.addObserver(self, selector: #selector(self.stalled(notification:)),
                                                    name: NSNotification.Name.AVPlayerItemPlaybackStalled,
                                                    object: nil)
//        self.player!.addObserver(self, forKeyPath: "status", options: [], context: nil);
        self.player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { (cmTime) in
            if (self.player!.currentItem?.status == .readyToPlay)
            {
                self.videoLoaded()
                let time : Float64 = CMTimeGetSeconds(self.player!.currentTime());
                print("\(Float(time))   rate \(self.player!.rate)");
            }
        });
        playerLayer?.frame = self.bounds;
        self.contentView.layer.addSublayer(playerLayer!);

    }
    
    @objc private func stalled(notification: NSNotification)
    {
        self.isStalled = true
    }
    
    private func videoLoaded() {
        if !isLoaded {
            isLoaded = true
            onLoadDidEnd?(true)
        }
    }
    
    public func play() {
        player?.play()
    }
    
    public func rePlay() {
        player?.seek(to: CMTime.zero)
    }
    
    public func pause() {
        player?.pause()
    }
}

extension StoryView
{
    public func getIsLoaded() -> Bool
    {
        return self.isLoaded;
    }
    
    public func getIsStalled() -> Bool {
        return isStalled
    }
    
    public func dismissAVPlayer() {
        
    }
}
