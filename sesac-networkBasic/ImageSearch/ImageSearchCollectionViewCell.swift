//
//  ImageSearchCollectionViewCell.swift
//  sesac-networkBasic
//
//  Created by MIN SEONG KIM on 2022/08/04.
//

import UIKit

class ImageSearchCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ImageSearchCollectionViewCell"
    
    @IBOutlet weak var searchImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
