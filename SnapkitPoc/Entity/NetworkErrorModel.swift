//
//  NetworkErrorModel.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation

struct NetworkErrorModel {
    var networkStatusType: NetworkError = .somethingWentWrong
    var error: Error?
    var statusCode: Int? = 200
    var message: String?
}
