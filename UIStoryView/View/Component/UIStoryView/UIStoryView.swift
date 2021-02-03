//
//  UIStoryView.swift
//  UIStoryView
//
//  Created by Volkan SÖNMEZ on 30.01.2021.
//  Copyright © 2021 Porte. All rights reserved.
//

import Foundation
import UIKit

public class UIStoryView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    private var sections: [IStorySection]!
    
    private var rootViewController: UIViewController?
    
    private var cellSize: CGSize?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.podBundle.loadNibNamed("UIStoryView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [ .flexibleWidth, .flexibleHeight]
    }
    
    public func setSections(sections: [IStorySection]) {
        self.sections = sections
        
        initCollectionView()
    }
    
    public func setRootViewController(root: UIViewController) {
        self.rootViewController = root
    }
}

extension UIStoryView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func initCollectionView() {
        collectionView.register(UINib.init(nibName: "SectionCell", bundle: Bundle.podBundle), forCellWithReuseIdentifier: "SectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as? SectionCell {
            cell.bind(section: sections[indexPath.row])
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storiesBuilder = StoriesBuilder(stories: sections)
            .setMoveToSection(section: indexPath.row)
            .build()
        
        storiesBuilder.modalPresentationStyle = .fullScreen
        rootViewController?.present(storiesBuilder, animated: true, completion: nil)
    }
}

extension UIStoryView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if cellSize == nil {
            cellSize = CGSize(width: collectionView.frame.height - 20, height: collectionView.frame.height)
        }
        
        return cellSize!
    }
}
