//
//  MenuViewConstants.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/30/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class MenuViewConstants {
    
    // PrePlaySongViewController
    let fingerChartsPerRow = 2
    let spaceBetweenFingerCharts = 5 // pixels
    
    init() {}
    
    // PrePlaySongViewController
    func prePlayChordUICollectionViewCellSize(uiCollectionViewSize: CGRect) -> CGSize {
        let width = uiCollectionViewSize.width/CGFloat(fingerChartsPerRow) - CGFloat(spaceBetweenFingerCharts)
        let height = width
        return CGSize(width: width, height: height)
    }
    
}
