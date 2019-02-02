//
//  SongSearchResultTableViewCell.swift
//  JamSesh
//
//  Created by Mac Macoy on 11/29/18.
//  Copyright © 2018 Mac Macoy. All rights reserved.
//

import UIKit

class SongSearchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var songArtist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
