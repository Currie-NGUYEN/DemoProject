//
//  Reminder.swift
//  demo1
//
//  Created by Currie on 4/18/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import SQLite

class RemindersService {
    var database: Connection!
    
    let remindersList = Table("reminders")
    
    let id = Expression<Int>("id")
    let idReminder = Expression<String>("idReminder")
    let idMovie = Expression<Int>("idMovie")
    let name = Expression<String>("name")
    let yearRelease = Expression<String>("yearRelease")
    let rating = Expression<Double>("rating")
    let posterImage = Expression<String>("posterImage")
    let overview = Expression<String>("overview")
    let timeReminder = Expression<Double>("timeReminder")
    
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
        let createTable = self.remindersList.create{ (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.idMovie)
            table.column(self.idReminder)
            table.column(self.name)
            table.column(self.yearRelease)
            table.column(self.rating)
            table.column(self.posterImage)
            table.column(self.overview)
            table.column(self.timeReminder)
        }
        
        do {
            try self.database.run(createTable)
            
        } catch {
            print("error: \(error))")
        }
    }
    
    func insertReminder(movie: Movie, timeReminder: Double, idReminder: String) {
        let insertReminder = self.remindersList.insert(self.idMovie <- movie.id, self.idReminder <- idReminder, self.name <- movie.name, self.yearRelease <- movie.releaseDate, self.rating <- Double(movie.rating), self.posterImage <- movie.poster, self.overview <- movie.overview, self.timeReminder <- timeReminder)
        do {
            try self.database.run(insertReminder)
            
        } catch{
            print(error)
        }
    }
    
    func updateReminder(id: Int, reminder: Reminder) {
        let oldReminder = self.remindersList.filter(self.id == id)
        let updaterReminder = oldReminder.update(self.idMovie <- reminder.movie.id, self.idReminder <- reminder.idReminder, self.name <- reminder.movie.name, self.yearRelease <- reminder.movie.releaseDate, self.rating <- Double(reminder.movie.rating), self.posterImage <- reminder.movie.poster, self.overview <- reminder.movie.overview, self.timeReminder <- reminder.timeReminder)
        do {
            try self.database.run(updaterReminder)
        } catch {
            print(error)
        }
    }
    
    func getReminder(id: Int) -> Reminder? {
        let reminderQuery = self.remindersList.filter(self.id == id)
        do {
            let reminder = try self.database.pluck(reminderQuery)!
            return convertToObject(data: reminder)
        } catch {
            print(error)
            return nil
        }
    }
    
    func getAllReminders() -> [Reminder]? {
        do {
            let reminders = try self.database.prepare(self.remindersList)
            
            let listReminders = reminders.map { (row) -> Reminder in
                return convertToObject(data: row)
            }.sorted(by: { (r1, r2) -> Bool in
                return r1.timeReminder > r2.timeReminder
            })
            return listReminders
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteReminder(id: Int) {
        let reminder = self.remindersList.filter(self.id == id)
        let deleteReminder = reminder.delete()
        do {
            try self.database.run(deleteReminder)
        } catch {
            print(error)
        }
    }
    
    func deleteTable() {
        let delete = remindersList.drop(ifExists: true)
        do {
            try self.database.run(delete)
            
        } catch {
            print(error)
        }
    }
    
    func convertToObject(data: Row) -> Reminder{
        return Reminder(id: data[self.id], idReminder: data[self.idReminder], movie: Movie(id: data[self.idMovie], name: data[self.name], poster: data[self.posterImage], releaseDate: data[self.yearRelease], rating: Float(data[self.rating]), overview: data[self.overview]), timeReminder: data[self.timeReminder])
    }
}
