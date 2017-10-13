//
//  EFTestViewController.swift
//  Eason
//
//  Created by scarqiang on 2017/9/30.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFTestViewController: ASViewController<ASDisplayNode>,ASCollectionDelegate, ASCollectionDataSource, EFSwitchBarItemDelegate {

    private let titles = ["最近游戏", "亚欧游戏", "港台游戏", "韩国游戏"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.node.backgroundColor = UIColor.gray
     
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 80, height: 35)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.blue, for: .normal)
        backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        let backItem = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
//        layout.itemSize = CGSize(width: 120, height: 50)
        
        let collectionNode = ASCollectionNode(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 50), collectionViewLayout: layout)
        collectionNode.delegate = self
        collectionNode.dataSource = self
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.backgroundColor = UIColor.yellow    
        self.node.addSubnode(collectionNode)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: collectionNode data source and delegate.
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        return EFSwitchBarItemNode.init("test", self)
    }

    func switchBarItemNode(_ itemNode: EFSwitchBarItemNode, didTapAction indexPath: IndexPath) {
        
    }
    
    @objc func goBack() {
        self.dismiss(animated: true, completion: nil)
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
