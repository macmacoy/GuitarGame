//
//  ChordChartUIImageFactory.swift
//  JamSesh
//
//  Created by Mac Macoy on 1/11/19.
//  Copyright © 2019 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class ChordCartUIImageFactory {
    
    private init() {}
    
    static func make(chord: String) -> UIImage {
        return UIImage(named: "art.scnassets/ChordCharts/" + chord + ".png")!
    }
}
