//
//  DetailController.swift
//  demo1
//
//  Created by Currie on 4/16/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications

class DetailController: UIViewController {
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var listActors: UICollectionView!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var posterImage: UIImageView!
    
    let actorCellIdentifier = "ActorCell"
    let sectionInsets = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    let itemsOfColunm: CGFloat = 4
    let movieService = MovieService()
    
    var idMovie:Int!
    var movie: Movie!
    let favoriteService = FavoriteService()
    let reminderService = RemindersService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listActors.delegate = self
        listActors.dataSource = self
        listActors.register(UINib(nibName: actorCellIdentifier, bundle: nil), forCellWithReuseIdentifier: actorCellIdentifier)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        movieService.fetchDetail(id: idMovie) { (movie) in
            self.movie = movie
            self.releaseDate.text = "\(movie.releaseDate)"
            self.rating.text = "\(movie.rating)/10"
            self.overview.text = movie.overview
            let urlImage = URL(string: MovieService.baseImageUrl+movie.poster)
            self.posterImage.kf.setImage(with: urlImage)
            if self.favoriteService.getFavoriteByIdMovie(idMovie: movie.id) != nil {
                self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        favoriteButton.addTarget(self, action: #selector(didTapFavorite(_:)), for: .touchUpInside)
    }
    
    @IBAction func didTapReminder(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DatePickerController") as! DatePickerController
        vc.modalPresentationStyle = .overFullScreen
        vc.delegateDate = self
        vc.isUseDatePicker = true
        vc.datePickerType = .dateAndTime
        
        present(vc, animated: true, completion: nil)
    }
    
    @objc func didTapFavorite(_ sender: UIButton) {
        guard let favorite = favoriteService.getFavoriteByIdMovie(idMovie: idMovie) else {
            favoriteService.insertFavorite(movie: movie)
            self.updateBagde()
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            return
        }
        let alert = UIAlertController(title: "Are you sure you want to unfavorite this item?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.favoriteService.deleteFavorite(id: favorite.id)
            self.updateBagde()
            self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }))
        
        self.present(alert, animated: true)
    }
    
    func updateBagde(){
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = favoriteService.getAllFavorites()!.count > 0 ? "\(favoriteService.getAllFavorites()!.count)" : nil
        }
    }
}

extension DetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = listActors.dequeueReusableCell(withReuseIdentifier: actorCellIdentifier, for: indexPath)
        //        cell.backgroundColor = .red
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = 10 * (itemsOfColunm - 1)
        let itemWidth = (view.frame.width - spacing) / itemsOfColunm
        let itemHeight = (collectionView.frame.height - sectionInsets.top*2)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension DetailController: DatePickerDelegate {
    func didSetDate(date: Double) {
        let currentTime = Double(Date().timeIntervalSince1970)
        
        if date > currentTime {
            let center = UNUserNotificationCenter.current()
            
            let content = UNMutableNotificationContent()
            content.title = "\(movie.name) - \(movie.releaseDate) - \(movie.rating)/10"
            content.body = date.dateFormater()
            content.sound = .default
            
            let d = Date(timeIntervalSince1970: date)
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: d)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
            let identifier = UUID().uuidString
            let requestN = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(requestN) { (error) in
                if error != nil {
                    print("error: \(error?.localizedDescription ?? "Unknown")")
                } else {
                    print("OK")
                    self.reminderService.insertReminder(movie: self.movie, timeReminder: date, idReminder: identifier)
                    DispatchQueue.main.async{
                        let alert = UIAlertController(title: "Reminder", message: "\(self.movie.name) - \(self.movie.releaseDate) - \(self.movie.rating)/10", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true)
                    }
                }
            }
        } else {
            DispatchQueue.main.async{
                let alert = UIAlertController(title: "Your time is invalid!", message: nil, preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(alert, animated: true)
            }
        }
    }
}
