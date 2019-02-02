//
//  ChordColors.swift
//  GuitarGame
//
//  Created by Mac Macoy on 11/2/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class Colors {
    
    // colors
    let pink = #colorLiteral(red: 1, green: 0.4784313725, blue: 0.6980392157, alpha: 1)
    let orange = #colorLiteral(red: 0.9960784314, green: 0.5098039216, blue: 0.4392156863, alpha: 1)
    let turquoise = #colorLiteral(red: 0.4588235294, green: 0.8196078431, blue: 0.7450980392, alpha: 1)
    let purple = #colorLiteral(red: 0.4232553542, green: 0.4036055803, blue: 0.6480110288, alpha: 1)
    let green = #colorLiteral(red: 0.6274509804, green: 0.8509803922, blue: 0.4588235294, alpha: 1)
    let blue = #colorLiteral(red: 0, green: 0.7333333333, blue: 1, alpha: 1)
    
    static let navigationBarColor = #colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1)
    static let navigationItemColor = #colorLiteral(red: 0.999904573, green: 1, blue: 0.999872148, alpha: 1)
    
    static let defaultBackgroundColor = #colorLiteral(red: 0.2705882353, green: 0.5882352941, blue: 0.6784313725, alpha: 1)
    static let unselectedTabItemColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    static let selectedTabItemColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    
    let white = #colorLiteral(red: 0.999904573, green: 1, blue: 0.999872148, alpha: 1)
    let gray = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    let darkGray = #colorLiteral(red: 0.1601860225, green: 0.1646207571, blue: 0.1861758828, alpha: 1)
    
    // chords
    private let rootNotes = ["A","A#","B","C","C#","D","D#","E","F","F#","G","G#"]
    private let variations = ["", "m", "6", "7", "9", "m6", "m7", "maj7", "sus", "sus4", "sus2", "add9", "2"]
    
    init() {}
    
    let chordNotHit = #colorLiteral(red: 0.6746457219, green: 0.670637548, blue: 0.6777282357, alpha: 1)
    func chordHit(hitScore: Double) -> UIColor {
        return #colorLiteral(red: 0.5033690333, green: 0.6937516332, blue: 0.3750092387, alpha: 1)
    }
    
}

extension UIColor {
    
    convenience init(rgbColorCodeRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        
        let redPart: CGFloat = CGFloat(red) / 255
        let greenPart: CGFloat = CGFloat(green) / 255
        let bluePart: CGFloat = CGFloat(blue) / 255
        
        self.init(red: redPart, green: greenPart, blue: bluePart, alpha: alpha)
        
    }
}
