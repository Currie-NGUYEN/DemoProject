//
//  LocalDatabase.swift
//  demo1
//
//  Created by Currie on 3/4/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import SQLite

class LocalDatabase{
    //MARK: - properties
    var database: Connection!
    
    let userTable = Table("userInfor")
    let favoriteTable = Table("favorite")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let birthday = Expression<Int>("birthday")
    let gender = Expression<Bool>("gender")
    let favorite = Expression<String>("gender")
    let reminder = Expression<String>("reminder")
    
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
        let createTable = self.userTable.create{ (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.birthday)
            table.column(self.gender)
            table.column(self.favorite)
            table.column(self.reminder)
        }
        
        do {
            try self.database.run(createTable)
            print("Created table")
        } catch {
            print(error)
        }
    }
    
    func insertUser(name:String, birthday: Int, gender: Bool, favorite: String, reminder: String) {
        let insertUser = self.userTable.insert(self.name <- name, self.birthday <- birthday, self.gender <- gender, self.favorite <- favorite, self.reminder <- reminder)
        do {
            try self.database.run(insertUser)
            print("Inserted user")
        } catch{
            print(error)
        }
    }
    
    func updateUser(id: Int, name:String, birthday: Int, gender: Bool, favorite: String, reminder: String) {
        let user = self.userTable.filter(self.id == id)
        let updateUser = user.update(self.name <- name, self.birthday <- birthday, self.gender <- gender, self.favorite <- favorite, self.reminder <- reminder)
        do {
            try self.database.run(updateUser)
        } catch {
            print(error)
        }
    }
    
    func getUser(id: Int) -> Row? {
        let userQuery = self.userTable.filter(self.id == id)
        do {
           let user = try self.database.pluck(userQuery)!
            return user
        } catch {
            print(error)
            return nil
        }
    }
    
    func getAllUsers() -> AnySequence<Row>? {
        do {
            let users = try self.database.prepare(self.userTable)
            print("Got all users")
            return users
        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteUSer(id: Int) {
        let user = self.userTable.filter(self.id == id)
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }
    }
}
