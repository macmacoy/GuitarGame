//
//  PlayedSongsTypeTableViewCell.swift
//  JamSesh
//
//  Created by Mac Macoy on 12/22/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import Foundation
import UIKit

class PlayedSongsTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var songCountLabel: UILabel!
    
    var songMasteryType = SongMasteryType.Mastered
}
