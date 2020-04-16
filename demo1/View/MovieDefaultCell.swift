//
//  MovieDefaultCell.swift
//  demo1
//
//  Created by Currie on 4/15/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class MovieDefaultCell: UICollectionViewCell {

    @IBOutlet weak var overview: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        overview.textContainer.maximumNumberOfLines = 3
        overview.textContainer.lineBreakMode = .byTruncatingTail
    }

}
