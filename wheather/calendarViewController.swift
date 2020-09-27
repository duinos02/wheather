//
//  calendarViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/29.
//  Copyright © 2020 yejin. All rights reserved.
//

import UIKit
import fscalendar //fscalendar 1.임포트
import RealmSwift


//fscalendar 2.캘린더 이름짓기(아울렛 연결)

class calendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate{

    //dateformatter 1.선언
    let format = Dateformatter()
    
    let dateList : [string] = []
    
    let realm = try! Realm()
    
    var list : results<yejin>!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //fscalender 4. 캘린더 뷰와 프로토콜 연결
        myCalendar.delegate = self
        myCalendar.datasauce = self
        
        //dateformatter 2. 포맷형태
        format.dateFormat = "yyMMdd"
        
        //dateformatter 3. 사용
        print(Date())
        print(format.string(from: Date()))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        list = realm.objects(yejin.self)
        
        for item in list {
            dateList.append(format.string(from: item.userDate))
            
        }
        
    }
    
    
    //데이트포맷터 : "yy년 MM월 dd일" "dd, MM, yyyy"
    //1. 원하는 형태로 변환가능
    //2. 영국 표준시 변형
    
    func calendar(_ calendar: FScalendar, numberOfEventsFor date: Date) -> Int {
        
        if dateList.contains(format.string(from: date)) {
            
            return 1
        }else {
            return 0
        }
        
    }

  

}
