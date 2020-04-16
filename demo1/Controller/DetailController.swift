//
//  DetailController.swift
//  demo1
//
//  Created by Currie on 4/16/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var listActors: UICollectionView!
    let actorCellIdentifier = "ActorCell"
    let sectionInsets = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
    let itemsOfColunm: CGFloat = 4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listActors.delegate = self
        listActors.dataSource = self
        listActors.register(UINib(nibName: actorCellIdentifier, bundle: nil), forCellWithReuseIdentifier: actorCellIdentifier)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.title = "Death Note"
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
