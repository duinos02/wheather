//
//  wheatherViewController.swift
//  wheather
//
//  Created by 이예진 on 2020/02/01.
//  Copyright © 2020 yejin. All rights reserved.
//

//3주차 서버통신 : 화면 뜨기 전 -> 위치를 가져오기 - 위도 경도 옴 -> 위도 경도를 통해 날씨를 요청

import UIKit
//위치 1. 프레임워크 임포트 + 권한 설정(info.plist에서 privacy - when in use..)
import CoreLocation
import SwiftyJSON
import Alamofire

//테이블뷰 구현 2. UITableViewDelegate, UITableViewDataSource 부하직원(프로토콜) 부르기
//위치 2. 위경도 정보를 담당하는 부하직원(clLoMaDe) 선언
class wheatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    var list = ["현재 날씨","현재 온도","현재 체감 온도","현재 습도","NAVER","DAUM"]
   

    //테이블뷰 구현 1.테이블뷰 이름 선언
    @IBOutlet weak var wheatherTableView: UITableView!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    //위치 3.위치 업데이트 시작과 끝을 담당하는 매니저 불러오기
    let manager = CLLocationManager()
    
    //날씨 서버통신에서 가져온 값을 테이블뷰 셀에 표현하기 위해 임시보관하는 변수
    var weathericon = " "
    var weathertemp = 0.0
    var weatherATemp = 0.0
    var weatherHum = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //위치 4.위치 권한 요청 문구(동의 문구 띄우기)
        manager.requestWhenInUseAuthorization()
        
        //위치 5. 위치 권한을 허용한 경우, 현재 위치를 가져오는 기능 실행
        if CLLocationManager.locationServicesEnabled(){
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters //정확도 설정
            manager.startUpdatingLocation()
            
        }
        

        //테이블뷰 구현 3.테이블뷰와 부하직원을 연결시켜주는 작업
        wheatherTableView.delegate = self
        wheatherTableView.dataSource = self
        
        //배경화면 이미지 랜덤으로 뜨게 하기
        backgroundImageView.image = UIImage(named: "\(Int.random(in:1...9))")
        //배경에 꽉차게 이미지 넣기 설정
        backgroundImageView.contentMode = .scaleAspectFill
        
        wheatherTableView.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(closeButtonClicked)) //에러뜨면 픽스누르면됨
               
               navigationItem.title = "날씨"
        
       
        
    }
    
    
    //서버요청구문(3주차) 날씨api
    func callRequest(lat : Double , lon : Double) {
        
        //swiftjson 하단에 있음. swift랑 alamo 임포트하기
        AF.request("https://api.darksky.net/forecast/2913f94b5ebc71856decfd5665a0c175/\(lat),\(lon)", method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
                
               let icon = json["currently"]["icon"].stringValue
                let temp = json["currently"]["temperature"].doubleValue
                let app = json["currently"]["apparentTemperature"].doubleValue
                let hum = json["currently"]["humidity"].doubleValue
                //temperature, apparentTemperature(체감온도), humidity(습도)
                
                //디버그영역에서 확인하기
                print("==============")
                print(temp,icon,app,hum)
                
                self.weatherHum = hum * 100
                self.weathericon = icon
                self.weathertemp = (temp - 32) * 5/9
                self.weatherATemp = (app - 32) * 5/9
                
                //이걸 써줘야 값이 제대로 나옴 안그러면 맨위에 설정한 값으로 나옴
                self.wheatherTableView.reloadData()
               
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    //위치 6.사용자의 위치가 변경될 때마다 자동으로 인식해서 업데이트 해주는 기능 //didupdatelocations가 키워드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        //위치 7. 사용자의 현재 위치에 대한 위도,경도 가져오기
        let lat = manager.location?.coordinate.latitude ?? 0.0
        let lon = manager.location?.coordinate.longitude ?? 0.0
        
        //위치 8. 원하는 곳에 위,경도 보여주기
        navigationItem.title = "\(lat),\(lon)"
        
        //3주차 서버통신 ) 날씨 요청 - 위도경도 가져온 뒤의 위치에
        callRequest(lat: lat, lon: lon)
         
        
        //위치 9. 위도 경도를 주소로 변환
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lat, longitude: lon)) { (placemark, error) in
                    
                    //주소 변환이 잘 이루어진 경우
                    if error == nil {
                        
                        let place = placemark?[0]
                        
                        let first = place?.administrativeArea ?? "" //서울특별시
                        let second = place?.locality ?? ""//관악구
                        let third = place?.subLocality ?? ""//신림동
                        
                        self.navigationItem.title = "\(first), \(second), \(third)"
            }
        }
        
        
        
        //위치 10. 실시간으로 위치가 계속 업데이트 되는것을 방지
        manager.stopUpdatingLocation()
        
    }
    
    @objc func closeButtonClicked() {
        //push-pop
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    //테이블뷰 구현 4. 필요한 코드 부르기 (2번이 잘 되어 있어야 자동완성으로 잘 불림)
    //4-1. 셀의 갯수 : numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    //4-2. 셀 디자인 및 데이터 처리 : cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wheatherTableViewCell", for: indexPath) as! wheatherTableViewCell
        
        cell.backgroundColor = .clear
        
        cell.backgroundImageView.clipsToBounds = true
        cell.backgroundImageView.layer.cornerRadius = cell.backgroundImageView.frame.size.width / 2
        //정 원을 만드는 방법
        cell.backgroundImageView.image = UIImage(named: "\(indexPath.row + 1)")
        cell.backgroundImageView.contentMode = .scaleAspectFill
        
        cell.blackLayerView.clipsToBounds = true
        cell.blackLayerView.layer.cornerRadius = cell.blackLayerView.frame.size.width / 2
        
        cell.titleLabel.backgroundColor = .clear
        cell.titleLabel.textAlignment = .center
        cell.titleLabel.text = list[indexPath.row]
        cell.titleLabel.font = UIFont.systemFont(ofSize: 14)
        cell.titleLabel.textColor = .white
        
        cell.contentLabel.backgroundColor = .clear
        cell.contentLabel.textAlignment = .center
  
        if indexPath.row == 0 {
            cell.contentLabel.text = weathericon
        } else if indexPath.row == 1 {
            cell.contentLabel.text = "\(Int(weathertemp))°C"
        } else if indexPath.row == 2 {
            cell.contentLabel.text = "\(Int(weatherATemp))°C"
        } else if indexPath.row == 3 {
            cell.contentLabel.text = "\(Int(weatherHum))%"
        } else {
            cell.contentLabel.text = "사이트로 이동"
        }
        
        
        cell.contentLabel.font = UIFont.systemFont(ofSize: 17)
        cell.contentLabel.textColor = .white
        
    
        
        
        
        return cell
    }
    //4-3 셀의 높이 : heightForRowAt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.width //테이블뷰의 너비만큼 셀 높이를 주기
    }

}
