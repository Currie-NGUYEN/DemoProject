//
//  MovieDefaultCell.swift
//  demo1
//
//  Created by Currie on 4/15/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import Kingfisher

protocol MovieDefaultCellDelegate {
    func willRemoveFavorite(idFavorite: Int)
    func didAddFavorite()
}

class MovieDefaultCell: UICollectionViewCell {
    
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var favoristeButton: UIButton!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    let favoriteService = FavoriteService()
    
    var delegate: MovieDefaultCellDelegate?
    var movie: Movie!{
        didSet {
            let urlImage = URL(string: MovieService.baseImageUrl+movie.poster)
            
            self.movieTitle.text = movie.name
            self.posterImage.kf.setImage(with: urlImage)
            self.releaseDate.text = "\(movie.releaseDate)"
            self.rating.text = "\(movie.rating)/10"
            self.overview.text = movie.overview
            self.favoristeButton.addTarget(self, action: #selector(toggleFavorite(_:)), for: .touchUpInside)
            if favoriteService.getFavoriteByIdMovie(idMovie: movie.id) != nil {
                self.favoristeButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                self.favoristeButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        overview.textContainer.maximumNumberOfLines = 3
        overview.textContainer.lineBreakMode = .byTruncatingTail
        
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        
    }
    
    @objc func toggleFavorite(_ sender: UIButton){
        guard let favorite = favoriteService.getFavoriteByIdMovie(idMovie: movie.id) else {
            
            favoriteService.insertFavorite(movie: movie)
            delegate?.didAddFavorite()
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            return
        }
        
        delegate?.willRemoveFavorite(idFavorite: favorite.id)
    }
}
