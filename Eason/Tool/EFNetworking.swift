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
    let loginAPI = "https://manager.efun.com/userlogin.externalLogin.shtml"
    
    private override init() {
        super.init()
    }
    
    static let shared = EFNetworking()
    
    func fetchGameList(area: EFGameArea, completion: @escaping (_ response: [EFGameListItemModel]?, _ error: Error?) -> Void) {
        let URL = "\(gameListAPI)&reg_name=\(area.rawValue)"

        Alamofire.request(URL).responseArray { (response: DataResponse<[EFGameListItemModel]>) in
            let gameList = response.result.value
            DispatchQueue.main.async {
                completion(gameList, response.error)
            }
        }
    }
    
    func fetchSearchResult(keyword: String, completion: @escaping (_ response: [EFGameListItemModel]?, _ error: Error?) -> Void) {
        let URL = "\(gameListAPI)&searchInfo=\(keyword)"
        Alamofire.request(URL).responseArray { (response: DataResponse<[EFGameListItemModel]>) in
            let gameList = response.result.value
            DispatchQueue.main.async {
                completion(gameList, response.error)
            }
        }
    }
    
    func fetchLoginInfo(username: String, password: String, completion: @escaping (_ response: [String: Any]?, _ error: Error?) -> Void) {
        let parameter = ["userName": username,
                         "password": password]
        
//        let url = URL(string: loginAPI)
        
        Alamofire.request(loginAPI, method: .post, parameters: parameter, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
            let dic = response.result.value as? [String: Any]
            
            if dic?["code"] as? String == "1000" {
                EFUserInfo.saveUserInfo(username: username, password: password)
            }
 
            DispatchQueue.main.async {
                completion(dic, response.error)
            }
        }
    }
    
}
