//
//  PlanningDataResponse.swift
//  SnapkitPoc
//
//  Created by Sagar on 14/08/20.
//  Copyright © 2020 Sagar. All rights reserved.
//

import Foundation
import ObjectMapper

public struct PlanningDataResponse: Codable {
    public var dataId: String?
    public var type: String?
    public var date: String?
    public var planningData: String?
}

extension PlanningDataResponse: ImmutableMappable {
    public init(map: Map) {
        dataId = try? map.value("id")
        type = try? map.value("type")
        date = try? map.value("date")
        planningData = try? map.value("data")
    }
    
    public func mapping(map: Map) {
        dataId >>> map["id"]
        type >>> map["type"]
        date >>> map["date"]
        planningData >>> map["data"]
    }
}
