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

class EFExamineTool: NSObject {
    static let queue = DispatchQueue(label: "com.savedata.queue")
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
        let scheme = "\(gameCode)://test_mode/"
        let fileName = getTimestemp()
        
        let parameter = ["file_name": fileName,
                         "uuid_reset": uuidReset ? "1" : "0",
                         "user_default_reset": userDefaultReset ? "1" : "0"]
        
        let path = jsonToString(json: parameter)
        let data = path.data(using: .utf8)
        
        let dataString = data?.hexadecimal()
        
        let urlStr = "\(scheme)\(dataString!)"
        let url = URL.init(string: urlStr)
        
        let isOpen = UIApplication.shared.canOpenURL(url!)
        if isOpen {
            UIApplication.shared.openURL(url!)
        }
    }
    
    //网络调试模式
    class func taggerNetworkMode(gameCode: String) {
        let scheme = "\(gameCode)://networking_mode/"
        
        let url = URL.init(string: scheme)
        
        let isOpen = UIApplication.shared.canOpenURL(url!)
        if isOpen {
            UIApplication.shared.openURL(url!)
        }
    }
    
    //日志模式
    class func taggerLogMode(uuidReset: Bool, userDefaultReset: Bool, gameCode: String) {
        let scheme = "\(gameCode)://log_mode/"
        let fileName = getTimestemp()
        
        let parameter = ["file_name": fileName]
        
        let path = jsonToString(json: parameter)
        let data = path.data(using: .utf8)
        
        let dataString = data?.hexadecimal()
        
        let urlStr = "\(scheme)\(dataString!)"
        let url = URL.init(string: urlStr)
        
        let isOpen = UIApplication.shared.canOpenURL(url!)
        if isOpen {
            UIApplication.shared.openURL(url!)
        }
    }
    
    //保存分析数据
    class func saveAnalyzetionData(url: URL, complete:@escaping () -> Void) {
        if url.scheme! != "efunExaminer" {
            return
        }
        
        var path = url.path
        path = path.replacingOccurrences(of: "\\", with: "")
        let data:Data = (String.hexadecimal(path)())!
        let jsonStr = String(data: data, encoding: .utf8) as String!
        
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
                    complete()
                }
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
    
    class func getTimestemp() -> String {
        //获取当前时间
        let now = Date()
        
        //当前时间的时间戳
        let timeInterval:TimeInterval = now.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
    
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
