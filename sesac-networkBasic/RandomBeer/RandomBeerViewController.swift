//
//  RandomBeerViewController.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/01.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class RandomBeerViewController: UIViewController {
    //MARK: - Properties
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerNameLabel: UILabel!
    @IBOutlet weak var beerDescriptionLabel: UILabel!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestBeer()
    }
    
    //MARK: - Action
    @IBAction func changeButtonClicked(_ sender: UIButton) {
        requestBeer()
    }
    
    //MARK: - Helpers
    private func requestBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate(statusCode: 200..<300).responseJSON { [unowned self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let name = json[0]["name"].stringValue
                let description = json[0]["description"].stringValue
                let imageURL = json[0]["image_url"].stringValue
                
                self.beerImageView.kf.setImage(with: URL(string: imageURL), placeholder: UIImage(systemName: "takeoutbag.and.cup.and.straw.fill"))
                self.beerNameLabel.text = name
                self.beerDescriptionLabel.text = description
                
               
            case .failure(let error):
                print(error)
            }
        }
    }
}
