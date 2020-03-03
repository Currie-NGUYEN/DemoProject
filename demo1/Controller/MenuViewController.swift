//
//  MenuViewController.swift
//  demo1
//
//  Created by Currie on 3/2/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    //MARK: -properties
    
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var reminderList: UITableView!
    
    let defaults = UserDefaults.standard
    //MARK: -init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataUSer = defaults.object(forKey: "UserInfor")
        if(dataUSer != nil){
            let userInfor = dataUSer as! UserInfor
//            self.imageAvatar.image = dataUSer.avartar
            self.name.text = userInfor.name
            let timeInterval = Double(userInfor.birthday)
            self.birthday.text = ("\(Date(timeIntervalSince1970: timeInterval))")
            self.email.text = userInfor.email
            self.gender.text = userInfor.gender ? "Male" : "Female"
        }else{
            self.name.text = "null"
            self.birthday.text = "null"
            self.email.text = "null"
            self.gender.text = "null"
        }
        // Do any additional setup after loading the view.
    }
    
    //MARK: -Handler

    @IBAction func showAll(_ sender: UIButton) {
    }
}
