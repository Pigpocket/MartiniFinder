//
//  YelpInfoViewController.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 4/1/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import UIKit

class YelpInfoViewController: UIViewController {
    
    @IBOutlet weak var yelpLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var yelpInfoText = "Thanks for supporting MartiniFinder! We're powered by Yelp, who places some restrictions on the use of its data by third party applications. \n\nThe Yelp API does not return full review text. In order to maintain a consistent Yelp experience across all platforms, the Yelp API uses a variety of factors to determine and return a business’s top review excerpts. The sort order is determined by recency, user voting, and other review quality factors to help consumers make informed decisions. \n\nThe Yelp API cannot be configured to return alternative or hand-picked review excerpts... for example: only those including the term 'martini'. As a result, it's possible a location may have a good rating, but simultaneously make terrible martinis. Our apologies. \n\nShould Yelp make this additional functionality available, we will certainly update the app! \n\n Home page photo credit: Lincoln J. Thompson"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.layer.backgroundColor = YelpColor.shared.medHighColor.cgColor
        okButton.layer.cornerRadius = 10
        okButton.layer.borderColor = UIColor.white.cgColor
        okButton.layer.borderWidth = 1
        okButton.layer.shadowRadius = 1.5
        okButton.layer.shadowColor = UIColor(red: 195/225, green: 89/255, blue: 75/255, alpha: 1.0).cgColor
        okButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        okButton.layer.shadowOpacity = 0.9
        
        yelpLabel.text = yelpInfoText
        
    }

    @IBAction func okAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
