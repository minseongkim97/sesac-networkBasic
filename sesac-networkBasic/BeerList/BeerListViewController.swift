//
//  BeerListViewController.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/02.
//

import UIKit

import Alamofire
import Kingfisher
import SwiftyJSON

class BeerListViewController: UIViewController {
    //MARK: - Properties
    var list: [Beer] = [] {
        didSet {
            beerListTableView.reloadData()
        }
    }
    
    @IBOutlet weak var beerListTableView: UITableView! {
        didSet {
            beerListTableView.backgroundColor = .clear
            beerListTableView.separatorColor = .clear
            beerListTableView.rowHeight = 160
            beerListTableView.delegate = self
            beerListTableView.dataSource = self
            beerListTableView.register(UINib(nibName: BeerListTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: BeerListTableViewCell.identifier)
        }
    }
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestBeerList()
    }
    
    //MARK: - Helpers
    private func requestBeerList() {
        list.removeAll()
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for beer in json.arrayValue {
                    let imageURL = beer["image_url"].stringValue
                    let name = beer["name"].stringValue
                    let description = beer["description"].stringValue
                    
                    let beer = Beer(imageURL: imageURL, name: name, description: description)
                    self.list.append(beer)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - Extension: UITableView
extension BeerListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BeerListTableViewCell.identifier, for: indexPath) as? BeerListTableViewCell else { return UITableViewCell() }
        cell.backgroundColor = .clear
        cell.configureCell(beer: list[indexPath.row])
        return cell
    }
}
