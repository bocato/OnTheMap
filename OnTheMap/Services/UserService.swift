//
//  UserService.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 31/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class UserService {
    
    private var path: String {
        return Environment.shared.udacityBaseURL + "/users"
    }
    
    func getUser(with id: String!, success: @escaping ((_ user: User?) -> Void), onFailure failure: ((ServiceResponse?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil) {
        
        let pathString = path + "/" + id
        let url = URL(string: pathString)!
        
        Service.shared.request(httpMethod: .get, url: url).response(normalizeData: true, success: { (userResponse: UserResponse?, serviceResponse: ServiceResponse?) in
            CurrentSessionData.shared.userData = userResponse?.user
            success(userResponse?.user)
        }, failed: { errorResponse in
            failure?(errorResponse)
        }, completed: {
            completion?()
        })
        
    }
    
}
