//
//  RemindersController.swift
//  demo1
//
//  Created by Currie on 4/16/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class RemindersController: UIViewController {

    @IBOutlet var listReminders: UITableView!
    let cellIdentifier = "ReminderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        listReminders.delegate = self
        listReminders.dataSource = self
        listReminders.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "All Reminders"
    }

}

extension RemindersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listReminders.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ReminderCell
        return cell
    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let 
//    }
}
