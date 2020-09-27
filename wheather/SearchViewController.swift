//
//  SearchViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/01.
//  Copyright © 2020 yejin. All rights reserved.
//

import UIKit
import collection_view_layouts //라이브러리 가져오면 늘 임포트 필수

//컬렉션뷰 구현 2. 부하직원(프로토콜) 선언
class SearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, LayoutDelegate{
    
    //taglayout에서만 적용
    // -> 있으면 리턴 쓰기
    func cellSize(indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    //컬렉션뷰 구현 1. 컬렉션뷰 이름 선언
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: BaseLayout = InstagramLayout()

        layout.delegate = self
        
        //사진 셀 하나하나 사이의 간격
        layout.cellsPadding = ItemsPadding(horizontal: 1, vertical: 1)
        
        // 사진 테이블 뭉탱이와 가의 간격
        layout.contentPadding = ItemsPadding(horizontal: 10, vertical: 10)

        imageCollectionView.collectionViewLayout = layout
        imageCollectionView.reloadData()
        
        //컬렉션뷰 구현 3. 부하직원과 컬렉션뷰를 연결
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeButtonClicked)) //에러뜨면 픽스누르면됨
        
        navigationItem.title = "영화 검색"
        
    }
    
    @objc func closeButtonClicked() {
        //present - dismiss (짝궁)
        self.dismiss(animated: true, completion: nil)
        
    }
    

    
    //컬렉션뷰 구현 4. 필수 기능 부르기
    
    //셀의 갯수 : numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    //셀의 디자인 및 데이터 처리 : cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        //셀 만들면서 아이덴티파이어 매칭시켜주고 따옴표, as 추가
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        
    
        
        cell.resultImageView.image = UIImage(named: "\(Int.random(in: 1...9))")
        cell.resultImageView.contentMode = .scaleAspectFill
        
    
        return cell
        
    }
    

}
