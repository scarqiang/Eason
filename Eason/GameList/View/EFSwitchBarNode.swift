//
//  EFSwitchBarNode.swift - 首页顶部切换游戏地区的bar
//  Eason
//
//  Created by Efun on 2017/9/29.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit


/// 顶部bar代理
protocol EFSwitchBarNodeDelegate {
    
    /// 点击顶部bar后的代理方法
    ///
    /// - Parameters:
    ///   - barNode: EFSwitchBarNode
    ///   - indexPath: bar的collectionNode的indexPath
    func barNodeDidTapItem(_ barNode: EFSwitchBarNode,_ indexPath: IndexPath)
}

/// 首页顶部切换游戏地区的bar
class EFSwitchBarNode: ASDisplayNode, ASCollectionDelegate, ASCollectionDataSource, EFSwitchBarItemDelegate {
    
    /// bar内置collocationNode
    var collectionNode: ASCollectionNode?
    
    /// 标题数组
    var titles = [String]()
    
    /// bar的高度
    static let viewHeight: CGFloat = 50.0
    
    /// 每个item的宽度
    private let itemWidth: CGFloat = 120
    
    /// 上传选择的item
    private var lastIndexPath: IndexPath?
    var delegate: EFSwitchBarNodeDelegate?
    
    convenience init(titles:[String]) {
        self.init()
        self.titles = titles
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSize(width: itemWidth, height: EFSwitchBarNode.viewHeight)
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        collectionNode?.delegate = self
        collectionNode?.dataSource = self
        collectionNode?.view.showsHorizontalScrollIndicator = false
        self.addSubnode(collectionNode!)
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        collectionNode?.style.preferredSize = CGSize(width: UIScreen.main.bounds.size.width, height: EFSwitchBarNode.viewHeight)
        return ASStackLayoutSpec(direction: .horizontal, spacing: 0.0, justifyContent: .start, alignItems: .start, children: [collectionNode!])
    }
    
    //MARK: collectionNode data source and delegate.
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let cell = EFSwitchBarItemNode(titles[indexPath.row], self)
        return cell
    }
    
    //MARK: EFSwitchBarItemDelegate
    func switchBarItemNode(_ itemNode: EFSwitchBarItemNode, didTapAction indexPath: IndexPath) {
        
        if lastIndexPath != nil {
            let item = collectionNode?.nodeForItem(at: lastIndexPath!)
            item?.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
        }
        lastIndexPath = indexPath
        collectionNode?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if delegate != nil {
            delegate!.barNodeDidTapItem(self, indexPath)
        }
    }
    
    func scrollToItem(indexPath: IndexPath) {
        collectionNode?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        if delegate != nil {
            let cell = collectionNode?.nodeForItem(at: indexPath) as! EFSwitchBarItemNode
            cell.didTapItemAction(nil)
//            delegate!.barNodeDidTapItem(self, indexPath)
        }
    }
}


/// 切换区域bar的item代理
protocol EFSwitchBarItemDelegate {
    
    /// 点击item代理事件
    ///
    /// - Parameters:
    ///   - itemNode: 成员item EFSwitchBarItemNode
    ///   - indexPath: item所在位置
    func switchBarItemNode(_ itemNode: EFSwitchBarItemNode, didTapAction indexPath: IndexPath)
}


/// bar中collection node的item
class EFSwitchBarItemNode: ASCellNode {
    let titleTextNode = ASTextNode()
    var title: String?
    private var isTaped = false
    private let fontSize = 18
    var delegate: EFSwitchBarItemDelegate?
    
    init(_ text: String, _ delegate: EFSwitchBarItemDelegate?) {
        super.init()
        self.title = text
        self.delegate = delegate
        titleTextNode.attributedText = NSAttributedString(
            string: text,
            attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        self.addSubnode(titleTextNode)
    }
    
    /// 点击事件需要在didLoad中添加
    override func didLoad() {
        super.didLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapItemAction(_:)))
        titleTextNode.view.addGestureRecognizer(tap)
        titleTextNode.view.isUserInteractionEnabled = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .spaceAround, alignItems: .center, children: [titleTextNode])
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        var fontTransform = CGAffineTransform(scaleX: 1.45, y: 1.45)

        var attributedString = NSAttributedString(
            string: self.title!,
            attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
                NSAttributedStringKey.foregroundColor: UIColor.red
            ])
        
        if isTaped {
            fontTransform = CGAffineTransform(scaleX: 1, y: 1);
            attributedString = NSAttributedString(
                string: self.title!,
                attributes: [
                    NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: CGFloat(fontSize)),
                    NSAttributedStringKey.foregroundColor: UIColor.black
                ])
            isTaped = false
        }
        
        titleTextNode.attributedText = attributedString
        
        UIView.animate(withDuration: 0.35) {
            self.titleTextNode.view.transform = fontTransform
        }
    }
    
    @objc func didTapItemAction(_ tap: UITapGestureRecognizer?) {
        self.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
        if delegate != nil {
            delegate!.switchBarItemNode(self, didTapAction: self.indexPath!)
        }
        isTaped = true
        
    }
}
