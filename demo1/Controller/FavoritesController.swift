//
//  FavoristesController.swift
//  demo1
//
//  Created by Currie on 4/14/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SWRevealViewController

class FavoritesController: UIViewController {
    
    
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    @IBOutlet weak var favoriteMoviesTable: UICollectionView!
    @IBOutlet weak var textSearch: UITextField!
    var listFavorites = [Favorite]()
    
    let favoriteService = FavoriteService()
    let favoriteCellIdentifier = "MovieDefaultCell"
    private let sectionInsets = UIEdgeInsets(top: 12.0,
                                             left: 12.0,
                                             bottom: 12.0,
                                             right: 12.0)
    let itemsPerRow:CGFloat = 1
    let activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.revealViewController()?.rearViewRevealWidth = 350
        
        navigationController?.navigationBar.barTintColor = .systemIndigo
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Favorites"
        
        favoriteMoviesTable.delegate = self
        favoriteMoviesTable.dataSource = self
        favoriteMoviesTable.register(UINib(nibName: favoriteCellIdentifier, bundle: nil), forCellWithReuseIdentifier: favoriteCellIdentifier)
        
        let iconSearchImage = UIImage(systemName: "magnifyingglass")
        let iconSearchView = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: (iconSearchImage?.size.width)!, height: (iconSearchImage?.size.width)!))
        iconSearchView.image = iconSearchImage
        iconSearchView.tintColor = .lightGray
        textSearch.leftView = iconSearchView
        textSearch.leftViewMode = .always
        
        textSearch.addTarget(self, action: #selector(changeTextSearch(_:)), for: .editingChanged)
        
        activityView.color = .black
        activityView.frame = CGRect(x: view.frame.midX - 100/2 , y: view.frame.midY - 100/2, width: 100, height: 100)
        activityView.hidesWhenStopped = true
        view.addSubview(activityView)
    }
    
    
    
    @objc func changeTextSearch(_ sender: UITextField) {
        if sender.text != nil && sender.text != "" {
            listFavorites = favoriteService.getAllFavorites()!.filter { (favorite) -> Bool in
                return favorite.movie.name.lowercased().contains(sender.text!.lowercased())
            }
            favoriteMoviesTable.reloadData()
        } else {
            listFavorites = favoriteService.getAllFavorites()!
            favoriteMoviesTable.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityView.startAnimating()
        listFavorites = favoriteService.getAllFavorites()!
        favoriteMoviesTable.reloadData()
        activityView.stopAnimating()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension FavoritesController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listFavorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let favorite = listFavorites[indexPath.row]
        
        let cell = favoriteMoviesTable.dequeueReusableCell(withReuseIdentifier: favoriteCellIdentifier, for: indexPath) as! MovieDefaultCell
        
        cell.movie = favorite.movie
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = listFavorites[indexPath.row].movie
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        vc.navigationItem.title = movie.name
        vc.idMovie = movie.id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension FavoritesController: MovieDefaultCellDelegate {
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
            self.listFavorites = self.favoriteService.getAllFavorites()!
            self.favoriteMoviesTable.reloadData()
        }))
        
        self.present(alert, animated: true)
    }
}
