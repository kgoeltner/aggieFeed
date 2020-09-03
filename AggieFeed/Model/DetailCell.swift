//
//  DetailCell.swift
//  AggieFeed
//
//  Created by Karl Goeltner on 9/3/20.
//  Copyright © 2020 Karl Goeltner. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var objectTypeLabel: UILabel!
    @IBOutlet weak var publishedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
