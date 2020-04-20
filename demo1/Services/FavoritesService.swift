//
//  Favorites.swift
//  demo1
//
//  Created by Currie on 4/18/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import SQLite

class FavoriteService {
    var database: Connection!
    
    let favoriteTable = Table("favorites")
    
    let id = Expression<Int>("id")
    let idMovie = Expression<Int>("idMovie")
    let name = Expression<String>("name")
    let yearRelease = Expression<String>("yearRelease")
    let rating = Expression<Double>("rating")
    let posterImage = Expression<String>("posterImage")
    let overview = Expression<String>("overview")
    
    //MARK: - init
    init() {
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("demo").appendingPathExtension("sqlite3")
            let database =  try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    //MARK: - handler
    func createTable() {
        let createTable = self.favoriteTable.create{ (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.idMovie)
            table.column(self.name)
            table.column(self.yearRelease)
            table.column(self.rating)
            table.column(self.posterImage)
            table.column(self.overview)
        }
        
        do {
            try self.database.run(createTable)
            
        } catch {
            print("error: \(error))")
        }
    }
    
    func insertFavorite(movie: Movie) {
        let insertFavorite = self.favoriteTable.insert(self.idMovie <- movie.id, self.name <- movie.name, self.yearRelease <- movie.releaseDate, self.rating <- Double(movie.rating), self.posterImage <- movie.poster, self.overview <- movie.overview)
        do {
            try self.database.run(insertFavorite)
            
        } catch{
            print(error)
        }
    }
    
    func updateFavorite(id: Int, movie: Movie) {
        let favorite = self.favoriteTable.filter(self.id == id)
        let updateFavorite = favorite.update(self.idMovie <- movie.id, self.name <- movie.name, self.yearRelease <- movie.releaseDate, self.rating <- Double(movie.rating), self.posterImage <- movie.poster, self.overview <- movie.overview)
        do {
            try self.database.run(updateFavorite)
        } catch {
            print(error)
        }
    }
    
    func getFavorite(id: Int) -> Favorite? {
        let favoriteQuery = self.favoriteTable.filter(self.id == id)
        do {
            let favorite = try self.database.pluck(favoriteQuery)!
            return convertToObject(data: favorite)
        } catch {
            print(error)
            return nil
        }
    }
    
    func getFavoriteByIdMovie(idMovie: Int) -> Favorite? {
        let favoriteQuery = self.favoriteTable.filter(self.idMovie == idMovie)
        do {
            guard let favorite = try self.database.pluck(favoriteQuery) else {
                return nil
            }
            return convertToObject(data: favorite)
        } catch {
            print(error)
            return nil
        }
    }
    
    func getAllFavorites() -> [Favorite]? {
        do {
            let favorites = try self.database.prepare(self.favoriteTable)
            
            let listFavorites = favorites.map { (row) -> Favorite in
                return convertToObject(data: row)
            }
            return listFavorites.reversed()
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteFavorite(id: Int) {
        let favorite = self.favoriteTable.filter(self.id == id)
        let deleteFavorite = favorite.delete()
        do {
            try self.database.run(deleteFavorite)
        } catch {
            print(error)
        }
    }
    
    func deleteTable() {
        let delete = favoriteTable.drop(ifExists: true)
        do {
            try self.database.run(delete)
            
        } catch {
            print(error)
        }
    }
    
    func convertToObject(data: Row) -> Favorite{
        return Favorite(id: data[self.id], movie: Movie(id: data[self.idMovie], name: data[self.name], poster: data[self.posterImage], releaseDate: data[self.yearRelease], rating: Float(data[self.rating]), overview: data[self.overview]))
    }
}
