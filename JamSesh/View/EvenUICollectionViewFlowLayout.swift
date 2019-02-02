//
//  EvenUICollectionViewFlowLayout.swift
//  JamSesh
//
//  Created by Mac Macoy on 12/24/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class EvenUICollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var placeEqualSpaceAroundAllCells: Bool = true
    
    override func prepare() {
        super.prepare()
        
        if self.placeEqualSpaceAroundAllCells {
            var contentByItems : ldiv_t
            
            let contentSize: CGSize = self.collectionViewContentSize
            let itemSize = self.itemSize
            if UICollectionView.ScrollDirection.vertical == self.scrollDirection {
                contentByItems = ldiv (Int(contentSize.width), Int(itemSize.width))
            }
            else {
                contentByItems = ldiv (Int (contentSize.height), Int (itemSize.height))
            }
            let layoutSpacingValue: CGFloat = CGFloat(NSInteger(CGFloat(contentByItems.rem)/CGFloat(contentByItems.quot+1)))
            let originalMinimumLineSpacing = self.minimumLineSpacing
            let originalMinimumInteritemSpacing = self.minimumInteritemSpacing
            let originalSectionInset = self.sectionInset
            if ((layoutSpacingValue != originalMinimumLineSpacing) ||
                (layoutSpacingValue != originalMinimumInteritemSpacing) ||
                (layoutSpacingValue != originalSectionInset.left) ||
                (layoutSpacingValue != originalSectionInset.right) ||
                (layoutSpacingValue != originalSectionInset.top) ||
                (layoutSpacingValue != originalSectionInset.bottom))
            {
                let insetsForItem = UIEdgeInsets.init(top: layoutSpacingValue, left: layoutSpacingValue, bottom: layoutSpacingValue, right: layoutSpacingValue)
                self.minimumLineSpacing = layoutSpacingValue
                self.minimumInteritemSpacing = layoutSpacingValue
                self.sectionInset = insetsForItem
            }
        }
    }
    
}
