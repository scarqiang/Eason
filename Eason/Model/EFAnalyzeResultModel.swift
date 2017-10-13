//
//  EFAnalyzeResultModel.swift
//  Eason
//
//  Created by Efun on 2017/10/9.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

class EFAnalyzeResultModel: Object, Mappable {
    
    @objc dynamic var testString = ""
    
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map) {
        testString <- map["testString"]
    }
}

class EFAnalyzeWapModel: Object, Mappable {
    
    @objc dynamic var result: EFAnalyzeResultModel?
    @objc dynamic var textEmpty = ""
    let resultLists = List<EFAnalyzeResultModel>()
    
    
    required convenience init?(map: Map) {
        self.init()
        
    }
    
    func mapping(map: Map) {
        result <- map["result"]
        textEmpty <- map["textEmpty"]
        resultLists <- map["resultLists"]
    }
}
