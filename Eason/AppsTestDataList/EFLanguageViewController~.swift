//
//  EFLanguageViewController.swift - 游戏语言展示界面
//  Eason
//
//  Created by Efun on 2017/10/19.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFLanguageViewController: ASViewController<ASDisplayNode>, ASTableDataSource, ASTableDelegate {

    var tableNode: ASTableNode?
    var modelArr = [StringObject]()
    let flags = ["zh", "en", "ru", "th", "ko", "ex", "pt", "vi", "id"]
    
    convenience init(models: [StringObject]) {
        let tableNode = ASTableNode(style: .plain)
        self.init(node: tableNode)
        self.tableNode = tableNode
        if models.count != 0 {
            self.modelArr = models
        }
    }
    
    //MARK: table node delegate and datasource
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
//        return flags.count
        return modelArr.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        //ascellnode don't need reuse
        let model = modelArr[indexPath.row]
        let cell = EFLanguageCellNode(country: model.value!)
//        let flags = ["zh", "en", "ru", "th", "ko", "ex", "pt", "vi", "id"]
//        let flag = flags[indexPath.row]
//        let cell = EFLanguageCellNode(country: flag);
        cell.selectionStyle = .none
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Language"
        
        self.tableNode?.view.tableFooterView = UIView()
        self.tableNode!.delegate = self
        self.tableNode!.dataSource = self
        
        // Do any additional setup after loading the view.
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
