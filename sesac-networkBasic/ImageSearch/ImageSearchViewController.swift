//
//  ImageSearchViewController.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/03.
//

import UIKit

import Alamofire
import JGProgressHUD
import Kingfisher
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    //MARK: - Properties
    let hud = JGProgressHUD()
    
    var startPage = 1
    var totalCount = 0
    var list: [String] = [] {
        didSet {
            DispatchQueue.main.async {
                self.imageSearchCollectionView.reloadData()
            }
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var imageSearchCollectionView: UICollectionView! {
        didSet {
            imageSearchCollectionView.delegate = self
            imageSearchCollectionView.dataSource = self
            imageSearchCollectionView.prefetchDataSource = self
            imageSearchCollectionView.register(UINib(nibName: ImageSearchCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageSearchCollectionViewCell.identifier)
            imageSearchCollectionView.collectionViewLayout = collectionViewLayout()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Helpers
    func fetchImage(query: String) {
        self.hud.show(in: self.view)
        ImageSearchAPIManager.shared.fetchImage(query: query, startPage: startPage) { [weak self] totalCount, list in
            self?.totalCount = totalCount
            self?.list.append(contentsOf: list)
            self?.hud.dismiss()
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

//MARK: - Extension: UISearchBar
extension ImageSearchViewController: UISearchBarDelegate {
    // 검색 버튼 클릭 시 실행. 검색 단어가 바뀔 수 있다.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            list.removeAll()
            startPage = 1
//            imageSearchCollectionView.scrollToItem(at: [0,0], at: .top, animated: true)
            fetchImage(query: text)
        }
        view.endEditing(true)
    }
    
    // 취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        list.removeAll()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    // 서치바에 커서가 깜빡이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

// pagination 방법3. 용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우에 효과적.
// 셀이 화면에 보이기 전에 미리. 필요한 리소스를 다운받을 수 있고, 필요하지 않다면 데이터를 취소할 수도 있다.
// iOS10 이상, 스크롤 성능 향상됨.
extension ImageSearchViewController: UICollectionViewDataSourcePrefetching {
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        print("===\(indexPaths)")
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 30
                fetchImage(query: searchBar.text!)
            }
        }
    }
    
    // 작업 취소.
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소: \(indexPaths)")
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
        cell.backgroundColor = .lightGray
        return cell
    }
    
    // pagination 방법1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    // 마지막 셀에 사용자가 위치해있는지 명확하게 확인하기가 어렵다.
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    // pagination 방법2. UIScrollViewDelegateProtocol.
    // 테이블뷰/컬렉션뷰 스크롤뷰를 상속받고 있기 때문에 스크롤뷰 프로토콜을 사용할 수 있다.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
    }
}
