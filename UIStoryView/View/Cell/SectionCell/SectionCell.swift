//
//  SectionCell.swift
//  UIStoryView
//
//  Created by Volkan SÖNMEZ on 30.01.2021.
//  Copyright © 2021 Porte. All rights reserved.
//

import Foundation
import UIKit

public class SectionCell: UICollectionViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    public func bind(section: IStorySection) {
        prepareCotnainerView(section: section)
        containerView.backgroundColor = section.borderColor
        
        lblTitle.text = section.title
        imgThumbnail.downloadImageWithoutPlaceHolder(link: section.thumbnail, completion: { [weak self] isFinished in

        })
    }
    
    private func prepareCotnainerView(section: IStorySection) {
//        print("width: \(containerView.frame.size.width)  height: \(containerView.frame.size.height)")
//        containerView.layer.cornerRadius = 58
//        containerView.clipsToBounds = true
//        containerView.layer.masksToBounds = true
//        
//        
//        containerView.layer.borderColor = section.borderColor?.cgColor
//        containerView.layer.borderWidth = 0.0
    }
}
