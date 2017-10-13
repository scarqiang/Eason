//
//  EFNetworking.swift
//  Eason
//
//  Created by Efun on 2017/10/12.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import Alamofire

enum EFGameArea: String {
    case sea = "SEA"
    case hk = "HK_TW"
    case kr = "KR"
}

class EFNetworking: NSObject {
    
    let gameListAPI =  "http://172.16.5.155:8000/package_info/get_game_info/?game_platform=iOS"
    
    private override init() {
        super.init()
    }
    
    static let shared = EFNetworking()
    
    func fetchGameList(area: EFGameArea, completion: @escaping (_ response: [EFGameListItemModel]?) -> Void) {
        let URL = "\(gameListAPI)&reg_name=\(area.rawValue)"
        Alamofire.request(URL).responseArray { (response: DataResponse<[EFGameListItemModel]>) in
            let gameList = response.result.value
            DispatchQueue.main.async {
                completion(gameList)
            }
        }
    }
}
