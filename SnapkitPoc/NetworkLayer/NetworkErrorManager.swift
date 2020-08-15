//
//  NetworkErrorManager.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import Alamofire

class InternetManager {
    class var isConnectedToInternet: Bool {
        if let network = NetworkReachabilityManager() {
            return network.isReachable
        }
        return false
    }
}

public enum NetworkError {
    case somethingWentWrong
    case timeOut
    case noInternet
    case serviceUnavailable
    
    func errorTitle() -> String {
        switch self {
        case .timeOut: return "TIMEOUT ERROR!"
        case .noInternet: return "NO INTERNET CONNECTION!"
        case .serviceUnavailable: return "SERVICE UNAVAILABLE"
        default: return "SOMETHING WENT WRONG!"
        }
    }
    
    func errorDescription() -> String {
        switch self {
        case .timeOut: return "Sorry, this page is no longer available due to a timeout error. Please try again later."
        case .noInternet: return "Please check your connection and try again."
        default: return "Please try again now or in a few minutes."
        }
    }
    
    func errorHeader() -> String {
        switch self {
        case .noInternet: return "No internet connection detected:"
        default: return "Oh no, an unexpected error has occurred:"
        }
    }
}
