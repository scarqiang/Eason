//
//  EFGameListViewController.swift
//  Eason
//
//  Created by Efun on 2017/9/25.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import Alamofire

final class EFGameListViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, ASCollectionDelegate, ASCollectionDataSource, EFSwitchBarNodeDelegate {

    let tableNode = ASTableNode()
    let rootNode = ASDisplayNode()
    var collectionNode: ASCollectionNode?
    var topBar: EFSwitchBarNode?
    var selectIndex: Int {
        get {
            let index = UserDefaults.standard.object(forKey: "selectIndex") as? String
            if index != nil {
                return Int(index!)!
            }
            return 0
        }
        
        set {
            UserDefaults.standard.set("\(newValue)", forKey: "selectIndex")
            UserDefaults.standard.synchronize()
        }
    }
    
    init() {
        super.init(node: rootNode)
        rootNode.backgroundColor = UIColor.white
//        ASLayoutSpec * _Nonnull(^ASLayoutSpecBlock)(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize);
//        self.node.layoutSpecBlock = (_ node:ASDisplayNode, _ constrainedSize: ASSizeRange)->ASLayoutSpec {
//
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 32))
        imageView.image = #imageLiteral(resourceName: "logo")
        self.navigationItem.titleView = imageView
        
        let barHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height)!
//        topBar = EFSwitchBarNode()
//        topBar!.delegate = self
//        topBar!.frame = CGRect(x: 0, y: barHeight, width: self.view.size.width, height: EFSwitchBarNode.viewHeight)
//        self.node.addSubnode(topBar!)
        topBar = EFSwitchBarNode()
        topBar!.delegate = self
        node.addSubnode(topBar!)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let collectionNodeHeight = self.view.size.height - barHeight - EFSwitchBarNode.viewHeight
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0.0
        collectionViewLayout.minimumInteritemSpacing = 0.0
        
        collectionNode = ASCollectionNode(frame:CGRect(x: 0, y: EFSwitchBarNode.viewHeight + barHeight, width: self.view.size.width, height:collectionNodeHeight), collectionViewLayout: collectionViewLayout)
        collectionNode?.delegate = self
        collectionNode?.dataSource = self;
        collectionNode?.view.isPagingEnabled = true
        node.addSubnode(collectionNode!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height)!
        topBar!.frame = CGRect(x: 0, y: barHeight, width: self.view.size.width, height: EFSwitchBarNode.viewHeight)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDisplayItem(selectIndex)
    }
    
    private func setupDisplayItem(_ index: Int) {
        let intexPath = IndexPath(row: index, section: 0)
        collectionNode?.scrollToItem(at: intexPath, at: .left, animated: false)
        topBar!.scrollToItem(indexPath: intexPath)
    }
    
    //MARK: ASCollectionNode data source and delegate
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 4;
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return EFGameModuleCellNode()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionNode!.view.contentOffset, size: collectionNode!.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.collectionNode?.indexPathForItem(at: visiblePoint)
        topBar!.scrollToItem(indexPath: indexPath!)
        selectIndex = indexPath!.row
    }
    
    //MARK: EFSwitchBarNodeDelegate
    func barNodeDidTapItem(_ barNode: EFSwitchBarNode, _ indexPath: IndexPath) {
        collectionNode?.scrollToItem(at: indexPath, at: .left, animated: true)
        selectIndex = indexPath.row
    }
}
