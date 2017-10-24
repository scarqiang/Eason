//
//  EFPlistFileItemViewController.swift
//  Eason
//
//  Created by Efun on 2017/10/18.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EFPlistFileItemViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var tableNode: ASTableNode?
    var model: EFResultInfoPlistModel?
    var items: [[String: Any]]?
    var schemes: [[String: Any]]?
    
    convenience init(items:[[String: Any]], schemes:[[String: Any]]?) {
        let tableNode = ASTableNode(style: .grouped)
        self.init(node: tableNode)
        self.items = items
        self.schemes = schemes
        self.tableNode = tableNode
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        self.tableNode?.view.tableFooterView = UIView()
        self.tableNode?.view.emptyDataSetSource = self
        self.tableNode?.view.emptyDataSetDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: table node delegate and data source
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        if self.schemes == nil || self.schemes?.count == 0 {
            return 1
        }
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.items!.count
        }
        
        if section == 1 {
            return self.schemes!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            if self.items?.count == 0 {
                return nil
            }
            return "Custom"
        }
        else {
            return "LSApplicationQueriesSchemes"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        if indexPath.section == 0 {
            let dic = items![indexPath.row]
            let cell = EFPlistItemCellNode(model: dic.values.first as! [String : Any], title: dic.keys.first!)
            cell.selectionStyle = .none
            return cell
        }
        else {
            let dic = schemes![indexPath.row]
            let cell = EFPlistItemCellNode(model: dic.values.first as! [String : Any], title: dic.keys.first!)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    //MARK: DZNEmptyDataSet
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "shit.png")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没有相关数据", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "acadaf")!
            ])
    }
    
    
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
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
