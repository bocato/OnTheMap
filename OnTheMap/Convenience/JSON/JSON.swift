//
//  JSON.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 29/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class JSON {
    
    class func serialize(dictionary: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return jsonData
        } catch {
            // Return nil if serialization fails
            return nil
        }
    }
    
    class func deserialize(data: Data) -> [String: Any]? {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonDict as? [String: Any]
        } catch {
            return nil
        }
    }
}
