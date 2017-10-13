//
//  EFGameListViewController.swift
//  Eason
//
//  Created by Efun on 2017/9/25.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

final class EFGameListViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, ASCollectionDelegate, ASCollectionDataSource, EFSwitchBarNodeDelegate {

    enum EFGameListType: String {
        case recent = "最近游戏"
        case sea = "亚欧游戏"
        case hk = "港台游戏"
        case kr = "韩国游戏"
        
        static let allValues = [recent, sea, hk, kr]
    }
    
    private let tableNode = ASTableNode()
    private let rootNode = ASDisplayNode()
    private var collectionNode: ASCollectionNode?
    private var topBar: EFSwitchBarNode?
    private var dataArray = Array(repeatElement([EFGameListItemModel](), count: EFGameListType.allValues.count))
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 70, height: 32))
        imageView.image = #imageLiteral(resourceName: "logo")
        self.navigationItem.titleView = imageView
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 80, height: 35)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem
        
        //若不加上这句iOS10以下，少于64的collectionview就会显示不出cell
        self.automaticallyAdjustsScrollViewInsets = false
        
        var titles = [String]()
        for type in EFGameListType.allValues {
            titles.append(type.rawValue)
        }
        
        let barHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height)!
        topBar = EFSwitchBarNode(titles: titles)
        topBar!.delegate = self
        topBar!.frame = CGRect(x: 0, y: barHeight, width: self.view.size.width, height: EFSwitchBarNode.viewHeight)
        self.node.addSubnode(topBar!)
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDisplayItem(selectIndex)
    }
    
    private func setupDisplayItem(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionNode?.scrollToItem(at: indexPath, at: .left, animated: false)
        topBar!.scrollToItem(indexPath: indexPath)
//        self.reloadCollectionNode(indexPath: indexPath)
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func reloadCollectionNode(indexPath: IndexPath?) {
        if indexPath!.row == 0 {
            //获取本地最近游戏数据
            DispatchQueue.global().async {
                let realm = try! Realm()
                let recentList = realm.objects(EFRecentGameListModel.self)
                if let data = recentList.first {
                    let arr = Array(data.recentGameList)
                    self.synchronized(lock: self.dataArray, closure: {
                        self.dataArray[0] = arr
                    })
                    DispatchQueue.main.async {
                        self.reloadCollectionNode(indexPath: indexPath)
                    }
                }
            }
            return
        }
        
        if self.dataArray[indexPath!.row].count != 0 {
            return
        }
        
        self.fetchGameListData(index: indexPath!.row) { (listData) in
            if listData != nil {
                self.dataArray[indexPath!.row] = listData!
                self.collectionNode?.reloadItems(at: [indexPath!])
            }
        }
    }
    
    //lock
    func synchronized(lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    //MARK: Networking 获取各个地区游戏数据
    func fetchGameListData(index: Int, completion:@escaping (_ response:[EFGameListItemModel]?)->Void) {
        let type = EFGameListType.allValues[index]
        var area = EFGameArea.sea
        switch type {
        case .sea:
            break
        case .hk:
            area = .hk
        case .kr:
            area = .kr
        default:
            completion(nil)
            return
        }
        
        EFNetworking.shared.fetchGameList(area: area) { (response) in
            completion(response)
        }
    }
    
    //MARK: ASCollectionNode data source and delegate
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return EFGameListType.allValues.count;
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let listData = self.dataArray[indexPath.row]
        return EFGameModuleCellNode(listData: listData)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionNode!.view.contentOffset, size: collectionNode!.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = self.collectionNode?.indexPathForItem(at: visiblePoint)
        topBar!.scrollToItem(indexPath: indexPath!)
        selectIndex = indexPath!.row
        
        self.reloadCollectionNode(indexPath: indexPath)
    }
    
    //MARK: EFSwitchBarNodeDelegate
    func barNodeDidTapItem(_ barNode: EFSwitchBarNode, _ indexPath: IndexPath) {
        collectionNode?.scrollToItem(at: indexPath, at: .left, animated: true)
        selectIndex = indexPath.row
        
        self.reloadCollectionNode(indexPath: indexPath)
    }
}
