//
//  HTTPHelper.swift
//  Skiy
//
//  Created by Tristan Secord on 2016-07-12.
//  Copyright © 2016 Tristan Secord. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum HTTPRequestAuthType {
    case httpBasicAuth
    case httpTokenAuth
}

struct HTTPHelper {
    static let API_AUTH_NAME = "MIFIapiADMIN"
    static let API_AUTH_PASSWORD = "wmk38jvebt7h5mmgqu4kaj2vdz1rzre9fftbwjha4dq7rnaxqqucswrzuu1za27w"
    static let BASE_URL = "http://mifi.tmsmifi.com/api"
    
    func sendAlamofire(url: String, method: HTTPMethod, parameters: Parameters?, headers: HTTPHeaders?, requestType: HTTPRequestAuthType) -> DataRequest? {
        
        //add authorization header
        var headersCopy: HTTPHeaders
        if headers == nil {
            headersCopy = [:]
        } else {
            headersCopy = headers!
        }
        
        switch(requestType) {
        case .httpBasicAuth:
            return (Alamofire.request("\(HTTPHelper.BASE_URL)/\(url)", method: method, parameters: parameters, encoding: URLEncoding.default, headers: headersCopy).authenticate(user: HTTPHelper.API_AUTH_NAME, password: HTTPHelper.API_AUTH_PASSWORD).validate())
        case .httpTokenAuth:
            // Retreieve Auth_Token from Keychain
            if let userToken = KeychainAccess.passwordForAccount("Auth_Token", service: "KeyChainService") as String? {
                // Set Authorization header
                headersCopy["Authorization"] = "Token token=\(userToken)"
            }
            return (Alamofire.request("\(HTTPHelper.BASE_URL)/\(url)", method: method, parameters: parameters, encoding: URLEncoding.default, headers: headersCopy).validate())
        }
    }
}
