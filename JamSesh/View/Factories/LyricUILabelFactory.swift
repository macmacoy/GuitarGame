//
//  LyricUILabelFactory.swift
//  GuitarGame
//
//  Created by Mac Macoy on 11/17/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class LyricUILabelFactory {
    
    private let viewConstants = ViewConstants()
    private let colors = Colors()
    
    init(){}
    
    func makeLyricView(lyric: String) -> UILabel {
        let lyricView = UILabel(frame: viewConstants.lyricStartingRect)
        // if you want a border
        let textAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : #colorLiteral(red: 0.9960784314, green: 0.5098039216, blue: 0.4392156863, alpha: 1),
            .foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            .strokeWidth : -2.5,
            ]
//        let textAttributes: [NSAttributedString.Key : Any] = [
//            .foregroundColor : #colorLiteral(red: 0.1215218306, green: 0.1215218306, blue: 0.1215218306, alpha: 1),
//            .strokeWidth : -2.5,
//            ]
        lyricView.attributedText = NSAttributedString(string: lyric, attributes: textAttributes)
        lyricView.textAlignment = NSTextAlignment.center
        lyricView.font = UIFont(name: ViewConstants.font + " Bold", size: 20)
        lyricView.font = lyricView.font.withSize(30)
        lyricView.numberOfLines = 0 // use as many lines as needed
        lyricView.alpha = 0.0
        return lyricView
    }
}
