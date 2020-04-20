//
//  MenuViewController.swift
//  demo1
//
//  Created by Currie on 3/2/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SWRevealViewController

class MenuViewController: UIViewController {
    
    //MARK: -properties
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var reminderList: UITableView!
    
    let defaults = UserDefaults.standard
    let cellIdentifier = "ReminderCell"
    let userService = UserService()
    let reminderService = RemindersService()
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var reminders = [Reminder]()
    
    //MARK: -init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
                return
        }
        sceneDelegate.delegate = self
        
        imageAvatar.layer.cornerRadius = 0.5 * imageAvatar.bounds.size.width
        imageAvatar.clipsToBounds = true
        
        reminderList.delegate = self
        reminderList.dataSource = self
        reminderList.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        
        activityView.color = .black
        activityView.frame = CGRect(x: (350-100)/2 , y: view.frame.midY - 100/2, width: 100, height: 100)
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
        view.addSubview(activityView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userService.loadUser { (userInfor) in
            if userInfor != nil {
                self.imageAvatar.image = userInfor!.avartar.decodeImageFromBase64()
                self.name.text = userInfor!.name
                guard let birthday = userInfor!.birthday else {
                    return
                }
                self.birthday.text = birthday.dateFormater()
                self.email.text = userInfor!.email
                self.gender.text = userInfor!.gender ? "Male" : "Female"
            } else {
                self.imageAvatar.image = #imageLiteral(resourceName: "sad-face").withRenderingMode(.alwaysOriginal)
                self.name.text = "unknown"
                self.birthday.text = "unknown"
                self.email.text = "unknown"
                self.gender.text = "unknown"
            }
            activityView.stopAnimating()
        }
        loadReminder()
    }
    
    func loadReminder(){
        guard let reminders = reminderService.getAllReminders() else {
            return
        }
        self.reminders = reminders
        reminderList.reloadData()
    }
    
    @IBAction func moveToEdit(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    //MARK: -Handler
    @IBAction func showAll(_ sender: UIButton) {
        self.revealViewController()?.revealToggle(animated: true)
        (self.revealViewController()?.frontViewController as! TabBarController).moveToSettings()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.frame = CGRect(x: 0, y: 0, width: 350 , height: self.view.frame.size.height)
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if reminders.count > 2 {
            return 2
        } else {
            return reminders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reminderList.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ReminderCell
        cell.reminder = reminders[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension UIImage {
    func encodeImageFromBase64() -> String {
        let imageData:NSData = self.pngData()! as NSData
        let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
        return strBase64
    }
    
    
}

extension String {
    func decodeImageFromBase64() -> UIImage {
        let dataDecoded:Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        return decodedimage
    }
}

extension MenuViewController: EditDelegate {
    func didEdit() {
        userService.loadUser { (userInfor) in
            if userInfor != nil {
                self.imageAvatar.image = userInfor!.avartar.decodeImageFromBase64()
                self.name.text = userInfor!.name
                guard let birthday = userInfor!.birthday else {
                    return
                }
                self.birthday.text = birthday.dateFormater()
                self.email.text = userInfor!.email
                self.gender.text = userInfor!.gender ? "Male" : "Female"
            } else {
                self.imageAvatar.image = UIImage(systemName: "person.circle")
                self.name.text = "null"
                self.birthday.text = "null"
                self.email.text = "null"
                self.gender.text = "null"
            }
        }
    }
}

extension MenuViewController: NotifyDelegate {
    func didTapNotification() {
        self.revealViewController()?.revealToggle(animated: true)
        (self.revealViewController()?.frontViewController as! TabBarController).moveToSettings()
    }
}
