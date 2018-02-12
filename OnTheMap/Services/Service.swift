//
//  Service.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 29/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import UIKit

class Service {
    
    // MARK: - Properties
    static let shared = Service()
    
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case delete = "DELETE"
    }
    
    var defaultHeaders: [String: String] = [
        "content-type": "application/json",
        "accept": "application/json"
    ]
    
    // MARK: - Misc
    func request(httpMethod: HTTPMethod, url: URL, parameters: [String: Any]? = nil,
                 headers: [String:String]? = nil) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.allHTTPHeaderFields = defaultHeaders
        
        if let parameters = parameters {
            request.httpBody = JSON.serialize(dictionary: parameters)
        }
        
        guard let headers = headers else {
            return request
        }
        
        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }
        
        return request
    }
}

// MARK: - URLRequestExtension
// handle HTTPURLResponse and dispatch the request
extension URLRequest {
    
    
    /*
     Special Note on Udacity JSON Responses
     FOR ALL RESPONSES FROM THE UDACITY API, YOU WILL NEED TO SKIP THE FIRST 5 CHARACTERS OF THE RESPONSE.
     These characters are used for security purposes. In the upcoming examples,
     you will see that we subset the response data in order to skip over the first 5 characters.
     */
    private func normalizeUdacityData(_ data: Data?) -> Data? {
        guard let data = data else { return nil }
        let range = Range(5..<data.count)
        let normalizedData = data.subdata(in: range) /* subset response data! */
        return normalizedData
    }
    
    private func setUnknowErrorFor(serviceResponse: inout ServiceResponse, error: Error?) {
        if let error = error, error.isNetworkConnectionError {
            serviceResponse.serviceError = ErrorFactory.buildServiceError(with: .unexpected)
            return
        }
        serviceResponse.serviceError = ErrorFactory.buildServiceError(with: .unknown)
    }
    
    private func mapErrors(statusCode: Int, error: Error?, serviceResponse: inout ServiceResponse) {
        
        guard error == nil else {
            setUnknowErrorFor(serviceResponse: &serviceResponse, error: nil)
            return
        }
        
        guard 400...499 ~= statusCode, let data = serviceResponse.data, let jsonString = String(data: data, encoding: .utf8),
            let serializedValue = try? JSONDecoder().decode(ServiceError.self, from: data) else {
                setUnknowErrorFor(serviceResponse: &serviceResponse, error: error)
                return
        }
        
        serviceResponse.rawResponse = jsonString
        
        if serializedValue.error == nil {
            setUnknowErrorFor(serviceResponse: &serviceResponse, error: error)
        } else {
            serviceResponse.serviceError = serializedValue
        }
        
    }
    
    // Dispatch URLRequest instance
    private func dispatch(onCompleted completion: @escaping (ServiceResponse) -> Void, normalizingData: Bool = false) {
        
        URLSession.shared.dataTask(with: self) { data, res, error in
            
            var serviceResponse = ServiceResponse()
            
            serviceResponse.response = res as? HTTPURLResponse
            serviceResponse.request = self
            serviceResponse.data = normalizingData ? self.normalizeUdacityData(data) : data
            
            if let data = data {
                serviceResponse.rawResponse = String(data: data, encoding: .utf8)
            }
            
            guard let statusCode = serviceResponse.response?.statusCode else {
                self.setUnknowErrorFor(serviceResponse: &serviceResponse, error: error)
                completion(serviceResponse)
                return
            }
            
            if !(200...299 ~= statusCode) {
                self.mapErrors(statusCode: statusCode, error: error, serviceResponse: &serviceResponse)
            }
            
            completion(serviceResponse)
            
            }.resume()
    }
    
    /// Use this method to serialize object payload
    func response<SuccessObjectType: Codable>(normalizeData shouldNormalizeData: Bool = false, success: @escaping (SuccessObjectType?, ServiceResponse) -> Void,
                                              failed failure: @escaping (ServiceResponse) -> Void,
                                              completed completion: @escaping () -> Void) {
        
        dispatch(onCompleted: { (serviceResponse) in
            
            if let _ = serviceResponse.serviceError {
                failure(serviceResponse)
            } else {
                if let data = serviceResponse.data {
                    do {
                        let serializedObject = try JSONDecoder().decode(SuccessObjectType.self, from: data)
                        success(serializedObject, serviceResponse)
                    } catch let parserError {
                        debugPrint("*** parserError ***")
                        debugPrint(parserError)
                        success(nil, serviceResponse)
                    }
                } else {
                    success(nil, serviceResponse)
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
            
        }, normalizingData: shouldNormalizeData)
        
    }
    
}
