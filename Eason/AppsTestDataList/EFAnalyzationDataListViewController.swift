//
//  EFAnalyzationDataListViewController.swift
//  Eason
//
//  Created by Efun on 2017/10/16.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet
import LiquidFloatingActionButton

class EFAnalyzationDataListViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, LiquidFloatingActionButtonDataSource, LiquidFloatingActionButtonDelegate  {

    let tableNode = ASTableNode(style: .plain)
    var gameCode: String?
    var dataArr = [EFAppAnalyzationModel]()
    var gameName: String?
    var floatCells: [LiquidFloatingCell] = []
    
    convenience init(gameCode: String, gameName: String) {
        self.init(node: ASDisplayNode())
        self.gameCode = gameCode
        self.title = "数据记录"
        self.gameName = gameName
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.node.backgroundColor = UIColor.white
        self.tableNode.frame = self.node.bounds
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.view.emptyDataSetDelegate = self
        self.tableNode.view.emptyDataSetSource = self
        self.node.addSubnode(self.tableNode)
        self.tableNode.view.tableFooterView = UIView()
        self.fetchAnalyzationData()
        self.setupFloatButton()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchAnalyzationData), name: EFExamineTool.kEFReloadDataNotifictaion, object: nil)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func fetchAnalyzationData() {
        EFExamineTool.loadingView.startAnimating()
        EFExamineTool.readAnalyzationData(gameCode: self.gameCode!) { (dataArray) in
            EFExamineTool.loadingView.stopAnimating()
            
            if dataArray?.count != 0 {
                
                self.dataArr = dataArray!
                self.tableNode.reloadData()
            }
        }
    }
    
    func setupFloatButton() {
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton = { (frame, style) in
//            let floatingActionButton = CustomDrawingActionButton(frame: frame)
            let floatingActionButton = LiquidFloatingActionButton(frame: frame)
            floatingActionButton.animateStyle = style
            floatingActionButton.dataSource = self
            floatingActionButton.delegate = self
            return floatingActionButton
        }
        
        let cellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
            return cell
        }
        
        let customCellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = LiquidFloatingCell(icon: UIImage(named: iconName)!)
            return cell
        }
        floatCells.append(cellFactory("test_icon"))
        floatCells.append(customCellFactory("network_icon"))
        
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let bottomRightButton = createButton(floatingFrame, .up)
        
//        let image = UIImage(named: "tool_icon")
//        bottomRightButton.image = image
        
        self.view.addSubview(bottomRightButton)
    }
    
    //MARK: table node delegate and data source
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.dataArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = ASTextCellNode()
        let model = self.dataArr[indexPath.row]
        let timestemp = model.timestemp
        cell.text = EFExamineTool.timestempToDate(timestempStr: timestemp)
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        let model = self.dataArr[indexPath.row]
        let vc = EFTestTypeViewController(model: model, gameName: self.gameName!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = self.dataArr[indexPath.row]
            self.dataArr.remove(at: indexPath.row)
            let realm = try! Realm()
            try! realm.write {
                realm.delete(model)
            }
            tableView.beginUpdates()
            tableView.deleteRow(at: indexPath, with: .fade)
            tableView.endUpdates()
        }
    }
    
    //MARK: DZNEmptyDataSet
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "shit.png")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没有相关内容", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "acadaf")!
            ])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没有“\(self.gameName!)”相关数据记录", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "bdbfc1")!
            ])
    }
    
    //LiquidFloatingActionButton delegate
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return floatCells.count
    }
    
    func cellForIndex(_ index: Int) -> LiquidFloatingCell {
        return floatCells[index]
    }
    
    func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int) {
        
        if index == 0 {
            let uuidReset = EFUserInfo.getResetUUIDStatus()
            let userDefultReset = EFUserInfo.getResetUserDefultStatus()
            
            EFExamineTool.taggerTestMode(uuidReset: uuidReset, userDefaultReset: userDefultReset, gameCode: self.gameCode!)
        }
        else {
            EFExamineTool.taggerNetworkMode(gameCode: self.gameCode!)
        }
        liquidFloatingActionButton.close()
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



