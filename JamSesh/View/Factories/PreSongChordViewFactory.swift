//
//  PreSongChordViewFactory.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/30/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class PreSongChordViewFactory {
    
    private let colors = Colors()
    
    init(){}
    
    func makeChordView(chord: String, cellRect: CGRect) -> UILabel {
        let lyricView = UILabel(frame: cellRect)
        let textAttributes: [NSAttributedString.Key : Any] = [
            .strokeColor : colors.blue,
            .foregroundColor : colors.darkGray,
            .strokeWidth : -2.5,
            ]
        lyricView.attributedText = NSAttributedString(string: chord, attributes: textAttributes)
        lyricView.textAlignment = NSTextAlignment.center
        lyricView.font = UIFont(name: ViewConstants.font + " Bold", size: 20)
        lyricView.font = lyricView.font.withSize(20)
        lyricView.numberOfLines = 0 // use as many lines as needed
        return lyricView
    }
}
