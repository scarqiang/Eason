//
//  EFSelectAPIViewController.swift - 选择需要检测api调用的界面
//  Eason
//
//  Created by Efun on 2017/11/4.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFSelectApiModel: NSObject {
    var api: String? = ""
    var apiDescription: String? = ""
    var isSelected = false
}

protocol EFSelectAPIDelegate {
    func didSelectOptionAPI(dic: [String: String])
}

class EFSelectAPIViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {
    
    let tableNode = ASTableNode(style: .plain)
    let buttonNode = ASButtonNode()
    var delegate: EFSelectAPIDelegate?
    var apiModels = [EFSelectApiModel]()
    var selectedArr = [EFSelectApiModel]()
    
    convenience init(delegate: EFSelectAPIDelegate) {
        let rootNode = ASDisplayNode()
        self.init(node: rootNode)
        self.delegate = delegate
        
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.tableFooterView = UIView()
        
        rootNode.addSubnode(tableNode)
        rootNode.addSubnode(buttonNode)
        rootNode.layoutSpecBlock = self.layoutSpecBlock(node:constrainedSize:)
    }
    
    func layoutSpecBlock(node: ASDisplayNode, constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let screenSize = self.view.bounds.size
        self.tableNode.style.flexGrow = 1
        self.tableNode.style.flexShrink = 1
        buttonNode.style.preferredSize = CGSize(width: screenSize.width / 3, height: 40)
        let wrapSpec = ASStackLayoutSpec(direction: .vertical, spacing: 20, justifyContent: .spaceBetween, alignItems: .center, children: [self.tableNode, self.buttonNode])
        
        return ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(60, 50, 60, 50), child: wrapSpec)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.backgroundColor = UIColor.clear
        self.node.isOpaque = false
        
        let backView = UIView(frame: self.view.bounds)
        view.addSubview(backView)
        view.sendSubview(toBack: backView)
        backView.backgroundColor = UIColor.black
        backView.alpha = 0.45
        
        tableNode.cornerRadius = 8
        buttonNode.cornerRadius = 20
        buttonNode.setTitle("完成", with: UIFont.systemFont(ofSize: 15), with: UIColor.black, for: .normal)
        buttonNode.backgroundColor = UIColor.white
        buttonNode.addTarget(self, action: #selector(self.didClickButton), forControlEvents: .touchUpInside)
        
        self.setupApiData()
        // Do any additional setup after loading the view.
    }
    
    @objc func didClickButton() {
        var selectedDic = [String: String]()
        for model in apiModels {
            if model.isSelected {
                selectedDic[model.api!] = model.apiDescription!
            }
        }
        
        EFUserInfo.exchangeOptionAPI(dic: selectedDic)
        self.delegate!.didSelectOptionAPI(dic: selectedDic)
        self.dismiss(animated: true, completion: nil)
    }

    func setupApiData() {
        let dic = EFUserInfo.getOptionAPI()
        for (key, value) in dic {
            let model = EFSelectApiModel()
            model.api = key
            model.apiDescription = value
            apiModels.append(model)
        }
        
        tableNode.reloadData()
    }
    
    //MARK: table node delegate and datasource
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        //        return flags.count
        return apiModels.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        //ascellnode don't need reuse
        let model = apiModels[indexPath.row]
        let cell = EFOptionApiCellNode(api: model.api!, description: model.apiDescription!)
        return cell
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        let cell = tableNode.nodeForRow(at: indexPath) as! EFOptionApiCellNode
        cell.isChoose = !cell.isChoose
        let model = apiModels[indexPath.row]
        model.isSelected = cell.isChoose
    
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
