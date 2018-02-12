//
//  StudentLocationService.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 31/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class StudentLocationService {
    
    private var path: String {
        return Environment.shared.parseBaseURL + "/StudentLocation"
    }
    
    private let parseHeaders: [String: String] = ["X-Parse-Application-Id": Environment.shared.parseApplicationId, "X-Parse-REST-API-Key": Environment.shared.parseRestApiKey]
    
    func getStudentLocations(_ limit: Int = 100, skip: Int? = nil, order: String = "-updatedAt", success: @escaping ((_ locations: [StudentInformation]?) -> Void), onFailure failure: ((ServiceError?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil) {
        
        
        var pathParams = [String: String]()
        
        pathParams["limit"] = "\(limit)"
        if let skip = skip {
            pathParams["skip"] = "\(skip)"
        }
        pathParams["order"] = order
        
        var urlString = path
        if pathParams.keys.count > 0 {
           urlString += URLHelper.escapedParameters(pathParams)
        }
        
        let url = URL(string: urlString)!
        
        Service.shared.request(httpMethod: .get, url: url, headers: parseHeaders).response(success: { (studentLocationsResponse: StudentLocationsResponse?, serviceResponse: ServiceResponse?) in
            success(studentLocationsResponse?.results)
        }, failed: { errorResponse in
            failure?(errorResponse.serviceError)
        }, completed: {
            completion?()
        })
        
    }
    
    func getStudentLocation(with uniqueKey: String!, success: @escaping ((_ location: StudentInformation?) -> Void), onFailure failure: ((ServiceError?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil) {
        
        let urlString = path + "?where={\"uniqueKey\":\"\(uniqueKey)\"}"
        let url = URL(string: urlString)!
        
        Service.shared.request(httpMethod: .get, url: url, headers: parseHeaders).response(success: { (studentLocation: StudentInformation?, serviceResponse: ServiceResponse?) in
            success(studentLocation)
        }, failed: { errorResponse in
            failure?(errorResponse.serviceError)
        }, completed: {
            completion?()
        })
        
    }
    
    func postStudentLocation(with requestObject: PostStudentLocationRequestObject,  success: @escaping ((_ postStudentLocationResponse: PostStudentLocationResponse?) -> Void), onFailure failure: ((ServiceError?) -> Void)? = nil, onCompletion completion: (() -> Void)? = nil) {
        
        let parameters: [String: Any] = ["uniqueKey": requestObject.uniqueKey,
                                            "firstName": requestObject.firstName,
                                            "lastName": requestObject.lastName,
                                            "mapString": requestObject.mapString,
                                            "mediaURL": requestObject.mediaURL,
                                            "latitude": requestObject.latitude,
                                            "longitude": requestObject.longitude]
        
        let url = URL(string: path)!
        
        Service.shared.request(httpMethod: .post, url: url, parameters: parameters, headers: parseHeaders).response(success: { (postStudentLocationResponse: PostStudentLocationResponse?, serviceResponse: ServiceResponse?) in
            success(postStudentLocationResponse)
        }, failed: { errorResponse in
            failure?(errorResponse.serviceError)
        }, completed: {
            completion?()
        })
        
    }
    
}
