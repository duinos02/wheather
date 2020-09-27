//
//  SecondMainViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/07.
//  Copyright © 2020 yejin. All rights reserved.
//

import UIKit

class SecondMainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SecondMainCollectionViewCell", for: indexPath) as! SecondMainCollectionViewCell
        
        cell.photoImageView.image = UIImage(named: "\(Int.random(in: 0...9))")
        
        return cell
    }

}
