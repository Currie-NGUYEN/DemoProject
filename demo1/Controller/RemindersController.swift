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
    let reminderService = RemindersService()
    
    var reminders = [Reminder]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listReminders.delegate = self
        listReminders.dataSource = self
        listReminders.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "All Reminders"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        load()
    }
    
    func load() {
        guard let reminders = reminderService.getAllReminders()  else {
            return
        }
        self.reminders = reminders
        listReminders.reloadData()
    }
}

extension RemindersController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listReminders.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ReminderCell
        cell.reminder = reminders[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = reminders[indexPath.row].movie
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        vc.navigationItem.title = movie.name
        vc.idMovie = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteAction(at indexpath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "Are you sure you want to delete this reminder?", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [self.reminders[indexpath.row].idReminder])
                    self.reminderService.deleteReminder(id: self.reminders[indexpath.row].id)
                    self.load()
                }))
                self.present(alert, animated: true)
            }
        }
        action.backgroundColor = .red
        return action
    }
}
