//
//  MovieService.swift
//  demo1
//
//  Created by Currie on 4/17/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MovieService {
    
    private let baseApiUrl = "https://api.themoviedb.org/3/movie/"
    static let baseImageUrl = "https://image.tmdb.org/t/p/w185"
    private let keyApiParam = ["api_key" : "0267c13d8c7d1dcddb40001ba6372235"]
    
    
    func fetchMovies(movieType: String,completion: @escaping ([Movie])-> Void) {
        var listMovies: [Movie] = [Movie]()
        AF.request(baseApiUrl+movieType, method: .get, parameters: keyApiParam).responseJSON { (response) in
            do {
                let json = try JSON(data: response.data!)
                json["results"].array?.forEach({ (movie) in
                    let movie = Movie(id: movie["id"].int!, name: movie["original_title"].string!, poster: movie["poster_path"].string!, releaseDate: movie["release_date"].string!, rating: movie["vote_average"].float!, overview: movie["overview"].string!)
                    listMovies.append(movie)
                })
                completion(listMovies)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchDetail(id: Int,completion: @escaping (Movie)-> Void) {
        AF.request(baseApiUrl+"\(id)", method: .get, parameters: keyApiParam).responseJSON { (response) in
            do {
                let movie = try JSON(data: response.data!)
                let result = Movie(id: movie["id"].int!, name: movie["original_title"].string!, poster: movie["poster_path"].string!, releaseDate: movie["release_date"].string!, rating: movie["vote_average"].float!, overview: movie["overview"].string!)
                completion(result)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
