//
//  EFPlistFileViewController.swift
//  Eason
//
//  Created by Efun on 2017/10/18.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFPlistFileViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {

    enum EFPlistDataType: String {
        case CFBundleURLTypes
        case LSApplicationQueriesSchemes
        case facebook
        case kakao
        case twitter
        case main
        
       static let allValues = [CFBundleURLTypes,
                                 LSApplicationQueriesSchemes,
                                 facebook,
                                 kakao,
                                 twitter,
                                 main]
    }
    
    var tableNode: ASTableNode?
    let titles = EFPlistDataType.allValues
    var model: EFResultInfoPlistModel?
    
    convenience init(model: EFResultInfoPlistModel) {
        let tableNode = ASTableNode(style: .plain)
        self.init(node: tableNode)
        self.model = model
        self.tableNode = tableNode
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        self.tableNode?.view.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Plist文件信息"
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
        let text = self.titles[indexPath.row]
        cell.text = text.rawValue
        return cell
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        let type = self.titles[indexPath.row]
        didSelectCellNodeAction(type: type)
    }
    
    func didSelectCellNodeAction(type: EFPlistDataType) {
        var itemsJson: [String: Any]?
        var schemesJson: [String: Any]?
        switch type {
        case .CFBundleURLTypes:
            itemsJson = self.model?.CFBundleURLTypes?.toJSON()
        case .LSApplicationQueriesSchemes:
            itemsJson = self.model?.LSApplicationQueriesSchemes?.toJSON()
        case .facebook:
            itemsJson = self.model?.facebook?.toJSON()
            schemesJson = self.model?.facebook?.LSApplicationQueriesSchemes?.toJSON()
        case .kakao:
            itemsJson = self.model?.kakao?.toJSON()
            schemesJson = self.model?.kakao?.LSApplicationQueriesSchemes?.toJSON()
        case .twitter:
            itemsJson = self.model?.twitter?.toJSON()
            schemesJson = self.model?.twitter?.LSApplicationQueriesSchemes?.toJSON()
        case .main:
            if self.model?.main != nil {
                let vc = EFPlistMainInfoViewController(model: self.model!.main!)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return
        }
        
        var items = [[String: Any]]()
        var schemes = [[String: Any]]()
        
        if itemsJson?.keys != nil {
            for (key, value) in itemsJson! {
                if key != "LSApplicationQueriesSchemes" {
                    let value = value as Any
                    let dic: [String: Any] = [key: value]
                    items.append(dic)
                }
            }
        }
        
        if schemesJson?.keys != nil {
            for (key, value) in schemesJson! {
                let value = value as Any
                let dic: [String: Any] = [key: value]
                schemes.append(dic)
            }
        }
        
        let vc = EFPlistFileItemViewController(items: items, schemes: schemes)
        vc.title = type.rawValue
        self.navigationController?.pushViewController(vc, animated: true)
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
