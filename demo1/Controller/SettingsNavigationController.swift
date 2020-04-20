//
//  SettingsNavigationController.swift
//  demo1
//
//  Created by Currie on 4/16/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class SettingsNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func moveToReminders() {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersController") as! RemindersController
        navigationController?.pushViewController(vc, animated: true)
    }
}
