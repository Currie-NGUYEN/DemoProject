//
//  TabBarController.swift
//  demo1
//
//  Created by Currie on 4/14/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    @IBOutlet weak var tabBarCustom: UITabBar!
    
    let menu = MenuViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
//        menu.delegate = self
        
        
        tabBarCustom.barTintColor = .systemIndigo
        tabBarCustom.tintColor = .white
        // Do any additional setup after loading the view.
    }
}

//extension TabBarController: MenuDelegate{
//    func moveToReminders() {
//        print("ss")
//    }
//    
//    
//}

