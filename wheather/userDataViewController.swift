//
//  userDataViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/07.
//  Copyright © 2020 yejin. All rights reserved.
//

import UIKit

class userDataViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var movieSearchBar: UISearchBar!
    @IBOutlet weak var movieTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "userDataTableViewCell", for: indexPath) as! userDataTableViewCell
        
        cell.moviePosterImageView.image = UIImage(named: "\(Int.random(in:0...9))")
        cell.moviePosterImageView.contentMode = .scaleAspectFill
        cell.moviePosterImageView.clipsToBounds = true
        cell.moviePosterImageView.layer.cornerRadius = 8
        
        cell.movieTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        
        cell.movieDirectorLabel.font = UIFont.systemFont(ofSize: 15)
        
        cell.movieActorLabel.numberOfLines = 0
        cell.movieActorLabel.font = UIFont.systemFont(ofSize: 14)
        
        cell.movieRatingLabel.text = "\(Int.random(in:0...5))"
        cell.movieRatingLabel.textAlignment = .right
        cell.movieRatingLabel.font = UIFont.systemFont(ofSize: 14)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let dw = UIScreen.main.bounds.width
        
        return dw * 0.35
    }
    
    
}
