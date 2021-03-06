//
//  EFExamineTool.swift
//  Eason
//
//  Created by Efun on 2017/10/10.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import RealmSwift
import ObjectMapper
import NVActivityIndicatorView

class EFExamineTool: NSObject {
    
    enum EFAnalyzeMode {
        case test
        case network
    }
    
    static let queue = DispatchQueue(label: "com.savedata.queue")
    static let loadingView = createLoadingView()
    static let kEFReloadDataNotifictaion = Notification.Name("kEFReloadDataNotifictaion")
    /*
     twtestios://networking_mode
     
     twtestios://test_mode/
     {"file_name":"xxx",
     "uuid_reset":0,
     "user_default_reset":1}
     
     twtestios://log_mode/
     {"file_name":"xxx"}
     */
    //启动测试模式
    class func taggerTestMode(uuidReset: Bool, userDefaultReset: Bool, gameCode: String) {
        var scheme = gameCode
        //scheme = gameShortName + ios
        if scheme.hasSuffix("ios") == false {
            scheme += "ios"
        }
        let domain = "\(scheme)://test_mode/"
        let fileName = getTimestemp()
        
        let parameter = ["file_name": fileName,
                         "uuid_reset": uuidReset ? "1" : "0",
                         "user_default_reset": userDefaultReset ? "1" : "0",
                         "entranceShowDelay": "10"]
        
        let path = jsonToString(json: parameter)
        let data = path.data(using: .utf8)
        
        let dataString = data?.hexadecimal()
        
        let urlStr = "\(domain)\(dataString!)"
        let url = URL.init(string: urlStr)
        
        UIApplication.shared.openURL(url!)
    }
    
    //网络调试模式
    class func taggerNetworkMode(gameCode: String) {
        var scheme = gameCode
        if scheme.hasSuffix("ios") == false {
            scheme += "ios"
        }
        let domain = "\(scheme)://networking_mode/"
        //添加延迟十秒启动
        let parameter = ["entranceShowDelay": "10"]
        
        let path = jsonToString(json: parameter)
        let data = path.data(using: .utf8)
        
        let dataString = data?.hexadecimal()
        
        let urlStr = "\(domain)\(dataString!)"
        let url = URL.init(string: urlStr)
        UIApplication.shared.openURL(url!)
    }
    
    ///保存测试分析数据
    class func saveAnalyzetionData(url: URL, complete:@escaping (_ mode: EFAnalyzeMode) -> Void) {
        if url.scheme! != "efunExaminer" {
            return
        }
        
        var path = url.path
        path = path.replacingOccurrences(of: "\\", with: "")
        let data:Data = (String.hexadecimal(path)())!
        let jsonStr = String(data: data, encoding: .utf8) as String!
        //保存app测试数据
        if url.host == "test_mode" {
            queue.sync {
                let testModel = EFAppAnalyzationModel(JSONString: jsonStr!)
                if let model = testModel {
                    model.timestemp = getTimestemp()
                    let realm = try! Realm()
                    try! realm.write {
                        realm.add(model)
                    }
                }
                
                DispatchQueue.main.async {
                    let userInfo: [String: String] = ["gameCode": (testModel?.resultGameCode)!]
                    NotificationCenter.default.post(name: kEFReloadDataNotifictaion, object: nil, userInfo: userInfo)
                    complete(.test)
                }
            }
        }
        else if url.host == "networking_mode" {
            queue.sync {
                if jsonStr != nil {
                    let realm = try! Realm()
                    var model = realm.objects(EFNetworkDataModel.self).first
                    if model == nil {
                        model = EFNetworkDataModel()
                        model?.networkData = jsonStr!
                        try! realm.write {
                            realm.add(model!)
                        }
                    }
                    else {
                        try! realm.write {
                            model?.networkData = jsonStr!
                        }
                    }
                }
                DispatchQueue.main.async {
                    complete(.network)
                }
            }
        }
    }
    
    ///通过gameCode获取分析数据
    class func readAnalyzationData(gameCode: String, complete:@escaping (_ modelList: [EFAppAnalyzationModel]?)->Void) {
        //resultGameCode = gameShortName
        var gameShortName = gameCode
        if gameShortName.hasSuffix("ios") {
            gameShortName.removeSubrange(gameShortName.index(gameShortName.endIndex, offsetBy: -3)..<gameShortName.endIndex)
        }
        
        queue.sync {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "resultGameCode = %@", gameShortName)
            let list = realm.objects(EFAppAnalyzationModel.self).filter(predicate)
            let array = Array(list.reversed())
            DispatchQueue.main.async {
                complete(array)
            }
        }
    }
    
    ///保存最近游戏数据
    class func saveRecentGamesData(model: EFGameListItemModel) {
        queue.sync {
            let realm = try! Realm()
            let recentList = realm.objects(EFRecentGameListModel.self)
            var recentModel = recentList.first
            var isExist = false
            var index = 0
            if recentModel == nil {
                recentModel = EFRecentGameListModel()
                recentModel?.recentGameList.append(model)
                try! realm.write {
                    realm.add(recentModel!)
                }
                return;
            }
            
            for item in recentModel!.recentGameList {
                if item.game_code_info!.game_code == model.game_code_info?.game_code {
                    isExist = true
                    break
                }
                index += 1
            }
            
            try! realm.write {
                if isExist {
                    recentModel!.recentGameList.remove(at: index)
                }
                recentModel!.recentGameList.insert(model, at: 0)
            }
        }
    }
    
    //obj to jsonString
   class func jsonToString(json: Any) ->String{
        
        var jsonString = ""
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            print(convertedString!) // <-- here is ur string
            jsonString = convertedString!
            
        } catch let myJSONError {
            print(myJSONError)
        }
        return jsonString
    }
    
    
    //jsonstring to obj
    class func stringToJson(jsonString: String) -> Any? {
        
        var obj: Any?
        
        do {
            let data = jsonString.data(using: .utf8)
            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
            obj = json
        } catch let myJSONError {
            print(myJSONError)
        }
        return obj
    }
    
    ///获取当前时间戳
    class func getTimestemp() -> String {
        //获取当前时间
        let now = Date()
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
    ///时间戳转data
    class func timestempToDate(timestempStr: String) -> String {
        //时间戳
        let timeStamp = Int(timestempStr)
        
        //转换为时间
        let timeInterval:TimeInterval = TimeInterval(timeStamp!)
        let date = Date(timeIntervalSince1970: timeInterval)
        
        //格式化输出
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return "\(dformatter.string(from: date))"
    }
    
    ///创建loading
    class func createLoadingView() -> NVActivityIndicatorView {
        let window = UIApplication.shared.keyWindow!
        let width = window.bounds.size.width / 3
        let frame = CGRect(x: 0, y: 0, width: width, height: width)
        let color = UIColor(hexString: "1E90FF")
        let view = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: color, padding: 10)
        view.center = window.center
        window.addSubview(view)
        return view;
    }
}


/// 用户信息保存类
class EFUserInfo: NSObject {
    //用户名key值
    static let usernameKey = "EFUsernameKey"
    //密码key值
    static let passwordKey = "EFPasswordKey"
    //是否开启重置uuid的key值
    static let resetUUIDKey = "EFResetUUIDKey"
    //是否重置SDK的UserDefault
    static let resetUserDefultKey = "EFResetUserDefultKey"
    //指定game code的key值
    static let designatedGameCodeKey = "EFDesignatedGameCodeKey"
    //已选需要检测api的列表的key值
    static let didSelectOptionApiKey = "EFDidSelectOptionApiKey"
    //可选api列表的key值
    static let optionApiKey = "EFOptionApiKey"
    
    /// 是否已经登录
    ///
    /// - Returns: 登录结果
    class func isLogin() -> Bool {
        let userInfo = EFUserInfo.getUserInfo()
        if userInfo[EFUserInfo.passwordKey] == nil {
            return false
        }
        return true
    }
    
    /// 保存用户账密
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 密码
    class func saveUserInfo(username: String, password: String) {
        UserDefaults.standard.setValuesForKeys([usernameKey: username])
        UserDefaults.standard.setValuesForKeys([passwordKey: password])
        UserDefaults.standard.synchronize()
    }
    
    /// 保存UUID状态值
    ///
    /// - Parameter isOn: 是否开启
    class func saveResetUUIDStatus(isOn: Bool) {
        UserDefaults.standard.setValuesForKeys([resetUUIDKey: isOn])
        UserDefaults.standard.synchronize()
    }
    
    /// 保存是否重置userDefult状态
    ///
    /// - Parameter isOn: 是否开启
    class func saveResetUserDefultStatus(isOn: Bool) {
        UserDefaults.standard.setValuesForKeys([resetUserDefultKey: isOn])
        UserDefaults.standard.synchronize()
    }
    
    /// 保存指定gameCode
    ///
    /// - Parameter gameGode: 指定gameCode
    class func saveDesignatedGameCode(gameGode: String) {
        UserDefaults.standard.setValuesForKeys([designatedGameCodeKey: gameGode])
        UserDefaults.standard.synchronize()
    }
    
    /// 获取指定gameCode
    ///
    /// - Returns: 指定gameCode
    class func getDesignatedGameCode() -> String? {
        let gameCode = UserDefaults.standard.object(forKey: designatedGameCodeKey) as? String
        return gameCode
    }
    
    /// 重置指定gameCode
    class func resetDesignatedGameCode() {
        UserDefaults.standard.removeObject(forKey: designatedGameCodeKey)
    }
    
    /// 获取是否重置uuid状态
    ///
    /// - Returns: 状态
    class func getResetUUIDStatus() -> Bool {
        let isOn = UserDefaults.standard.object(forKey: resetUUIDKey) as? Bool
        if isOn == nil {
            return false
        }
        return isOn!
    }
    
    /// 获取重置SDK的userDefault状态
    ///
    /// - Returns: 状态
    class func getResetUserDefultStatus() -> Bool {
        let isOn = UserDefaults.standard.object(forKey: resetUserDefultKey) as? Bool
        if isOn == nil {
            return false
        }
        return isOn!
    }
    
    /// 登出操作，清除用户数据
    class func logout() {
        UserDefaults.standard.removeObject(forKey: passwordKey)
         UserDefaults.standard.removeObject(forKey: designatedGameCodeKey)
        UserDefaults.standard.removeObject(forKey: designatedGameCodeKey)
        UserDefaults.standard.removeObject(forKey: optionApiKey)
        UserDefaults.standard.removeObject(forKey: didSelectOptionApiKey)
        UserDefaults.standard.synchronize()
    }
    
    /// 获取用户账密
    ///
    /// - Returns: 用户账密
    class func getUserInfo()-> [String: Any] {
        let username = UserDefaults.standard.object(forKey: usernameKey)
        let password = UserDefaults.standard.object(forKey: passwordKey)
        var info = [String: Any]()
        if username != nil {
            info[usernameKey] = username
        }
        if password != nil {
            info[passwordKey] = password
        }
        return info
    }
    
    /// 获取是否必要检测API列表
    ///
    /// - Returns: 必须检测的api列表
    class func getNecessaryAPI() -> [String: String] {
        return [
            "finishLaunch": "应用启动",
            "openURL": "应用处理第三方触发打开应用的数据",
            "becomeActive": "应用激活",
            "enterBackground": "应用进入后台",
            "login": "打开Efun登录页面",
            "pay": "调用内购接口",
            "push": "调用上报推送ID的接口",
            "share": "调用分享接口",
            "loginSuccess": "loginSuccess",
            "shareResult": "shareResult"
        ]
    }
    
    /// 获取可选api列表
    ///
    /// - Returns: 可选API列表
    class func getOptionAPI() -> [String: String] {
        if let dic = UserDefaults.standard.object(forKey: optionApiKey) as? [String: String] {
            return dic
        }
        else {
            return [
                "invitation": "打开Efun邀请页面",
                "logout": "调用Efun登出",
                "memberCenter": "打开Efun账号管理中心页面",
                "setLanguage": "设置SDK语言",
                "platformLoginSuccess": "显示平台悬浮按钮",
                "showPlatformModulePage": "打开平台模块页面",
                "showPromotion": "打开广告墙",
                "showAnnounce": "打开系统公告",
                "trackEvent": "调用事件统计接口",
                "fbAuthorize": "调用第三方授权接口",
                "fbRelateEfun": "调用关联账号接口",
                "fbUserProfile": "调用获取用户资料接口",
                "fbPlayingFriend": "调用获取在玩好友接口",
                "fbInvitableFriend": "调用获取可邀请好友接口",
                "fbInvitableFriendPage": "调用分页获取可邀请好友接口",
                "fbInviteFriend": "调用发送邀请接口"
            ]
        }
    }
    
    /// 获取已选的可选检测api列表
    ///
    /// - Returns: api字典
    class func getDidSelectOptionAPI() -> [String: String] {
        if let dic = UserDefaults.standard.object(forKey: didSelectOptionApiKey) as? [String: String] {
            return dic
        }
        else {
            return [String: String]()
        }
    }
    
    /// 已选api列表与可选api列表的成员相互替换
    ///
    /// - Parameter dic: api名为值和api描述为键
    class func exchangeOptionAPI(dic: [String: String]) {
        var optionAPIs = getOptionAPI()
        var selectAPIs = getDidSelectOptionAPI()
        
        for (api, apiDescription) in dic {
            //api在已选api列表存在，可选api列表不存在，则把api添加到可选api中，同时把已选api中移除
            if optionAPIs[api] != nil && selectAPIs[api] == nil {
                optionAPIs[api] = nil
                selectAPIs[api] = apiDescription
            }
            else if optionAPIs[api] == nil && selectAPIs[api] != nil {
            //api在可选api列表存在，已选api列表不存在，则把api添加到可选api中，同时把已选api中移除
                optionAPIs[api] = apiDescription
                selectAPIs[api] = nil
            }
            else {
                print("方法：\(api)，状态改变失败")
            }
        }
        
        UserDefaults.standard.set(optionAPIs, forKey: optionApiKey)
        UserDefaults.standard.set(selectAPIs, forKey: didSelectOptionApiKey)
        UserDefaults.standard.synchronize()
    }
}

//Hex String to Data
extension String {
    
    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.
    
    func hexadecimal() -> Data? {
        var data = Data(capacity: characters.count / 2)
        
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        guard data.count > 0 else { return nil }
        return data
    }
}

//Data to Hex String
extension Data {
    
    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.
    
    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}
