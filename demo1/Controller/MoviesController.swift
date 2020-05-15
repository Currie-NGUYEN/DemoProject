//
//  MoviesController.swift
//  demo1
//
//  Created by Currie on 4/14/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SWRevealViewController
import Kingfisher

class MoviesController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var menuBar: UIBarButtonItem!
    
    private var itemsPerRow: CGFloat = 1
    private var isGrid = false
    var rightButton: UIBarButtonItem!
    var listMovies:[Movie] = [Movie]()
    
    let movieService = MovieService()
    let userService = UserService()
    let favoriteService = FavoriteService()
    private let sectionInsets = UIEdgeInsets(top: 12.0,
                                             left: 12.0,
                                             bottom: 12.0,
                                             right: 12.0)
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateBagde()
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib.init(nibName: "MovieDefaultCell", bundle: nil), forCellWithReuseIdentifier: "MovieDefaultCell")
        movieCollectionView.register(UINib.init(nibName: "MovieGridCell", bundle: nil), forCellWithReuseIdentifier: "MovieGridCell")
        
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.revealViewController()?.rearViewRevealWidth = 350
        
        navigationController?.navigationBar.barTintColor = .systemIndigo
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Popular"
        
        rightButton = UIBarButtonItem(image: UIImage.init(systemName: "square.grid.2x2.fill"), style: .plain, target: self, action: #selector(toggleStyleCollection))
        rightButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightButton
        
        activityView.color = .black
        activityView.frame = CGRect(x: view.frame.midX - 100/2 , y: view.frame.midY - 100/2, width: 100, height: 100)
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
        
        loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name.init("SettingChanged"), object: nil)
    }
    
    @objc func reloadData(notification: Notification){
        loadData()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        loadData()
//    }
    
    func loadData(){
        activityView.startAnimating()
        userService.loadSettings { (settings) in
            var data:[Movie]!
            var st: Settings!
            if settings == nil {
                st = Settings(type: "popular", rating: 0, yearRelease: 1970, sortBy: "rating")
            } else {
                st = settings
            }
            switch st?.type {
            case "popular":
                navigationItem.title = "Popular"
                movieService.fetchMovies(movieType: "popular"){ (result) in
                    data = result
                    self.filterMovies(data: data, settings: st)
                }
            case "topRated":
                navigationItem.title = "Top Rated"
                movieService.fetchMovies(movieType: "top_rated"){ (result) in
                    data = result
                    self.filterMovies(data: data, settings: st)
                }
            case "upcoming":
                navigationItem.title = "Upcoming"
                movieService.fetchMovies(movieType: "upcoming"){ (result) in
                    data = result
                    self.filterMovies(data: data, settings: st)
                }
            case "nowPlaying":
                navigationItem.title = "Now Playing"
                movieService.fetchMovies(movieType: "now_playing"){ (result) in
                    data = result
                    self.filterMovies(data: data, settings: st)
                }
            default:
                navigationItem.title = "Popular"
                movieService.fetchMovies(movieType: "popular"){ (result) in
                    data = result
                    self.filterMovies(data: data, settings: st)
                }
            }
            
        }
    }
    
    func filterMovies(data: [Movie], settings: Settings?){
        self.listMovies = data.filter { (movie) -> Bool in
            let year = Int(movie.releaseDate.split(separator: "-")[0])
            return (movie.rating >= settings!.rating)&&(year! >= settings!.yearRelease)
        }.sorted(by: { (m1, m2) -> Bool in
            switch settings?.sortBy {
            case "rating":
                return m1.rating > m2.rating
            case "releaseDate":
                return m1.releaseDate > m2.releaseDate
            default:
                return m1.rating > m2.rating
            }
            
        })
        activityView.stopAnimating()
        movieCollectionView.reloadData()
    }
    
    @objc func toggleStyleCollection(_ sender: AnyObject){
        self.isGrid = !self.isGrid
        if isGrid {
            itemsPerRow = 2
            rightButton.image = UIImage.init(systemName: "list.bullet")
        } else {
            itemsPerRow = 1
            rightButton.image = UIImage.init(systemName: "square.grid.2x2.fill")
        }
        movieCollectionView.reloadData()
    }
}

extension MoviesController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let movie = listMovies[indexPath.row]
        
        if isGrid {
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
            cell.movie = movie
            return cell
        } else {
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieDefaultCell", for: indexPath) as! MovieDefaultCell
            cell.movie = movie
            cell.delegate = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = listMovies[indexPath.row]
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        vc.navigationItem.title = movie.name
        vc.idMovie = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension MoviesController: MovieDefaultCellDelegate {
    func didAddFavorite() {
        updateBagde()
    }
    
    func updateBagde(){
        if let tabItems = self.tabBarController?.tabBar.items {
            let tabItem = tabItems[1]
            tabItem.badgeValue = favoriteService.getAllFavorites()!.count > 0 ? "\(favoriteService.getAllFavorites()!.count)" : nil
        }
    }
    
    func willRemoveFavorite(idFavorite: Int) {
        let alert = UIAlertController(title: "Are you sure you want to unfavorite this item?", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.favoriteService.deleteFavorite(id: idFavorite)
            self.updateBagde()
            self.loadData()
        }))
        
        self.present(alert, animated: true)
    }
    
}
