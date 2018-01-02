//
//  EFGameModuleCellNode.swift - 首页各个地区cell node (collectionNode的Item， 内置tableView)
//  Eason
//
//  Created by Efun on 2017/9/28.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import DZNEmptyDataSet


/// 首页各个地区cell node (collectionNode的Item， 内置tableView)
class EFGameModuleCellNode: ASCellNode, ASTableDelegate, ASTableDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    /// 内置tableNode游戏列表
    private let tableNode = ASTableNode()
    
    /// 顶部区域选择栏的高度
    var barHeight: CGFloat?
    
    /// 指定游戏区域数据
    var dataArray = [EFGameListItemModel]()
    
    /// 代理
    var delegate: EFGameModuleCellNodeDeleage?
    
    convenience init(listData: [EFGameListItemModel]?, delegate: EFGameModuleCellNodeDeleage) {
        self.init()
        
        if let list = listData {
            dataArray += list
        }
        self.delegate = delegate
        
        barHeight = UIApplication.shared.statusBarFrame.size.height + 44
        tableNode.delegate = self
        tableNode.dataSource = self
        self.tableNode.view.tableFooterView = UIView()
        self.tableNode.view.emptyDataSetDelegate = self
        self.tableNode.view.emptyDataSetSource = self
        self.addSubnode(tableNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tableNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - EFSwitchBarNode.viewHeight - self.barHeight!)
        let spac = ASStackLayoutSpec(direction: .vertical,
                                     spacing: 0.0,
                                     justifyContent: .start,
                                     alignItems: .start,
                                     children: [tableNode])
        return spac
    }
    
    // MARK: ASTableNode data source and delegate.
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        let node = EFGameListCellNode()
        node.setupGameData(model: dataArray[indexPath.row])
        return node;
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1;
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count;
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        
        tableNode.view.deselectRow(at: indexPath, animated: true)
        
        let model = dataArray[indexPath.row]
        
        if self.delegate != nil {
            self.delegate?.didSelectGameModuleCell(model: model)
        }
    }
    
    //MARK: DZNEmptyDataSet - 空界面view
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "interface.png")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没有相关数据", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "acadaf")!
            ])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "没有相关游戏数据或加载失败", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "bdbfc1")!
            ])
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        return NSAttributedString(string: "重新加载", attributes: [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "53a0ed")!
            ])
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        if self.delegate != nil {
            self.delegate!.didClickReloadButton(indexPath: self.indexPath!)
        }
    }
}

protocol EFGameModuleCellNodeDeleage {
    func didSelectGameModuleCell(model: EFGameListItemModel) -> Void;
    func didClickReloadButton(indexPath: IndexPath)
}
