//
//  ViewController.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/01.
//

import UIKit

import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {
    //MARK: - Properties
    var lottoPickerView = UIPickerView()
    let numberList: [Int] = Array(1...1026).reversed()
    
    @IBOutlet var numberLabels: [UILabel]!
    @IBOutlet weak var numberTextField: UITextField!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
    }
    
    //MARK: - Helpers
    private func configureTextField() {
        numberTextField.tintColor = .clear // 커서 깜빡이는 거 없어짐
        numberTextField.inputView = lottoPickerView // 텍스트필드 클릭시 키보드가 올라오지 않음
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
    }
    
    
    private func requestLotto(number: Int) {
        // AF: 200~299 status code
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { [unowned self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for i in 1..<self.numberLabels.count {
                    let number = json["drwtNo\(i)"].intValue
                    self.numberLabels[i-1].text = "\(number)"
                }
                let bonus = json["bnusNo"].intValue
                self.numberLabels.last?.text = "\(bonus)"
                
                let date = json["drwNoDate"].stringValue
                let drawNumber = json["drwNo"].intValue
                self.numberTextField.text = "\(date) \(drawNumber)회차"
            case .failure(let error):
                print(error)
            }
        }
    }

}

//MARK: - Extension: UIPickerView
extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // 피커 세로 선택 개수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 피커안의 내용 선택 개수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    // 피커선택시
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row])
    }
    
    // 피커안의 내용(제목)
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
}

