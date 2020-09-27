//
//  photoViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/07.
//  Copyright © 2020 yejin. All rights reserved.
//

import UIKit
import collection_view_layouts

class photoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        
        let layout: BaseLayout = InstagramLayout()

       // layout.delegate = self
       // layout.delegate = ItemsPadding(horizontal: 10, vertical: 10)
        layout.contentPadding = ItemsPadding(horizontal: 8, vertical: 8)
        layout.cellsPadding = ItemsPadding(horizontal: 1, vertical: 1)

        photoCollectionView.collectionViewLayout = layout
        photoCollectionView.reloadData()

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as! photoCollectionViewCell
        
        cell.photoImageView.image = UIImage(named: "\(Int.random(in:0...9))")
        cell.photoImageView.contentMode = .scaleAspectFill
        
        cell.titleLabel.textColor = .white
        cell.dateLabel.textColor = .white
        
        return cell
    }

}
