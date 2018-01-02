//
//  EFTestTypeViewController.swift - 选择查看检测内容选项界面
//  Eason
//
//  Created by Efun on 2017/10/16.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

enum EFTestDataType: Int {
    case log
    case iCloud
    case api
    case plist
    case language
}

class EFTestTypeViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {

    var tableNode: ASTableNode?
    var gameCode: String?
    var model: EFAppAnalyzationModel?
    var gameName: String?
    let titles = ["崩溃日志", "iCould信息", "调用API信息", "Plist文件信息", "游戏语言"]
    
    convenience init(model: EFAppAnalyzationModel, gameName: String) {
        let tableNode = ASTableNode(style: .plain)
        self.init(node: tableNode)
        self.model = model
        self.gameName = gameName
        self.tableNode = tableNode
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        self.tableNode?.view.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "选择查看内容"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: table node delegate and data source
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASTextCellNode()
        let title = self.titles[indexPath.row]
        cell.text = title
        return cell
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        let type = EFTestDataType(rawValue: indexPath.row)
        
        switch type! {
        case .log:
            let vc = EFTestLogViewController.init(testLog: model!.resultCrashLog)
            vc.title = "崩溃日志"
            self.navigationController?.pushViewController(vc, animated: true)
        case .iCloud:
            let vc = EFTestLogViewController.init(testLog:"\( model!.resultIcloudBackup!)")
            vc.title = "iCloud数据"
            self.navigationController?.pushViewController(vc, animated: true)
        case .api:
            let arr = Array(model!.resultExternalInterface)
            let vc = EFAPIDataViewController(models: arr)
            self.navigationController?.pushViewController(vc, animated: true)
        case .plist:
            if model!.resultInfoPlist == nil {
                return
            }
            let vc = EFPlistFileViewController(model: model!.resultInfoPlist!)
            self.navigationController?.pushViewController(vc, animated: true)
        case .language:
            let arr = Array(model!.resultStoreSupportedLanguage)
            let vc = EFLanguageViewController(models: arr)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
