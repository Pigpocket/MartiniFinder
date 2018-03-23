//
//  CDYelpFusionKitManager.swift
//  MartiniFinder
//
//  Created by Tomas Sidenfaden on 3/22/18.
//  Copyright © 2018 Tomas Sidenfaden. All rights reserved.
//

import Foundation
import CDYelpFusionKit
import UIKit

final class CDYelpFusionKitManager: NSObject {
    
    static let shared = CDYelpFusionKitManager()
    
    var apiClient: CDYelpAPIClient!
    
    func configure() {
        // How to authorize using your clientId and clientSecret
        self.apiClient = CDYelpAPIClient(apiKey: "8UOe63- UqKM8syYDjMXsdbJbMXWg1Hp6Tu0_kgQr_wUMP3Y2NEDXZE_Tdc_C_xSjihkl2PeM3n9sveqQ1bdXm2AQ1bviVEo1qpUbAk9m_3CmQv3wSlnYZ8qp5j5RWnYx")
    }
}
