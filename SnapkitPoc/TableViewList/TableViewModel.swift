//
//  TableViewModel.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import ObjectMapper

public enum SortType: String {
    case image
    case text
    case noFilter
}

class TableViewModel {
    static let sharedTableVM = TableViewModel()
    var planningDataList: [PlanningDataResponse]?
    var sortedDataList: [PlanningDataResponse]?

    func getDetails(completionHandler: @escaping DataParsedCompletionHandler) {
        DataPlannerUseCase.sharedUseCase.getDetails { [weak self] (isSuccess, response , errorModel) in
            debugPrint("response", response)
            if isSuccess {
                if let myData = response {
                    self?.prepareData(myData)
                    self?.saveDataOffline()
                }
                completionHandler(isSuccess, response, nil)
            } else {
                completionHandler(false, nil, errorModel)
            }
        }
    }
    
    func prepareData(_ response : Any?) {
        let list = response as? [PlanningDataResponse] ?? [].compactMap{ $0 }
        planningDataList = list.filter { $0.planningData != "" || $0.planningData != nil}
        sortedDataList = planningDataList
    }
    
    func setSortedArray(selectedType: String) {
        let sortedType = SortType(rawValue: selectedType)
        
        switch sortedType {
        case .image, .text:
            sortedDataList = planningDataList?.filter { $0.type == selectedType}
        default:
            sortedDataList = planningDataList
        }
    }
    
    func saveDataOffline() {
        if !(planningDataList?.isEmpty ?? false) {
            UserDefaults.standard.setStructArray(planningDataList ?? [], forKey: "cavista")
        }
    }
    
    func getOfflineData() -> [PlanningDataResponse]? {
        return UserDefaults.standard.structArrayData(PlanningDataResponse.self, forKey: "cavista")
    }
}

