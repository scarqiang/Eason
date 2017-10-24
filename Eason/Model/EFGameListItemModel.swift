//
//  EFGameListItemModel.swift
//  Eason
//
//  Created by Efun on 2017/10/12.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class EFGameListItemModel: Object, Mappable {
    
    @objc dynamic var pk = 0
    @objc dynamic var packaged_date = ""
    @objc dynamic var game_code_info:EFGameListItemInfoModel?
    
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map) {
        pk <- map["pk"]
        packaged_date <- map["packaged_date"]
        game_code_info <- map["game_code_info"]
    }
}

class EFGameListItemInfoModel: Object, Mappable {
    
    @objc dynamic var game_region = ""
    @objc dynamic var game_code = ""
    @objc dynamic var game_name = ""
    var icon: String {
        get {
            return "http://172.16.5.155:8000/resources/Common/icons/\(self.game_code)/\(self.game_code).png"
        }
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        game_region <- map["game_region"]
        game_code <- map["game_code"]
        game_name <- map["game_name"]
    }
}

class EFRecentGameListModel: Object {
    let recentGameList = List<EFGameListItemModel>()
}
