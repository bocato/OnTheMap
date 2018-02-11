//
//  Environment.swift
//  OnTheMap
//
//  Created by Eduardo Sanches Bocato on 27/01/18.
//  Copyright © 2018 Eduardo Sanches Bocato. All rights reserved.
//

import Foundation

class Environment {
    
    // MARK: Enums
    enum EnvironmentType: String {
        case dev = "dev"
    }
    
    // MARK: - Singleton
    static let shared = Environment()
    
    // MARK: - Properties
    var udacityBaseURL: String!
    var parseBaseURL: String!
    
    var parseApplicationId: String!
    var parseRestApiKey: String!
    
    var facebookApiId: String!
    
    var runtimeEnvironment: EnvironmentType?
    
    // MARK: - Computed Properties
    var currentRuntimeEnvironment: EnvironmentType? {
        guard let runtimeEnvironment = runtimeEnvironment else {
            return .dev
        }
        return runtimeEnvironment
    }
    
    // MARK: - Lifecycle
    init() {
        setup()
    }
    
    // MARK: - Configuration
    func setup() {
        guard let runtimeEnvironment = currentRuntimeEnvironment else { return }
        switch runtimeEnvironment {
        case .dev:
            self.udacityBaseURL = "https://www.udacity.com/api"
            self.parseBaseURL = "https://parse.udacity.com/parse/classes"
            self.parseApplicationId = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
            self.parseRestApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            self.facebookApiId = "365362206864879"
            break
        }
    }
    
}
