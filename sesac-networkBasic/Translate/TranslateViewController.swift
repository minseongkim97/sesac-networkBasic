//
//  TranslateViewController.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/02.
//

import UIKit
import Alamofire
import SwiftyJSON

class TranslateViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var beforeTextView: UITextView! {
        didSet {
            beforeTextView.layer.borderColor = UIColor.black.cgColor
            beforeTextView.layer.borderWidth = 1
            beforeTextView.delegate = self
        }
    }
    @IBOutlet weak var afterTextView: UITextView! {
        didSet {
            afterTextView.layer.borderColor = UIColor.black.cgColor
            afterTextView.layer.borderWidth = 1
            afterTextView.isUserInteractionEnabled = false
//            afterTextView.delegate = self
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        beforeTextView.text = "번역할 한글을 적어주세요."
        beforeTextView.textColor = .lightGray
    }
    
    //MARK: - Helpers
    private func requestTranslatedData() {
        let url = EndPoint.translateURL
        
        let parameter = ["source": "ko", "target": "en", "text": beforeTextView.text ?? ""]
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.afterTextView.text = json["message"]["result"]["translatedText"].stringValue
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extension: UITextViewDelegate
extension TranslateViewController: UITextViewDelegate {
    
    // 텍스트뷰의 텍스트가 변할 떄마다 호출
    func textViewDidChange(_ textView: UITextView) {
        requestTranslatedData()
    }
    
    // 편집이 시작될 때. 커서가 시작될 때
    // 텍스트뷰 글자: 플레이스 홀더랑 글자가 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin")
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}
