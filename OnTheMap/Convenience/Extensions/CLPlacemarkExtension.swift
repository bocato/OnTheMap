//
//  CLPlacemarkExtension.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 11/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation
import CoreLocation

extension CLPlacemark {
    
    var mapString: String? {
        var strings = [String]()
        if let thoroughfare = self.thoroughfare {
            strings.append(thoroughfare)
        }
        if let subThoroughfare = self.subThoroughfare {
            strings.append(subThoroughfare)
        }
        if let locality = self.locality {
            strings.append(locality)
        }
        return strings.count > 0 ? strings.joined(separator: ", ") : nil
    }
    
}

