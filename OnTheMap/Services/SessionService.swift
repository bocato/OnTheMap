//
//  SessionService.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 29/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class SessionService {
    
    private var path: String {
        return Environment.shared.udacityBaseURL + "/session"
    }
    
    func postSession(with username: String!, password: String!, success: @escaping ((_ sessionResponse: SessionResponse?) -> Void), onFailure failure: ((ServiceError?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil) {
        
        let url = URL(string: path)!
        let parameters = ["udacity": ["username": username, "password": password] ]
        
        Service.shared.request(httpMethod: .post, url: url, parameters: parameters).response(normalizeData: true, success: { (sessionResponse: SessionResponse?, serviceResponse: ServiceResponse?) in
            success(sessionResponse)
        }, failed: { errorResponse in
            failure?(errorResponse.serviceError)
        }, completed: {
            completion?()
        })
        
    }
    
    func deleteSession(_ success: @escaping ((_ sessionResponse: DeleteSessionResponse?) -> Void), onFailure failure: ((ServiceError?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil) {
        
        guard let cookies = HTTPCookieStorage.shared.cookies, let xsrfTokenCookie = cookies.filter( { $0.name == "XSRF-TOKEN" } ).first else { return }
        let url = URL(string: path)!
        let headers = ["X-XSRF-TOKEN": xsrfTokenCookie.value]
        
        Service.shared.request(httpMethod: .delete, url: url, headers: headers).response(normalizeData: true, success: { (sessionResponse: DeleteSessionResponse?, serviceResponse: ServiceResponse?) in
            success(sessionResponse)
        }, failed: { errorResponse in
            failure?(errorResponse.serviceError)
        }, completed: {
            completion?()
        })
        
    }
    
}
