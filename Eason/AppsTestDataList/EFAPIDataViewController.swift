//
//  EFAPIDataViewController.swift
//  Eason
//
//  Created by Efun on 2017/10/19.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EFAPIDataViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var tableNode: ASTableNode?
    var modelArr = [EFResultExternalInterfaceModel]()
    
    convenience init(models: [EFResultExternalInterfaceModel]) {
        let tableNode = ASTableNode(style: .plain)
        self.init(node: tableNode)
        self.tableNode = tableNode
        self.tableNode?.view.separatorColor = UIColor(hexString: "a80f42")
        if models.count != 0 {
            self.modelArr = models
        }
        self.tableNode?.view.emptyDataSetSource = self
        self.tableNode?.view.emptyDataSetDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "API调用信息"
        setupRightBarItem()
        self.tableNode?.view.tableFooterView = UIView()
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        // Do any additional setup after loading the view.
    }

    func setupRightBarItem() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "list"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(self.pushCheckApiViewController), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: button)
        let specItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        specItem.width = -10
        self.navigationItem.rightBarButtonItems = [searchItem, specItem]
    }
    
    @objc func pushCheckApiViewController()  {
        let vc = EFNecessaryAPIViewController(models: self.modelArr)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: table node delegate and datasource
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return modelArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        //ascellnode don't need reuse
        let model = modelArr[indexPath.row]
        let cell = EFAPIDataCellNode(model: model)
        cell.selectionStyle = .none
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
