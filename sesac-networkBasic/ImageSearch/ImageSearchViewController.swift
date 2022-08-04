//
//  ImageSearchViewController.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/03.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    //MARK: - Properties
    var list: [String] = [] {
        didSet {
            imageSearchCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var imageSearchCollectionView: UICollectionView! {
        didSet {
            imageSearchCollectionView.delegate = self
            imageSearchCollectionView.dataSource = self
            imageSearchCollectionView.register(UINib(nibName: ImageSearchCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.identifier)
            imageSearchCollectionView.collectionViewLayout = collectionViewLayout()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
    }
    
    //MARK: - Helpers
    // fetch, request, callRequest, getImage ...> response에 따라 네이밍을 설정해주기도 함
    func fetchImage() {
        // UTF-8로 인코딩한다. 한글 인코딩
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=1"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for item in json["items"].arrayValue {
                    self.list.append(item["link"].stringValue)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let space: CGFloat = 8
        let width = UIScreen.main.bounds.width - (space * 4)
        layout.itemSize = CGSize(width: width/3, height: width/3)
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = space
        layout.minimumLineSpacing = space
        return layout
    }
}

//MARK: - Extension: UICollectionView
extension ImageSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageSearchCollectionViewCell.identifier, for: indexPath) as? ImageSearchCollectionViewCell else { return UICollectionViewCell() }
        let url = URL(string: list[indexPath.row])
        cell.searchImageView.kf.setImage(with: url)
        return cell
    }
}
