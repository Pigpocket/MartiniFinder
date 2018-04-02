//
//  TableViewDelegate.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/31/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! TableViewCell
        let location = Location.sharedInstance[indexPath.row]
        
        cell.nameLabel.text = location.name
        cell.nameLabel.textColor = UIColor.white
        
        performUIUpdatesOnMain {
            
            cell.backgroundColor = UIColor.black
            
            cell.thumbnailImageView.layer.cornerRadius = 10
            cell.thumbnailImageView.clipsToBounds = true
            cell.thumbnailImageView.layer.borderColor = UIColor.white.cgColor
            cell.thumbnailImageView.layer.borderWidth = 1
            cell.thumbnailImageView.image = location.image
            
            cell.nameLabel.text = location.name
            cell.nameLabel.textColor = UIColor.white
            
            cell.priceLabel.text = location.price
            cell.priceLabel.textColor = UIColor.white
            
            let distance = MyLocation.shared.getDistance(latitude: location.latitude, longitude: location.longitude)
            cell.distanceLabel.text = "\(distance) miles"
            cell.distanceLabel.textColor = UIColor.white
            
            cell.displayRating(location: location)
            
            cell.reviewCountLabel.text = ("\(location.reviewCount) reviews")
            let rating = location.rating
            if rating <= 1.5 {
                cell.reviewCountLabel.textColor = YelpColor.shared.lowColor
            } else if rating > 1.5 && rating <= 2.5 {
                cell.reviewCountLabel.textColor = YelpColor.shared.lowMedColor
            } else if rating > 2.5 && rating <= 3.5 {
                cell.reviewCountLabel.textColor = YelpColor.shared.medColor
            } else if rating > 3.5 && rating <= 4.5 {
                cell.reviewCountLabel.textColor = YelpColor.shared.medHighColor
            } else if rating > 4.5 {
                cell.reviewCountLabel.textColor = YelpColor.shared.highColor
            }
            cell.reviewCountLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Location.sharedInstance.count
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Get each cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") as! TableViewCell
        
        let nameText = Location.sharedInstance[indexPath.row].name
        
        var size = CGSize()
        
        if let font = UIFont(name: ".SFUIText", size: 17.0) {
            let fontAttributes = [NSAttributedStringKey.font: font]
            size = (nameText as NSString).size(withAttributes: fontAttributes)
        }
        
        let normalCellHeight = CGFloat(96)
        let extraLargeCellHeight = CGFloat(normalCellHeight + 20.33)
        
        let textWidth = ceil(size.width)
        let infoStackViewWidth = ceil(cell.infoStackView.frame.width - 20)
        
        if textWidth > infoStackViewWidth {
            return extraLargeCellHeight
        } else {
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let location = Location.sharedInstance[indexPath.row]
        
        // Get the Yelp URL of the location and segue to that in browser
        YelpClient.sharedInstance().getUrlFromLocationName(id: location.id) { (url, error) in
            
            performUIUpdatesOnMain {
                
                if error != nil {
                    print("There was an error getting the URL")
                }
                
                if let url = url {
                    let app = UIApplication.shared
                    app.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
