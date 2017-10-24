//
//  EFNetworkDataModel.swift
//  Eason
//
//  Created by Efun on 2017/10/19.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import RealmSwift

class EFNetworkDataModel: Object {
    
    @objc dynamic var networkData = ""
    
    func fetchNetworkData() -> [Any]? {
        if networkData.count == 0 {
            return nil
        }
        let obj = EFExamineTool.stringToJson(jsonString: self.networkData)
        let arr = obj as? [Any]
        return arr
    }
}
