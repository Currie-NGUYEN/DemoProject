//
//  SettingsController.swift
//  demo1
//
//  Created by Currie on 4/14/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SWRevealViewController

class SettingsController: UIViewController {
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    let filters = ["Popular Movies", "Top Rated Movies", "Upcoming Movies", "NowPlaying Movies","Movies With Rate From","From Release Year"]
    let sortbys = ["Release Date","Rating"]
    let normalCell = "NormalSettingCell"
    let ratingCell = "RatingSettingCell"
    let releaseCell = "ReleaseSettingCell"
    let userService = UserService()
    
    var setting:Settings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userService.loadSettings { (setting) in
            if setting != nil{
                self.setting = setting
            } else {
                self.setting = Settings(type: "popular", rating: 0, yearRelease: 1970, sortBy: "rating")
            }
            table.delegate = self
            table.dataSource = self
        }
        (self.tabBarController as! TabBarController).delegateCT = self
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        
        self.revealViewController()?.rearViewRevealWidth = 350
        navigationController?.navigationBar.barTintColor = .systemIndigo
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Settings"
        
        
        table.register(UINib(nibName: normalCell, bundle: nil), forCellReuseIdentifier: normalCell)
        table.register(UINib(nibName: ratingCell, bundle: nil), forCellReuseIdentifier: ratingCell)
        table.register(UINib(nibName: releaseCell, bundle: nil), forCellReuseIdentifier: releaseCell)
    }
    
    @IBAction func didClickAllReminders(_ sender: Any) {
        moveToReminders()
    }
}

extension SettingsController: TabBarDelegate {
    func moveToReminders() {
        if navigationController?.topViewController?.restorationIdentifier != "RemindersController" {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RemindersController") as! RemindersController
            navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

extension SettingsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Filter"
        } else {
            return "Sort By"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return filters.count
        } else {
            return sortbys.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell!
        
        if indexPath.section == 0 {
            if filters[indexPath.row] == "Movies With Rate From" {
                cell = table.dequeueReusableCell(withIdentifier: ratingCell, for: indexPath)
                (cell as! RatingSettingCell).label.text = filters[indexPath.row]
                (cell as! RatingSettingCell).currentRating.text = "\(setting.rating)"
                (cell as! RatingSettingCell).slider.value = setting.rating
                (cell as! RatingSettingCell).slider.addTarget(self, action: #selector(changeRating(_:)), for: .valueChanged)
            } else if filters[indexPath.row] == "From Release Year" {
                cell = table.dequeueReusableCell(withIdentifier: releaseCell, for: indexPath)
                (cell as! ReleaseSettingCell).label.text = filters[indexPath.row]
                (cell as! ReleaseSettingCell).yearButton.setTitle("\(setting.yearRelease)", for: .normal)
                (cell as! ReleaseSettingCell).yearButton.addTarget(self, action: #selector(openDatePicker(_:)), for: .touchUpInside)
            } else {
                cell = table.dequeueReusableCell(withIdentifier: normalCell, for: indexPath)
                (cell as! NormalSettingCell).label.text = filters[indexPath.row]
                (cell as! NormalSettingCell).checkIcon.tintColor = .white
                switch setting.type {
                case "popular":
                    
                    if indexPath.row == 0 {
                        (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                    }
                case "topRated":
                    if indexPath.row == 1 {
                        (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                    }
                    
                case "upcoming":
                    if indexPath.row == 2 {
                        (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                    }
                    
                case "nowPlaying":
                    if indexPath.row == 3 {
                        (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                    }
                    
                default:
                    if indexPath.row == 0 {
                        (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                    }
                }
            }
        } else {
            cell = table.dequeueReusableCell(withIdentifier: normalCell, for: indexPath)
            (cell as! NormalSettingCell).label.text = sortbys[indexPath.row]
            (cell as! NormalSettingCell).checkIcon.tintColor = .white
            switch setting.sortBy {
            case "releaseDate":
                
                if indexPath.row == 0 {
                    (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                }
            case "rating":
                if indexPath.row == 1 {
                    (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                }
                
            default:
                if indexPath.row == 0 {
                    (cell as! NormalSettingCell).checkIcon.tintColor = .blue
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    @objc func openDatePicker(_ sender: AnyObject){
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerController") as! DatePickerController
        vc.modalPresentationStyle = .overFullScreen
        vc.yearDefault = setting.yearRelease
        vc.isUseDatePicker = false
        vc.delegateYear = self
        present(vc, animated: true, completion: nil)
    }
    
    @objc func changeRating(_ sender: UISlider) {
        let value = (sender.value * 10).rounded()/10
        setting.rating = value
        let indexPath = IndexPath.init(item: 4, section: 0)
        (table.cellForRow(at: indexPath) as! RatingSettingCell).currentRating.text = "\(value)"
        userService.saveSetting(settings: setting) { (_) in
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if filters[indexPath.row] == "Movies With Rate From" {
                return 100
            } else if filters[indexPath.row] == "From Release Year" {
                return 70
            } else {
                return 50
            }
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row < 4 {
                switch indexPath.row {
                case 0:
                    setting.type = "popular"
                case 1:
                    setting.type = "topRated"
                case 2:
                    setting.type = "upcoming"
                case 3:
                    setting.type = "nowPlaying"
                default:
                    setting.type = "popular"
                }
                userService.saveSetting(settings: setting) { (_) in
                    table.reloadData()
                }
            }
        } else {
            switch indexPath.row {
            case 0:
                setting.sortBy = "releaseDate"
            case 1:
                setting.sortBy = "rating"
            default:
                setting.sortBy = "releaseDate"
            }
            userService.saveSetting(settings: setting) { (_) in
                table.reloadData()
            }
        }
        
    }
}
extension SettingsController: YearPickerDelegate{
    func didSetYear(year: Int) {
        setting.yearRelease = year
        userService.saveSetting(settings: setting) { (_) in
            (table.cellForRow(at: IndexPath(row: 5, section: 0)) as! ReleaseSettingCell).yearButton.setTitle("\(setting.yearRelease)", for: .normal)
        }
    }
    
    
}
