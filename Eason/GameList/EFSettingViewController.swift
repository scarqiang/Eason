//
//  EFSettingViewController.swift - 设置界面
//  Eason
//
//  Created by Efun on 2017/10/24.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import AdSupport

class EFSettingViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, EFSettingCellNodeDelegate {

    let titles = ["测试模式重置UUID", "测试模式重置用户信息", "使用指定game code测试", "共享信息地址"]
    var tableNode: ASTableNode?
    let httpServer: HTTPServer = HTTPServer()
    
    init() {
        let tableNode = ASTableNode(style: .grouped)
        super.init(node: tableNode)
        self.tableNode = tableNode
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        self.tableNode?.view.tableFooterView = UIView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        setupMobileHttpServer()
        // Do any additional setup after loading the view.
    }

    override func viewDidDisappear(_ animated: Bool) {
        httpServer.stop()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if httpServer.isRunning() {
            return
        }
        do  {
            try httpServer.start()
        } catch {
            print("启动失败")
        }
        print("start server success in port \(httpServer.listeningPort()) \(httpServer.publishedName())")
    }
    
    //MARK: table node delegate and data source
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.titles.count
        }
        
        if section == 1 {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        if indexPath.section == 0 {
            let title = titles[indexPath.row]
            
            if indexPath.row == 3 {
                let cell = ASTextCellNode()
                cell.backgroundColor = UIColor.white
                cell.selectionStyle = .none
                if let IPAddress = getLocalIPAddressForCurrentWiFi() {
                    cell.textNode.attributedText = NSAttributedString(string: "共享信息地址: \(IPAddress):8888/index.html", attributes: [
                        NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
                        NSAttributedStringKey.foregroundColor: UIColor.black
                        ])
                }//ASIdentifierManager.shared().advertisingIdentifier.uuidString
                return cell;
            }
            
            var cell = EFSettingCellNode(title: title, delegate: self)
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.switchView.isOn = EFUserInfo.getResetUUIDStatus()
            }
            else if indexPath.row == 1 {
                cell.switchView.isOn = EFUserInfo.getResetUserDefultStatus()
            }
            else {
                if let gameCode = EFUserInfo.getDesignatedGameCode() {
                    let tips = "正使用gameCode为\(gameCode)测试"
                    cell = EFSettingCellNode(title: tips, delegate: self)
                }

                cell.switchView.isOn = EFUserInfo.getDesignatedGameCode() != nil
            }
            
            return cell
        }
        else {
            let cell = ASTextCellNode()
            cell.textNode.style.alignSelf = .center
            cell.backgroundColor = UIColor.white
            cell.textNode.attributedText = NSAttributedString(string: "注销", attributes: [
                NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor: UIColor.red
            ])
            return cell
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            EFUserInfo.logout()
            let loginVC = EFLoginViewController()
            UIApplication.shared.keyWindow?.rootViewController?.present(loginVC, animated: true, completion: {
                self.navigationController?.popViewController(animated: false)
            })
        }
    }
    
    //MARK: Tagget Action
    func didClickSwitchButton(isOn: Bool, indexPath: IndexPath) {
        if indexPath.row == 0 {
            EFUserInfo.saveResetUUIDStatus(isOn: isOn)
        }
        else if (indexPath.row == 1) {
            EFUserInfo.saveResetUserDefultStatus(isOn: isOn)
        }
        else {
            
            if isOn == false {
                EFUserInfo.resetDesignatedGameCode()
                self.tableNode?.reloadRows(at: [indexPath], with: .none)
                return
            }
            
            let alert = UIAlertController(title: "请输入指定game code", message: nil, preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "指定game code不能为空"
            })
            
            let cancel = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                self.tableNode?.reloadRows(at: [indexPath], with: .none)
            })
            alert.addAction(cancel)
            
            let submit = UIAlertAction(title: "提交", style: .default, handler: { (action) in
                if (alert.textFields!.count > 0) {
                    let textField = alert.textFields?.first
                    if textField!.text?.count != nil && textField!.text!.count > 0 {
                        EFUserInfo.saveDesignatedGameCode(gameGode: textField!.text!)
                    }
                    else {
                        let tipAlert = UIAlertController(title: "game code不能为空", message: nil, preferredStyle: .alert)
                        let cancel = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        tipAlert.addAction(cancel)
                        self.present(tipAlert, animated: true, completion: nil)
                    }
                }
                self.tableNode?.reloadRows(at: [indexPath], with: .none)
            })
            alert.addAction(submit)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getLocalIPAddressForCurrentWiFi() -> String? {
        var address: String?
        
        // get list of all interfaces on the local machine
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            
            // Check for IPV4 or IPV6 interface
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                // Check interface name
                let name = String(cString: interface.ifa_name)
                if name == "en0" {
                    // Convert interface address to a human readable string
                    var addr = interface.ifa_addr.pointee
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(&addr,
                                socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    
    func setupMobileHttpServer() {
        //注意：CocoaHTTPServer的版本太旧，里依赖的GCDAsyncSocket不能支持arc，故update后，需要替换上最新的GCDAsyncSocket
        httpServer.setType("_http._tcp.")
        httpServer.setPort(8888)
        httpServer.setName("EfunExaminerHttpServer")
        let IDFA = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let document = "<!DOCTYPE html><html><head><meta charset=\"UTF-8\"><title>复制你要的信息吧骚年</title></head><body><p>IDFA：\(IDFA)</p></body></html>"
        let documentPath = NSHomeDirectory().appending("/Documents/Web/")
        do {
            try FileManager.`default`.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print("create directory fail")
        }
        do {
            try document.write(toFile: documentPath.appending("index.html"), atomically: true, encoding: String.Encoding.utf8)
        }
        catch {
            print("write server html file fail")
        }
        
        httpServer.setDocumentRoot(documentPath)
        print(httpServer.documentRoot())
        print(NSTemporaryDirectory())
    }
}
