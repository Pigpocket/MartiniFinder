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
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var blankView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    
    
    func displayRating(location: Favorites) {
        
        if location.rating == 1 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "emptyStar")
            star3.image = UIImage(named: "emptyStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 1.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "halfStar")
            star3.image = UIImage(named: "emptyStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 2 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "emptyStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 2.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "halfStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 3.0 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 3.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "halfStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 4.0 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "filledStar")
            star5.image = UIImage(named: "emptyStar")
        } else if location.rating == 4.5 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "filledStar")
            star5.image = UIImage(named: "halfStar")
        } else if location.rating == 5.0 {
            star1.image = UIImage(named: "filledStar")
            star2.image = UIImage(named: "filledStar")
            star3.image = UIImage(named: "filledStar")
            star4.image = UIImage(named: "filledStar")
            star5.image = UIImage(named: "filledStar")
        }
    }
    
}
