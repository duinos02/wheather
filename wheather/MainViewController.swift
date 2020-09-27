//
//  MainViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/01.
//  Copyright © 2020 yejin. All rights reserved.
//

import UIKit
import collection_view_layouts
// realm 1. 임포트
import RealmSwift

    //2.부하직원 선언
class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, LayoutDelegate {
    
    //realm 2. 렘 테이블에 들어있는 사용자의 정보를 가져오기 위해 접근하는 코드(터널)
    let realm = try! Realm()
    
    //realm 3. 렘 테이블(원본)에 들어있는 사용자의 정보를 저장할 공간 만들기(ex.렘 테이블에는 1000개, 화면에는 100개만 보여줄 수 있음)
    var list : Results<yejin>!
    
    
    //MARK: collection_view_layouts 함수
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        //디바이스 전체 너비 가져오기
        let deviceWidth = UIScreen.main.bounds.width
        
        //셀 하나의 너비 가져오기
        let cellWidth = (deviceWidth - 20) / 3
        
        return CGSize(width: cellWidth, height: cellWidth * 1.3)
    }
    
    
    
    //1.컬렉션뷰 이름 선언
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    @IBAction func plusButtonClicked(_ sender: Any) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "detailViewController") as! DetailViewController
        
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
    //MARK: view_did_load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // realm 4.렘 테이블에서 원하는 사용자의 정보를 정렬/필터해서 list 변수에 담기
        list = realm.objects(yejin.self).sorted(byKeyPath: "title", ascending: false)
        
        let layout: BaseLayout = TagsLayout()

        layout.delegate = self
        layout.contentPadding = ItemsPadding(horizontal: 5, vertical: 5)
        layout.cellsPadding = ItemsPadding(horizontal: 5, vertical: 5)

        mainCollectionView.collectionViewLayout = layout
        mainCollectionView.reloadData()
        
        
        // 3.부하직원과 컬렉션뷰 연결
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        
        
        
    }
    //뷰디드로드 바로 밑에 - 새로운 항목을 추가할때마다 리스트화면으로 돌아오면 보여주기
    
    override func viewWillAppear(_ animated: Bool) {
        mainCollectionView.reloadData()
    }
    
    //MARK: 화면전환 코드
    
    @IBAction func weatherButtonClicked(_ sender: UIBarButtonItem) {
    
    //0.어떤 스토리보드에 속한 화면인지
        let sb = UIStoryboard(name: "Main", bundle: nil)
    
    //1.어떤 화면으로 전환할지 전환할 화면 가져오기
        let vc = sb.instantiateViewController(withIdentifier: "wheatherViewController") as! wheatherViewController
    
    //2.화면 전환 방식을 정해, 1번에서 선택한 화면 전환하기
        self.navigationController?.pushViewController(vc, animated: true)
    
    
    
    }
    
    @IBAction func searchButtonClicked(_ sender: UIBarButtonItem) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        
        //1.5(옵션) 코드로 네비게이션 컨트롤러 달아주기(가장 앞면에 나와서 보이기 위해)
        let nav = UINavigationController(rootViewController: vc)
        
        //1.5(옵션) 화면전환 효과 변경하기(프레젠트에서만 가능) - ios 13에서는 적용 불가능한 애니메이션이 존재
        nav.modalTransitionStyle = .coverVertical
        
        //1.5(옵션) 화면 전환 방식 변경 - fullscreen의 경우 ios13이상에서 보이는 모달 형태를 ios 12 처럼 풀스크린으로 변경해줌
        nav.modalPresentationStyle = .fullScreen
        
        self.present(nav, animated: true, completion: nil)
        //vc 였던걸 nav로 바꿔주니까 오류 해결 - 밑에 애들은 다 nav로 적용시켰기때문에
    }
    
    
    //필수기능 부르기
    
    
    //사진 불러오기 2. 나의 앱 도큐먼트 위치 찾기
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    //셀 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
        
        
    }
    //셀 디자인 및 데이터
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCollectionViewCell", for: indexPath) as! MainCollectionViewCell
        
        //사진 불러오기 1. 애플의 파일 시스템에 접근(=도큐먼트 폴더에 들어가 보겠다)
        let file = FileManager.default
        //사진 불러오기 2. 도큐먼트 폴더 위치에서 특정 파일 이름을 찾기
        let path = (getDirectoryPath() as NSString).appendingPathComponent("\(list[indexPath.item].photoName!)")
        //사진 불러오기 3. 사진 파일이 있다면 사진 파일을 이미지뷰에 보여주고, 없다면 랜덤 이미지 띄우기
       /* if file.fileExists(atPath: path){
            cell.photoImageView.image = UIImage(contentsOfFile: path)
                }else{
            cell.photoImageView.image = UIImage(named: "\(Int.random(in: 1...9))")
        } */
        
        cell.titleLabel.text = list[indexPath.item].title
        cell.overviewLabel.text = "\(list[indexPath.item].registerDate)"
        
        return cell
    }
    
    //셀을 선택했을 때
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let vc = sb.instantiateViewController(identifier: "userDataViewController") as! userDataViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
 */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
    //        let nav = UINavigationController(rootViewController: vc)
        
        // 값 전달 3. 전달하고싶은 내용을 변수에 전달
        vc.diaryTitle = list[indexPath.item].title
        vc.diaryDate = list[indexPath.item].userDate!
        //삭제 2. 컨텐츠의 id값을 변수에 전달
        vc.diaryID = list[indexPath.item].ID
        
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    
    
}
