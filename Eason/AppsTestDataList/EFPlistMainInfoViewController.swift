//
//  EFPlistMainInfoViewController.swift
//  Eason
//
//  Created by Efun on 2017/10/18.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EFPlistMainInfoViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var tableNode: ASTableNode?
    var model: EFInfoPlistMainModel?
    var keys = [String]()
    var values = [Any]()
    
    convenience init(model: EFInfoPlistMainModel) {
        let tableNode = ASTableNode(style: .plain)
        self.init(node: tableNode)
        self.model = model
        
        let dic = model.toJSON()
        
        if dic.keys.count != 0 {
            for (key, value) in dic {
                self.keys.append(key)
                self.values.append(value)
            }
        }
        
        self.tableNode = tableNode
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        self.tableNode?.view.tableFooterView = UIView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "PlistMain"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: table node delegate and data source
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let key = self.keys[indexPath.row]
        let value = self.values[indexPath.row]
        let cell = EFPlistMainCellNode(key: "\(key)", value: "\(value)")
        cell.selectionStyle = .none
        return cell
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
