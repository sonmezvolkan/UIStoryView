//
//  UIImageViewExtension.swift
//  UIStoryView
//
//  Created by Volkan Sonmez on 24.12.2019.
//  Copyright © 2019 Porte. All rights reserved.
//

import Foundation
import UIKit;
import SDWebImage;

extension UIImageView
{
    public func downloadImageWithoutPlaceHolder(link: String?, mode: ContentMode = ContentMode.scaleToFill, completion: @escaping (Bool) -> Void)
    {
        self.isHidden = true;
        if (link != nil)
        {
            if let url = URL(string: link!)
            {
                self.sd_setImage(with: url) { (image, error, cacheType, url) in
                    self.isHidden = false;
                    self.image = image;
                    completion(true);
                }
                self.contentMode = mode;
            }
        }
    }
    
    public func downloadImage(link: String?, mode: ContentMode = ContentMode.scaleToFill) {
        self.isHidden = true;
        
        if (link != nil) {
            if let url = URL(string: link!) {
                self.sd_setImage(with: url) { (image, error, cacheType, url) in
                    self.isHidden = false;
                    self.image = image;
                }
                self.contentMode = mode;
            }
        }
    }
    
    public func startGif(resourceName: String) {
        guard let path = Bundle.main.path(forResource: resourceName, ofType: "gif") else { return }
        let url = URL(fileURLWithPath: path)
        guard let gifData = try? Data(contentsOf: url),
            let source =  CGImageSourceCreateWithData(gifData as CFData, nil) else { return }
        var images = [UIImage]()
        let imageCount = CGImageSourceGetCount(source)
        for index in 0 ..< imageCount {
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(UIImage(cgImage: image))
            }
        }
        self.animationDuration = 1.2
        self.animationRepeatCount = 40
        self.animationImages = images
        self.startAnimating()
    }
}
