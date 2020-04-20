//
//  TabBarController.swift
//  demo1
//
//  Created by Currie on 4/14/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SWRevealViewController

protocol TabBarDelegate {
    func moveToReminders()
}

class TabBarController: UITabBarController {
    
    @IBOutlet weak var tabBarCustom: UITabBar!
    var delegateCT: TabBarDelegate?
    
    let menu = MenuViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rightViewRevealOverdraw = 100.0
        
        tabBarCustom.barTintColor = .systemIndigo
        tabBarCustom.tintColor = .white
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
          return
        }
        sceneDelegate.delegate = self
    }
    
    func moveToSettings(){
        self.selectedIndex = 2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.delegateCT?.moveToReminders()
        }
    }
}
extension TabBarController: NotifyDelegate {
    func didTapNotification() {
        moveToSettings()
    }
}
