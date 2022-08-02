//
//  SearchViewController.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/02.
//

import UIKit

import Alamofire
import SwiftyJSON

class SearchViewController: UIViewController {
    //MARK: - Properties
    var list: [BoxOfficeModel] = [] {
        didSet {
            self.searchTableView.reloadData()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            searchTableView.backgroundColor = .clear
            searchTableView.separatorColor = .clear
            searchTableView.rowHeight = 120
            searchTableView.delegate = self
            searchTableView.dataSource = self
            searchTableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestBoxOffice(text: yesterdayStr())
    }
    
    //MARK: - Helpers
    private func yesterdayStr() -> String {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        return dateFormatter.string(from: yesterday)
    }
    
    private func requestBoxOffice(text: String) {
        list.removeAll()
        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue
                    
                    let boxOffice = BoxOfficeModel(movieTitle: movieNm, releasDate: openDt, totalCount: audiAcc)
                    self.list.append(boxOffice)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extension: UITableView
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.configureCell(boxOffice: list[indexPath.row])
        return cell
    }
}

//MARK: - Extension: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text!)
    }
}
    
