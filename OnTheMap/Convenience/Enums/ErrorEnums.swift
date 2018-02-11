//
//  ErrorEnums.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 10/02/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case unknown = -111
    case unexpected = -999
}

enum ErrorMessage: String {
    case unknown = "An unknown error has occured. Try again later."
    case unexpected = "An unexpected error has occured. Check your internet connection and try again."
    case couldNotLoadUserData = "Could not load user data."
    case invalidEmailOrPassword = "Invalid e-mail or password."
    case noMatchingLocationFound = "No Matching Location Found"
    case unableToFindLocationForAddress = "Unable to Find Location for Address"
    case invalidLink = "Invalid link."
    case invalidAddress = "Invalid address."
    case couldNotLoadData = "Could not load data."
    case couldNotOpenURL = "Sorry, we could'n open URL, try again later."
}

class ErrorFactory {
    
    static func buildServiceError(with code: ErrorCode!) -> ServiceError! {
        switch code {
        case .unknown:
            return ServiceError(error: ErrorMessage.unknown.rawValue, status: ErrorCode.unknown.rawValue)
        case .unexpected:
            return ServiceError(error: ErrorMessage.unexpected.rawValue, status: ErrorCode.unexpected.rawValue)
        default:
            return ServiceError(error: ErrorMessage.unknown.rawValue, status: ErrorCode.unknown.rawValue)
        }
    }
    
}
