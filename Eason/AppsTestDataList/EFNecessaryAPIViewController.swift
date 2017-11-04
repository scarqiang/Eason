//
//  EFNecessaryAPIViewController.swift
//  Eason
//
//  Created by Efun on 2017/11/2.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFCheckApiModel: NSObject {
    var api: String? = ""
    var apiDescription: String? = ""
    var isExist = false
}

class EFNecessaryAPIViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate, EFSelectAPIDelegate {
    
    var modelArr = [EFResultExternalInterfaceModel]()
    var apiModels = [EFCheckApiModel]()
    var addApiModels = [EFCheckApiModel]()
    var tableNode: ASTableNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "检查必调API"
        self.tableNode?.view.tableFooterView = UIView()
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        
        setupApiData()
        setupRightBarItem()
        
        // Do any additional setup after loading the view.

    }
    
    convenience init(models: [EFResultExternalInterfaceModel]) {
        let tableNode = ASTableNode(style: .grouped)
        self.init(node: tableNode)
        self.tableNode = tableNode
        if models.count != 0 {
            self.modelArr = models
        }
    }
    
    func setupApiData() {
        apiModels.removeAll()
        addApiModels.removeAll()
        
        let dic = EFUserInfo.getNecessaryAPI()
        for (key, value) in dic {
            let model = EFCheckApiModel()
            model.api = key
            model.apiDescription = value
            apiModels.append(model)
        }
        
        for item in modelArr {
            for apiModel in apiModels {
                if item.api == apiModel.api {
                    apiModel.isExist = true
                    break
                }
            }
        }
        
        let addDic = EFUserInfo.getDidSelectOptionAPI()
        for (key, value) in addDic {
            let model = EFCheckApiModel()
            model.api = key
            model.apiDescription = value
            addApiModels.append(model)
        }
        
        for item in addApiModels {
            for apiModel in apiModels {
                if item.api == apiModel.api {
                    apiModel.isExist = true
                    break
                }
            }
        }
        
        tableNode?.reloadData()
    }
    
    func setupRightBarItem() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "add"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(self.showOptionAPIList), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: button)
        let specItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        specItem.width = -10
        self.navigationItem.rightBarButtonItems = [searchItem, specItem]
    }
    
    @objc func showOptionAPIList() {
        let vc = EFSelectAPIViewController(delegate: self)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: EFSelectAPIDelegate
    func didSelectOptionAPI(dic: [String : String]) {
        setupApiData()
    }
    
    //MARK: table node delegate and datasource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        //        return flags.count
        
        if section == 0 {
            return apiModels.count
        }
        else {
            return addApiModels.count
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        //ascellnode don't need reuse
        
        var model: EFCheckApiModel?
        if indexPath.section == 0 {
            model = apiModels[indexPath.row]
        }
        else {
            model = addApiModels[indexPath.row]
        }
        
        let cell = EFNecessaryAPICellNode(api: model!.api!, description: model!.apiDescription!, isExist: model!.isExist)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            
            return "Necessity"
        }
        else {
            return "Addition"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let model = addApiModels[indexPath.row]
            let dic: [String: String] = [model.api!: model.apiDescription!]
            EFUserInfo.exchangeOptionAPI(dic: dic)
            
//            tableView.beginUpdates()
//            tableView.deleteRow(at: indexPath, with: .fade)
//            tableView.endUpdates()
            addApiModels.remove(at: indexPath.row)
            tableNode?.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
