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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.revealViewController()?.rearViewRevealWidth = 350
//        self.revealViewController()?.delegate = self
        navigationController?.navigationBar.barTintColor = .systemIndigo
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Settings"
        
        table.delegate = self
        table.dataSource = self
        table.register(UINib(nibName: normalCell, bundle: nil), forCellReuseIdentifier: normalCell)
        table.register(UINib(nibName: ratingCell, bundle: nil), forCellReuseIdentifier: ratingCell)
        table.register(UINib(nibName: releaseCell, bundle: nil), forCellReuseIdentifier: releaseCell)
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
            } else if filters[indexPath.row] == "From Release Year" {
                cell = table.dequeueReusableCell(withIdentifier: releaseCell, for: indexPath)
                (cell as! ReleaseSettingCell).label.text = filters[indexPath.row]
            } else {
                cell = table.dequeueReusableCell(withIdentifier: normalCell, for: indexPath)
                (cell as! NormalSettingCell).label.text = filters[indexPath.row]
            }
        } else {
            cell = table.dequeueReusableCell(withIdentifier: normalCell, for: indexPath)
            (cell as! NormalSettingCell).label.text = filters[indexPath.row]
        }
        return cell
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
}

extension SettingsController: SWRevealViewControllerDelegate{
    func moveToReminders() {
        print("ss")
    }
}
