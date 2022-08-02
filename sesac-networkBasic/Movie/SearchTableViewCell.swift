//
//  SearchTableViewCell.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    static let identifier = "SearchTableViewCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var openDateLabel: UILabel!
    @IBOutlet weak var audiAccLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(boxOffice: BoxOfficeModel) {
        nameLabel.text = boxOffice.movieTitle
        openDateLabel.text = boxOffice.releasDate
        audiAccLabel.text = boxOffice.totalCount
    }
}
