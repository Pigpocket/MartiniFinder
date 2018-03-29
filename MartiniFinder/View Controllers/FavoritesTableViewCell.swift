//
//  FavoritesTableViewCell.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 2/12/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    // MARK: Outlets
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var blankView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    
    func displayRating(rating: Double) {
        
        if rating == 1 {
            star1.image = UIImage(named: "regular_1")
        } else if rating == 1.5 {
            star1.image = UIImage(named: "regular_1_half")
        } else if rating == 2 {
            star1.image = UIImage(named: "regular_2")
        } else if rating == 2.5 {
            star1.image = UIImage(named: "regular_2_half")
        } else if rating == 3.0 {
            star1.image = UIImage(named: "regular_3")
        } else if rating == 3.5 {
            star1.image = UIImage(named: "regular_3_half")
        } else if rating == 4.0 {
            star1.image = UIImage(named: "regular_4")
        } else if rating == 4.5 {
            star1.image = UIImage(named: "regular_4_half")
        } else if rating == 5.0 {
            star1.image = UIImage(named: "regular_5")
        }
    }
    
}
