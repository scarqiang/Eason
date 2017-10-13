//
//  EFAppAnalyzationModel.swift
//  Eason
//
//  Created by Efun on 2017/10/11.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import ObjectMapper
import RealmSwift

infix operator <-

/// Object of Realm's List type, 解决与Mappable一起用list局限性问题
public func <- <T: Mappable>(left: List<T>, right: Map) {
    var array: [T]?
    
    if right.mappingType == .toJSON {
        array = Array(left)
    }
    
    array <- right
    
    if right.mappingType == .fromJSON {
        if let theArray = array {
            left.append(objectsIn: theArray)
        }
    }
}
// 解决List 为 string 问题
public class StringObject: Object {
    @objc public dynamic var value: String?
}

/// app测试结果model
class EFAppAnalyzationModel: Object, Mappable {
    
    @objc dynamic var timestemp = ""
    /// 奔溃日志
    @objc dynamic var resultCrashLog = ""
    /// iCloud信息
    @objc dynamic var resultIcloudBackup: EFResultIcloudBackupModel?
    /// api调用信息
    let resultExternalInterface = List<EFResultExternalInterfaceModel>()
    /// .plist文件信息
    @objc dynamic var resultInfoPlist: EFResultExternalInterfaceModel?
    //语言信息
    let resultStoreSupportedLanguage = List<StringObject>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        resultCrashLog <- map["resultCrashLog"]
        resultIcloudBackup <- map["resultIcloudBackup"]
        resultExternalInterface <- map["resultExternalInterface"]
        resultInfoPlist <- map["EFResultExternalInterfaceModel"]
        //解决List不能为String问题
        var resultStoreSupportedLanguage: [String]? = nil
        resultStoreSupportedLanguage <- map["resultStoreSupportedLanguage"] // Maps to local variable
        resultStoreSupportedLanguage?.forEach { item in // Then fill options to `List`
            let value = StringObject()
            value.value = item
            self.resultStoreSupportedLanguage.append(value)
        }
    }
}

///app测试结果model->resultExternalInterface, api调用信息
class EFResultExternalInterfaceModel: Object, Mappable {

    /// 调用api接口名
    @objc dynamic var api = ""
    /// api描述
    @objc dynamic var apiDescription = ""
    /// api参数
    @objc dynamic var parameters = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        api <- map["map"]
        apiDescription <- map["description"]
        parameters <- map["parameters"]
    }
}

///app测试结果model->resultIcloudBackupModel, iCoud信息
class EFResultIcloudBackupModel: Object, Mappable {
    @objc dynamic var backup = 0
    @objc dynamic var documentsSize = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        backup <- map["backup"]
        documentsSize <- map["documentsSize"]
    }
}

///app测试结果model->resultInfoPlist, plist信息
class EFResultInfoPlistModel: Object, Mappable {
    
    @objc dynamic var CFBundleURLTypes: EFCFBundleURLTypesModel?
    @objc dynamic var LSApplicationQueriesSchemes: EFCFBundleURLTypesModel?
    @objc dynamic var facebook: EFInfoPlistFacebookModel?
    @objc dynamic var kakao: EFInfoPlistKakaoModel?
    @objc dynamic var main: EFInfoPlistMainModel?
    @objc dynamic var twitter: EFInfoPlistTitterModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        CFBundleURLTypes <- map["CFBundleURLTypes"]
        CFBundleURLTypes <- map["LSApplicationQueriesSchemes"]
        CFBundleURLTypes <- map["facebook"]
        CFBundleURLTypes <- map["kakao"]
        CFBundleURLTypes <- map["main"]
        CFBundleURLTypes <- map["twitter"]
    }
}

/// app测试结果model->resultInfoPlist->CFBundleURLTypes, url type信息
class EFCFBundleURLTypesModel: Object, Mappable {
    
    @objc dynamic var facebook: EFAnalyzationResultItemModel?
    @objc dynamic var gameCode: EFAnalyzationResultItemModel?
    @objc dynamic var google: EFAnalyzationResultItemModel?
    @objc dynamic var vk: EFAnalyzationResultItemModel?
    @objc dynamic var kakao: EFAnalyzationResultItemModel?
    @objc dynamic var kakaogame: EFAnalyzationResultItemModel?
    @objc dynamic var weixin: EFAnalyzationResultItemModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        facebook <- map["facebook"]
        gameCode <- map["gameCode"]
        google <- map["google"]
        vk <- map["vk"]
        kakao <- map["kakao"]
        kakaogame <- map["kakaogame"]
        weixin <- map["weixin"]
    }
}

/// app测试结果model->resultInfoPlist->LSApplicationQueriesSchemes, scheme信息
class EFLSApplicationQueriesSchemesModel: Object, Mappable {
    //vk
    @objc dynamic var vk: EFAnalyzationResultItemModel?
    @objc dynamic var vk_share: EFAnalyzationResultItemModel?
    @objc dynamic var vkauthorize: EFAnalyzationResultItemModel?
    
    //weixn
    @objc dynamic var weixin: EFAnalyzationResultItemModel?
    
    //other
    @objc dynamic var twapios: EFAnalyzationResultItemModel?
    @objc dynamic var line: EFAnalyzationResultItemModel?
    @objc dynamic var whatsapp: EFAnalyzationResultItemModel?
    @objc dynamic var twitter: EFAnalyzationResultItemModel?
    @objc dynamic var instagram: EFAnalyzationResultItemModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        
        vk <- map["vk"]
        vk_share <- map["vk-share"]
        vkauthorize <- map["vkauthorize"]
        
        weixin <- map["weixin"]
        
        twapios <- map["twapios"]
        line <- map["line"]
        whatsapp <- map["whatsapp"]
        twitter <- map["twitter"]
        instagram <- map["instagram"]
    }
}

/// app测试结果model->resultInfoPlist->facebook
class EFInfoPlistFacebookModel: Object, Mappable {
    @objc dynamic var FacebookAppID: EFAnalyzationResultItemModel?
    @objc dynamic var FacebookDisplayName: EFAnalyzationResultItemModel?
    @objc dynamic var LSApplicationQueriesSchemes: EFInfoPlistFacebookSchemesModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        FacebookAppID <- map["FacebookAppID"]
        FacebookDisplayName <- map["FacebookDisplayName"]
        LSApplicationQueriesSchemes <- map["LSApplicationQueriesSchemes"]
    }
}

/// app测试结果model->resultInfoPlist->facebook->LSApplicationQueriesSchemes
class EFInfoPlistFacebookSchemesModel: Object, Mappable {
    @objc dynamic var fbapi: EFAnalyzationResultItemModel?
    @objc dynamic var fbauth2: EFAnalyzationResultItemModel?
    @objc dynamic var fb_messenger_api: EFAnalyzationResultItemModel?
    @objc dynamic var fbshareextension: EFAnalyzationResultItemModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        fbapi <- map["fbapi"]
        fbauth2 <- map["fbauth2"]
        fb_messenger_api <- map["fb-messenger-api"]
        fbshareextension <- map["fbshareextension"]
    }
}

/// app测试结果model->resultInfoPlist->kakao
class EFInfoPlistKakaoModel: Object, Mappable {
    @objc dynamic var AppId: EFAnalyzationResultItemModel?
    @objc dynamic var AppSecret: EFAnalyzationResultItemModel?
    @objc dynamic var AppVersion: EFAnalyzationResultItemModel?
    @objc dynamic var DebugLevel: EFAnalyzationResultItemModel?
    @objc dynamic var KAKAO_APP_KEY: EFAnalyzationResultItemModel?
    @objc dynamic var LSApplicationQueriesSchemes: EFInfoPlistKakaoSchemeModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        AppId <- map["AppId"]
        AppSecret <- map["AppSecret"]
        AppVersion <- map["AppVersion"]
        DebugLevel <- map["DebugLevel"]
        KAKAO_APP_KEY <- map["KAKAO_APP_KEY"]
        LSApplicationQueriesSchemes <- map["LSApplicationQueriesSchemes"]
    }
}

/// app测试结果model->resultInfoPlist->kakao->LSApplicationQueriesSchemes
class EFInfoPlistKakaoSchemeModel: Object, Mappable {
    @objc dynamic var KAKAO_APP_KEY: EFAnalyzationResultItemModel?
    @objc dynamic var kakaokompassauth: EFAnalyzationResultItemModel?
    @objc dynamic var storykompassauth: EFAnalyzationResultItemModel?
    @objc dynamic var kakaolink: EFAnalyzationResultItemModel?
    @objc dynamic var kakaotalk: EFAnalyzationResultItemModel?
    @objc dynamic var kakaostory: EFAnalyzationResultItemModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        KAKAO_APP_KEY <- map["KAKAO_APP_KEY"]
        kakaokompassauth <- map["kakaokompassauth"]
        storykompassauth <- map["storykompassauth"]
        kakaolink <- map["kakaolink"]
        kakaotalk <- map["kakaotalk"]
        kakaostory <- map["kakaostory"]
    }
}

/// app测试结果model->resultInfoPlist->twitter
class EFInfoPlistTitterModel: Object, Mappable {
    @objc dynamic var APIKey: EFAnalyzationResultItemModel?
    @objc dynamic var KitName: EFAnalyzationResultItemModel?
    @objc dynamic var LSApplicationQueriesSchemes: EFInfoPlistTitterSchemeModel?
    @objc dynamic var consumerKey: EFAnalyzationResultItemModel?
    @objc dynamic var consumerSecret: EFAnalyzationResultItemModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        APIKey <- map["APIKey"]
        KitName <- map["KitName"]
        LSApplicationQueriesSchemes <- map["LSApplicationQueriesSchemes"]
        consumerKey <- map["consumerKey"]
        consumerSecret <- map["consumerSecret"]
    }
}

/// app测试结果model->resultInfoPlist->twitter->EFInfoPlistTitterSchemeModel
class EFInfoPlistTitterSchemeModel: Object, Mappable {
    @objc dynamic var twitter: EFAnalyzationResultItemModel?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        twitter <- map["twitter"]
    }
}

/// app测试结果model->resultInfoPlist->main
class EFInfoPlistMainModel: Object, Mappable {
    @objc dynamic var CFBundleDevelopmentRegion = ""
    @objc dynamic var CFBundleIdentifier = ""
    @objc dynamic var CFBundleShortVersionString = ""
    @objc dynamic var CFBundleVersion = ""
    @objc dynamic var DTXcode = ""
    @objc dynamic var MinimumOSVersion = ""
    @objc dynamic var NSAllowsArbitraryLoads = ""
    @objc dynamic var NSCameraUsageDescription = ""
    @objc dynamic var NSMicrophoneUsageDescription = ""
    @objc dynamic var NSPhotoLibraryUsageDescription = ""
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        CFBundleDevelopmentRegion <- map["CFBundleDevelopmentRegion"]
        CFBundleIdentifier <- map["CFBundleIdentifier"]
        CFBundleShortVersionString <- map["CFBundleShortVersionString"]
        CFBundleVersion <- map["CFBundleVersion"]
        DTXcode <- map["DTXcode"]
        MinimumOSVersion <- map["MinimumOSVersion"]
        NSAllowsArbitraryLoads <- map["NSAllowsArbitraryLoads"]
        NSCameraUsageDescription <- map["NSCameraUsageDescription"]
        NSMicrophoneUsageDescription <- map["NSMicrophoneUsageDescription"]
        NSPhotoLibraryUsageDescription <- map["NSPhotoLibraryUsageDescription"]
    }
}

/// item && pass
class EFAnalyzationResultItemModel: Object, Mappable {
    @objc dynamic var item = ""
    @objc dynamic var pass = 0
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        item <- map["item"]
        pass <- map["pass"]
    }
}
