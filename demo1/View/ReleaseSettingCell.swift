//
//  ReleaseSettingCell.swift
//  demo1
//
//  Created by Currie on 4/15/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class ReleaseSettingCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var yearButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
