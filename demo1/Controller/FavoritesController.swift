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
    
    let favoriteCellIdentifier = "MovieDefaultCell"
    
    @IBOutlet weak var menuBar: UIBarButtonItem!
    @IBOutlet weak var favoriteMoviesTable: UICollectionView!
    @IBOutlet weak var textSearch: UITextField!
    
    private let sectionInsets = UIEdgeInsets(top: 12.0,
                                             left: 12.0,
                                             bottom: 12.0,
                                             right: 12.0)
    let itemsPerRow:CGFloat = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
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
    }
    
}

extension FavoritesController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteMoviesTable.dequeueReusableCell(withReuseIdentifier: favoriteCellIdentifier, for: indexPath)
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
    
}
