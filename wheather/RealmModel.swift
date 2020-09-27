//
//  RealmModel.swift
//  
//
//  Created by 이예진 on 2020/02/15.
//

import Foundation
import RealmSwift
//오류뜨면 재생해보면 사라짐

// 1. 테이블 이름 정하기
// 2. 테이블 안의 저장할 항목 정하기
// 3. 항목 정할 때 필수/옵션 여부 설정 (기획)

class yejin: Object {
    @objc dynamic var title = "" // 제목 (항상 주석처리 해놓기 까먹으니까)
    @objc dynamic var contents : String? = nil //내용
    @objc dynamic var important = 0 // 0:매우중요 1:중요 2:덜중요
    @objc dynamic var favorite  = false //true:즐겨찾기 false:안찾기
    
    @objc dynamic var registerDate = Date() //컨텐츠 저장 시점 자동 저장
    @objc dynamic var userDate : Date? = nil //사용자가 입력하는 값
    @objc dynamic var photoName : String? = nil //파일명(옵션)
    
    @objc dynamic var ID = 0 //고유한 값(Primary Key)로 사용할 예정
    
    override static func primaryKey() -> String? {
            return "ID"
        }
    }


