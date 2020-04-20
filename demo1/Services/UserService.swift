
//
//  UserService.swift
//  demo1
//
//  Created by Currie on 4/17/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation

class UserService {
    
    let defaults = UserDefaults.standard
    
    func loadUser(completion: (UserInfor?)->()){
        let dataUSer = defaults.object(forKey: "UserInfor")
        if dataUSer != nil{
            do {
                let userInfor = try JSONDecoder().decode(UserInfor.self, from: dataUSer as! Data)
                completion(userInfor)
            } catch {
                print(error.localizedDescription)
            }} else {
            completion(nil)
        }
    }
    
    func saveUser(user: UserInfor,completion: (Bool)->()){
        do {
            let json  = try JSONEncoder().encode(user)
            defaults.removeObject(forKey: "UserInfor")
            defaults.set(json, forKey: "UserInfor")
            completion(true)
        } catch {
            print(error)
            completion(true)
        }
    }
    
    func loadSettings(completion: (Settings?)->()){
        let dataSettings = defaults.object(forKey: "Settings")
        if dataSettings != nil{
            do {
                let settings = try JSONDecoder().decode(Settings.self, from: dataSettings as! Data)
                completion(settings)
            } catch {
                print(error.localizedDescription)
            }} else {
            completion(nil)
        }
    }
    
    func saveSetting(settings: Settings,completion: (Bool)->()){
        do {
            let json  = try JSONEncoder().encode(settings)
            defaults.removeObject(forKey: "Settings")
            defaults.set(json, forKey: "Settings")
            completion(true)
        } catch {
            print(error)
            completion(true)
        }
    }
    
}
