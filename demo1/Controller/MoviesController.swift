//
//  MoviesController.swift
//  demo1
//
//  Created by Currie on 4/14/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit
import SWRevealViewController

class MoviesController: UIViewController {
    
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var menuBar: UIBarButtonItem!
    var rightButton: UIBarButtonItem!
    
    private var itemsPerRow: CGFloat = 1
    private var isGrid = false
    private let sectionInsets = UIEdgeInsets(top: 12.0,
                                             left: 12.0,
                                             bottom: 12.0,
                                             right: 12.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        movieCollectionView.register(UINib.init(nibName: "MovieDefaultCell", bundle: nil), forCellWithReuseIdentifier: "MovieDefaultCell")
        movieCollectionView.register(UINib.init(nibName: "MovieGridCell", bundle: nil), forCellWithReuseIdentifier: "MovieGridCell")
        
        menuBar.target = self.revealViewController()
        menuBar.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
        self.revealViewController()?.rearViewRevealWidth = 350
        
        navigationController?.navigationBar.barTintColor = .systemIndigo
        navigationController?.navigationBar.barStyle = .black
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Popular"
        
        rightButton = UIBarButtonItem(image: UIImage.init(systemName: "square.grid.2x2.fill"), style: .plain, target: self, action: #selector(toggleStyleCollection))
        rightButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightButton
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGrid {
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath)
            return cell
        } else {
            let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieDefaultCell", for: indexPath)
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
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailController") as! DetailController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
