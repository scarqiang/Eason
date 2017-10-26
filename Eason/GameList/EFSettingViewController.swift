//
//  EFSettingViewController.swift
//  Eason
//
//  Created by Efun on 2017/10/24.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFSettingViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, EFSettingCellNodeDelegate {

    let titles = ["测试模式重置UUID", "测试模式重置用户信息", "使用指定game code测试"]
    var tableNode: ASTableNode?
    
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
        // Do any additional setup after loading the view.
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

}
