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


final class EFGameListViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, ASCollectionDelegate, ASCollectionDataSource, EFSwitchBarNodeDelegate, EFGameModuleCellNodeDeleage {

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
        self.title = "游戏列表"
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
        
        self.setupSearchButton()

        //若不加上这句iOS10以下，少于64的collectionview就会显示不出cell
        self.automaticallyAdjustsScrollViewInsets = false
        
        var titles = [String]()
        for type in EFGameListType.allValues {
            titles.append(type.rawValue)
        }
        
        let barHeight = UIApplication.shared.statusBarFrame.size.height + (self.navigationController?.navigationBar.frame.height)!
        topBar = EFSwitchBarNode(titles: titles)
        topBar!.frame = CGRect(x: 0, y: barHeight, width: self.view.size.width, height: EFSwitchBarNode.viewHeight)
        topBar!.delegate = self
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
        
        if EFUserInfo.isLogin() == false {
            let loginVC = EFLoginViewController()
            self.present(loginVC, animated: false, completion: nil)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupDisplayItem(selectIndex)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        EFExamineTool.loadingView.stopAnimating()
    }
    
    private func setupDisplayItem(_ index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        collectionNode?.scrollToItem(at: indexPath, at: .left, animated: false)
        topBar!.scrollToItem(indexPath: indexPath)
    }
    
    @objc func pushSettingVC() {
        let vc = EFSettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupSearchButton() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "search-icon-blue"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(self.pushSearchViewController), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: button)
        let specItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        specItem.width = -10
        self.navigationItem.rightBarButtonItems = [searchItem, specItem]
        
        let settingBtn = UIButton(type: .custom)
        settingBtn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        settingBtn.setBackgroundImage(#imageLiteral(resourceName: "gear"), for: .normal)
        settingBtn.addTarget(self, action: #selector(self.pushSettingVC), for: .touchUpInside)
        let settingItem = UIBarButtonItem(customView: settingBtn)
        let specItem2 = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        specItem.width = 10
        self.navigationItem.leftBarButtonItems = [settingItem, specItem2]
    }
    
    @objc func pushSearchViewController() {
        let vc = EFSearchGameViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 通过indexPath位置刷新collection node item
    ///
    /// - Parameter indexPath: 目标位置
    func reloadCollectionNode(indexPath: IndexPath?) {
        
        if self.dataArray[indexPath!.row].count != 0 {
            return
        }
        
        if indexPath!.row == 0 {
            //获取本地最近游戏数据
            EFExamineTool.loadingView.startAnimating()
            EFExamineTool.queue.sync { [weak self] in
                let realm = try! Realm()
                let recentList = realm.objects(EFRecentGameListModel.self)
                if let data = recentList.first {
                    let arr = Array(data.recentGameList)
                    self!.synchronized(lock: self!.dataArray, closure: {
                        self!.dataArray[0] = arr
                    })
                    DispatchQueue.main.async {
                        self!.collectionNode?.reloadItems(at: [indexPath!])
                        EFExamineTool.loadingView.stopAnimating()
                    }
                }
                else {
                    EFExamineTool.loadingView.stopAnimating()
                }
            }
            return
        }
        
        EFExamineTool.loadingView.startAnimating()
        self.fetchGameListData(index: indexPath!.row) { (listData, error) in
            EFExamineTool.loadingView.stopAnimating()
            if listData != nil {
                self.synchronized(lock: self.dataArray, closure: {
                  self.dataArray[indexPath!.row] = listData!
                })
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
    func fetchGameListData(index: Int, completion:@escaping (_ response:[EFGameListItemModel]?,_ error: Error?)->Void) {
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
            completion(nil, nil)
            return
        }
        
        EFNetworking.shared.fetchGameList(area: area) { (response, error) in
            completion(response, error)
        }
    }
    
    //MARK: ASCollectionNode data source and delegate
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return EFGameListType.allValues.count;
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let listData = self.dataArray[indexPath.row]
        return EFGameModuleCellNode(listData: listData, delegate: self)
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
    
    //MARK: EFGameModuleCellNodeDeleage
    func didSelectGameModuleCell(model: EFGameListItemModel) {
//        let gameCode = model.game_code_info?.game_code
        let vc = EFAnalyzationDataListViewController(gameCode: "krtestios", gameName: model.game_code_info!.game_name)
        self.navigationController?.pushViewController(vc, animated: true)
        EFExamineTool.saveRecentGamesData(model: model)
    }
    
    func didClickReloadButton(indexPath: IndexPath) {
        self.reloadCollectionNode(indexPath: indexPath)
    }
    
}
