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
}
