//
//  EFSearchGameViewController.swift
//  Eason
//
//  Created by Efun on 2017/10/20.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class EFSearchGameViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, EFSearchBarNodeDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {

    var searchBarNode: EFSearchBarNode?
    var tableNode: ASTableNode?
    var resultsArr = [EFGameListItemModel]()
    
    init() {
        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        self.node.backgroundColor = UIColor.white
        self.tableNode = tableNode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableNode?.delegate = self
        self.tableNode?.dataSource = self
        self.tableNode?.view.tableFooterView = UIView()
        
        self.setupSearchBar()
        self.setupBackButton()
        // Do any additional setup after loading the view.
    }

    func setupSearchBar() {
        self.navigationItem.hidesBackButton = true
        let searchNode = EFSearchBarNode(delegate: self)
        self.searchBarNode = searchNode
        let width = UIScreen.main.bounds.width * 0.66
        let y: CGFloat = (44 - 35)/2
        let x: CGFloat = (UIScreen.main.bounds.width - width) / 2
        searchNode.frame = CGRect(x: x, y: y, width: width, height: 35)
        self.navigationController?.navigationBar.addSubnode(searchNode)
    }
    
    func setupBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: backButton)
        let specItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        specItem.width = 10
        self.navigationItem.leftBarButtonItems = [backItem, specItem]
    }
    
    @objc func goBack() {
        searchBarNode?.removeFromSupernode()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.searchBarNode?.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBarNode?.alpha = 1
    }
    
    var isShow = false
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isShow == false {
            _ = self.searchBarNode?.becomeFirstResponder()
            isShow = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //search bar delegate
    func didClickSearchButton(bar: EFSearchBarNode, keyword: String) {
        self.resultsArr.removeAll()
        EFExamineTool.loadingView.startAnimating()
        EFNetworking.shared.fetchSearchResult(keyword: keyword) { (results, error) in
            EFExamineTool.loadingView.stopAnimating()
            if error != nil {
                self.tableNode?.view.emptyDataSetDelegate = self
                self.tableNode?.view.emptyDataSetSource = self
                self.tableNode?.reloadData()
                return
            }
            
            if (results?.count != 0) {
                self.resultsArr += results!
                self.tableNode?.reloadData()
            }
            else {
                self.tableNode?.view.emptyDataSetDelegate = self
                self.tableNode?.view.emptyDataSetSource = self
                self.tableNode?.reloadData()
                return
            }
        }
    }
    
    //MARK: table node delegate and data source
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return resultsArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let node = EFGameListCellNode()
        node.setupGameData(model: resultsArr[indexPath.row])
        return node
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        _ = self.searchBarNode?.resignFirstResponder()
        tableNode.deselectRow(at: indexPath, animated: true)
        
        let model = resultsArr[indexPath.row]
        let vc = EFAnalyzationDataListViewController(gameCode: model.game_code_info!.game_code,
                                                     gameName: model.game_code_info!.game_name)
        self.navigationController?.pushViewController(vc, animated: true)
        EFExamineTool.saveRecentGamesData(model: model)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    //MARK: DZNEmptyDataSet
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "worried")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没有相关内容", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "acadaf")!
            ])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没有搜寻到相关的游戏", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "bdbfc1")!
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
