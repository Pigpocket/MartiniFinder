//
//  MapViewViewConfiguration.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/31/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    func configureResetLocationButton() {
        resetLocationButton.isHidden = true
        resetLocationButton.contentHorizontalAlignment = .fill
        resetLocationButton.contentVerticalAlignment = .fill
        resetLocationButton.contentMode = .scaleAspectFit
    }
    
    func configureRedoSearchButton() {
        redoSearchButton.isHidden = true
        redoSearchButton.layer.cornerRadius = 10
        redoSearchButton.layer.borderColor = UIColor.black.cgColor
        redoSearchButton.layer.borderWidth = 1
        redoSearchButton.layer.shadowRadius = 1.5
        redoSearchButton.layer.shadowColor = UIColor(red: 195/255, green: 89/255, blue: 75/255, alpha: 1.0).cgColor
        redoSearchButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        redoSearchButton.layer.shadowOpacity = 0.9
        redoSearchButton.layer.masksToBounds = false
    }
    
    func configureLocationView() {
        locationView.isHidden = true
        locationView.layer.cornerRadius = 10
        locationView.layer.borderColor = UIColor.black.cgColor
        locationView.layer.borderWidth = 1
        locationView.layer.shadowRadius = 1.5
        locationView.layer.shadowColor = UIColor(red: 195/255, green: 89/255, blue: 75/255, alpha: 1.0).cgColor
        locationView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        locationView.layer.shadowOpacity = 0.9
        locationView.layer.masksToBounds = false
        locationView.isUserInteractionEnabled = true
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.borderColor = UIColor.white.cgColor
        thumbnailImageView.layer.borderWidth = 1
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.width * 2
    }
    
    func configureTabBar() {
        self.tabBarController?.setNavigationItem()
        self.tabBarController?.tabBar.tintColor = UIColor.white
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.isTranslucent = false
    }
    
    func viewHeight(_ locationName: String) -> CGFloat {
        
        var locationName = String()
        
        if let tappedLocation = tappedLocation {
            locationName = tappedLocation.name
        }
        
        var size = CGSize()
        
        if let font = UIFont(name: ".SFUIText", size: 17.0) {
            let fontAttributes = [NSAttributedStringKey.font: font]
            size = (locationName as NSString).size(withAttributes: fontAttributes)
        }
        
        let normalCellHeight = horizontalStackViewHeightConstraint.constant
        let extraLargeCellHeight = horizontalStackViewHeightConstraint.constant + 20.33
        
        let textWidth = ceil(size.width)
        let cellWidth = ceil(nameLabel.frame.width)
        
        if textWidth > cellWidth {
            return extraLargeCellHeight
        } else {
            return normalCellHeight
        }
    }
    
    func displayRating(location: Location) {
        
        if location.rating == 1 {
            star1.image = UIImage(named: "regular_1")
        } else if location.rating == 1.5 {
            star1.image = UIImage(named: "regular_1_half")
        } else if location.rating == 2 {
            star1.image = UIImage(named: "regular_2")
        } else if location.rating == 2.5 {
            star1.image = UIImage(named: "regular_2_half")
        } else if location.rating == 3.0 {
            star1.image = UIImage(named: "regular_3")
        } else if location.rating == 3.5 {
            star1.image = UIImage(named: "regular_3_half")
        } else if location.rating == 4.0 {
            star1.image = UIImage(named: "regular_4")
        } else if location.rating == 4.5 {
            star1.image = UIImage(named: "regular_4_half")
        } else if location.rating == 5.0 {
            star1.image = UIImage(named: "regular_5")
        }
    }
}
