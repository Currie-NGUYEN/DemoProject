//
//  MovieGridCell.swift
//  demo1
//
//  Created by Currie on 4/15/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import Kingfisher

class MovieGridCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    let favoriteService = FavoriteService()
    var movie: Movie!{
        didSet{
            let urlImage = URL(string: MovieService.baseImageUrl+movie.poster)
            self.posterImage.kf.setImage(with: urlImage)
            self.movieTitle.text = movie.name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
