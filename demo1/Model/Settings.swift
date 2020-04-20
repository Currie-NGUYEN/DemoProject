//
//  Settings.swift
//  demo1
//
//  Created by Currie on 4/17/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation

enum MovieType {
    case Popular
    case TopRated
    case UpComming
    case NowPlaying
}

enum SortBy {
    case ReleaseDate
    case Rating
}

class Settings: Codable {
    var type: String
    var rating: Float
    var yearRelease: Int
    var sortBy: String
    
    init(type: String,rating: Float,yearRelease: Int,sortBy: String) {
        self.type = type
        self.rating = rating
        self.yearRelease = yearRelease
        self.sortBy = sortBy
    }
}
