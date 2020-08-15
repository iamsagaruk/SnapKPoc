//
//  DataPlannerUseCase.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import ObjectMapper

typealias DataParsedCompletionHandler = (_ isSuccess: Bool, _ response: Any?, _ error: NetworkErrorModel?) -> Void

public class DataPlannerUseCase {
    static let sharedUseCase = DataPlannerUseCase()

    func getDetails(completionHandler: @escaping DataParsedCompletionHandler) {
        NetworkClient.sharedClient.sendGetRequest(AppConstant.kFetchDataPlanningUrl, parameters: nil, headers: nil) { (isSuccess, response, error) in
            if isSuccess {
                let articleList = Mapper<PlanningDataResponse>().mapArray(JSONObject: response)
                completionHandler(isSuccess, articleList, nil)
            } else {
                completionHandler(false, nil, error)
            }
        }
    }
}
