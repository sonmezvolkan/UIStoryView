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
    
    @IBOutlet var containerView: CircleView!
    @IBOutlet var imgThumbnail: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    public func bind(section: IStorySection) {
        prepareContainerView(section: section)
        prepareImageView()
        
        lblTitle.text = section.title
        imgThumbnail.downloadImageWithoutPlaceHolder(link: section.thumbnail, completion: { isFinished in

        })
        imgThumbnail.isHidden = true
    }
    
    private func prepareImageView() {
        imgThumbnail.layer.cornerRadius = imgThumbnail.frame.width / 2
        imgThumbnail.clipsToBounds = true
    }
    
    private func prepareContainerView(section: IStorySection) {
        containerView.layer.borderColor = section.borderColor?.cgColor
        containerView.layer.borderWidth = 2.0
        containerView.layer.masksToBounds = true
    }
}
