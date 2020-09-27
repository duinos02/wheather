//
//  notiViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/08.
//  Copyright © 2020 yejin. All rights reserved.
//

import UIKit
// noti 1.임포트하기
import NotificationCenter

class notiViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //noti 2. 동의
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (allow, error) in
            
        }
        
        
    }
    @IBAction func tileNotiButtonClicked(_ sender: UIButton) {
        
        let movieList = ["남산의 부장들","스파이더맨","감기","컨테이젼","히트맨"]
        
        //noti 3. 로컬 알림을 보낼 메세지 생성
        let content = UNMutableNotificationContent()
        content.title = "오늘 하루는 어땠나요?"
        content.subtitle = "<\(movieList.randomElement()!)> 영화 관람은 어떠신가요?"
        content.body = "2020년 대개봉"
        content.badge = 2020
        
        
        // noti 4. 로컬 알림의 시점 생성(트리거) - 언제 보낼 것인가?
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // noti 5.로컬 알림을 요청할 준비 (identifier : 로컬 알림의 고유한 이름)
        let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: trigger)
        
        // noti 6.로컬 알림 최종 보내기
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
    }
    @IBAction func calenderNotiButtonClicked(_ sender: UIButton) {
        
        let movieList = ["남산의 부장들","스파이더맨","감기","컨테이젼","히트맨"]
               
               
               let content = UNMutableNotificationContent()
               content.title = "오늘 하루는 어땠나요?"
               content.subtitle = "<\(movieList.randomElement()!)> 영화 관람은 어떠신가요?"
               content.body = "2020년 대개봉"
               content.badge = 2020
               
              var cal = DateComponents()
        cal.minute = 20
        cal.hour = 1
        
               let trigger = UNCalendarNotificationTrigger(dateMatching: cal, repeats: false)
               
               let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: trigger)
             
               UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    
    
}


