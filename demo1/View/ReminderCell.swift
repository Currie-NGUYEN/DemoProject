//
//  ReminderCell.swift
//  demo1
//
//  Created by Currie on 4/16/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var inforMovie: UILabel!
    @IBOutlet weak var timeReminder: UILabel!
    
    var reminder: Reminder! {
        didSet{
            poster.kf.setImage(with: URL(string: MovieService.baseImageUrl + reminder.movie.poster))
            inforMovie.text = "\(reminder.movie.name) - \(reminder.movie.releaseDate) - \(reminder.movie.rating)/10"
            timeReminder.text = reminder.timeReminder.dateFormater()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
