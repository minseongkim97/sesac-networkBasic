//
//  BeerListTableViewCell.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/02.
//

import UIKit

class BeerListTableViewCell: UITableViewCell {
    static let identifier = "BeerListTableViewCell"

    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(beer: Beer) {
        beerImageView.kf.setImage(with: URL(string: beer.imageURL), placeholder: UIImage(systemName: "takeoutbag.and.cup.and.straw.fill"))
        nameLabel.text = beer.name
        descriptionLabel.text = beer.description
    }
}
