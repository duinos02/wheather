import UIKit
import RealmSwift
import YPImagePicker

class DetailViewController: UIViewController {
    
    let realm = try! Realm()

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var photoButton: UIButton!
    
    @IBOutlet var rateIconImageView: UIImageView!
    @IBOutlet var rateLabel: UILabel!
    
    @IBOutlet weak var importantSengmentControl: UISegmentedControl!
    
    @IBOutlet var registerDatePicker: UIDatePicker!
    
    @IBOutlet var reviewIconImageView: UIImageView!
    @IBOutlet var reviewLabel: UILabel!
    @IBOutlet var reviewTextField: UITextField!
    
    @IBOutlet var memoIconImageView: UIImageView!
    @IBOutlet var memoLabel: UILabel!
    @IBOutlet var memoTextView: UITextView!
     
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
    
    self.dismiss(animated : true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        //빈칸이 있으면 넘어가지 않게 하기 ( 이미지뷰,텍스트뷰,텍스트필드에 모두 값이 존재할때만 넘어가기)
        if photoImageView.image != nil && (memoTextView.text.count) > 0 && (reviewTextField.text?.count ?? 0) > 0 {
            
            //realm 3. 각 항목에 맞는 내용들을 넣기
                   let data = yejin()
                   data.title = reviewTextField.text! //텍스트필드 안의 글자 가져오기
                   data.contents = memoTextView.text!
                   data.important = importantSengmentControl.selectedSegmentIndex
                   data.favorite = false
                   data.registerDate = Date()
                   data.userDate = registerDatePicker.date
                   
                   let newID = createNewID()
                   //상수처리를 해서 넣어야 중복오류 안생김
                   
                   data.photoName = "\(newID).png"
                   data.ID = createNewID()
                   
                   //최종 렘 테이블에 추가
                   try! realm.write {
                       realm.add(data)
                   }
                   
                   //사진 저장 1. 이미지뷰에 사진이 들어있는지 확인
                   if photoImageView.image != nil /*값이 있으면*/ {
                       
                       //사진 저장 2. 사진이 있을 경우 사진을 도큐먼트 폴더(파일 시스템)에 저장
                              // * 파일 시스템? 샌드박스 시스템, 애플이 알려준 코드를 사용해야만 파일을 찾을 수 있음
                       savePhotosToDocumentDirectory(image: photoImageView.image!, fileName: "\(newID).png")
                       
                   }
            
            self.dismiss(animated: true, completion: nil)
            
                
                   
        }else {
            //1. 얼럿컨트롤러 생성 ( 흰 배경 )
            let alert = UIAlertController(title: "채워지지 않은 내용이 있습니다", message: "일기를 저장하시려면 사진과 제목, 내용이 꼭 들어있어야 합니다", preferredStyle: .alert)
            //2.얼럿버튼 생성 ( 버튼 )
            let b1 = UIAlertAction(title: "확인", style: .default, handler: nil)
            let b2 = UIAlertAction(title: "저장", style: .cancel, handler: nil)
            let b3 = UIAlertAction(title: "취소", style: .destructive, handler: nil)

            //3. 1번배경에 2번 얹기 : 버튼을 추가하는 순서대로 화면에 보임
          //  alert.addAction(b3)
          //  alert.addAction(b2)
            alert.addAction(b1)

            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
    
       
        
       
        
        print("저장되었습니다")
        
    }
    
    //사진 저장 3. 도큐먼트 폴더에 사진을 저장하는 코드
    func savePhotosToDocumentDirectory(image : UIImage, fileName : String){
        
        let fileManager = FileManager.default
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            if let imageData = image.jpegData(compressionQuality: 0.2) {
                try imageData.write(to: fileURL)
                
                 print("사진이 정상적으로 출력되었습니다")
                
            }
        } catch {
            print(error)
        }
        
    }
    
    func createNewID() -> Int {
        
        let realm = try! Realm()
        if let retNext = realm.objects(yejin.self).sorted(byKeyPath: "ID", ascending : false).first?.ID {
            return retNext + 1
        } else { return 2 }
        
    }
    
    @IBAction func photoButtonClicked(_ sender: UIButton) {
        
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.modifiedImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.photoImageView.image = photo.image
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
        
    }
}
