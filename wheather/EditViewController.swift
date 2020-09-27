//
//  EditViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/22.
//  Copyright © 2020 yejin. All rights reserved.
//

import RealmSwift
import UIKit

class EditViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    
    @IBOutlet weak var DatePicker: UIDatePicker!
    //값 전달 1. 전달받을 공간 만들기
    var diaryTitle = "제목"
    var diaryDate = Date()
    
    //삭제 1. 컨텐츠 ID를 전달받을 공간
    var diaryID = 0
    
    
    let realm = try! Realm()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //값 전달 2. 표현하고싶은 곳에 내용 출력
        //네비게이션 타이틀
        title = diaryTitle
        DatePicker.date = diaryDate
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deletebuttonclicked))
        
    }
    
    @objc func deletebuttonclicked() {
        print("삭제되었습니다")
        
        //렘의 내용 중 000번에 해당되는 내용을 삭제해
        let data = realm.objects(yejin.self).filter("ID = \(diaryID)").first!
        
        try! realm.write {
            realm.delete(data)
        }
        
        
        
        //화면 사라지기
        self.navigationController?.popViewController(animated: true)
        
    }
  

}
