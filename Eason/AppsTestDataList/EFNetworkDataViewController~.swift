//
//  EFNetworkDataViewController.swift - 网络数据展示界面
//  Eason
//
//  Created by Efun on 2017/10/19.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import RealmSwift

class EFNetworkDataViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {

    var tableNode: ASTableNode?
    var dataArr = [Any]()
    
    init() {
        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)
        self.title = "网络数据"
        self.tableNode = tableNode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableNode?.delegate = self
        tableNode?.dataSource = self
        
        fetchNetworkData { [weak self] (arr) in
            if arr != nil {
                self?.dataArr = arr!
                self?.tableNode?.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchNetworkData(compelet: @escaping (_ dataArr:[Any]?) -> Void) {
        let realm = try! Realm()
        EFExamineTool.queue.sync {
            let networkData = realm.objects(EFNetworkDataModel.self).first
            let arr = networkData?.fetchNetworkData()
            DispatchQueue.main.async {
                compelet(arr)
            }
        }
    }
    
    //lock
    func synchronized(lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    //MARK: table node delegate and datasource
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        //        return flags.count
        return dataArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let dic = self.dataArr[indexPath.row] as? [String: Any]
        let cell = EFNetworkCellNode(dic: dic!)
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        let dic = self.dataArr[indexPath.row] as? [String: Any]
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = "\(String(describing: dic))"
        
        let alertView = UIAlertController(title: "已复制到粘贴板", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)
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
