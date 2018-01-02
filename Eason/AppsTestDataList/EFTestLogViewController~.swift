//
//  EFTestLogViewController.swift - 测试打印日志结果界面
//  Eason
//
//  Created by Efun on 2017/10/16.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFTestLogViewController: ASViewController<ASDisplayNode> {

    var logString: String?
    let contentNode = ASEditableTextNode()
    
    convenience init(testLog: String) {
        let baseNode = ASDisplayNode()
        self.init(node:baseNode)
        baseNode.backgroundColor = UIColor.white
        baseNode.addSubnode(self.contentNode)
        let top = 50 + UIApplication.shared.statusBarFrame.size.height
        baseNode.layoutSpecBlock = {(node, constrainedSize) -> ASLayoutSpec in
            return ASInsetLayoutSpec.init(insets: UIEdgeInsetsMake(top, 10, 0, 0), child: self.contentNode)
        }
        self.logString = testLog.count != 0 ? testLog : "没有测试内容"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentNode.attributedText = NSAttributedString(
            string: logString!,
            attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        contentNode.textView.isEditable = false
        setupRightBarItem();
        // Do any additional setup after loading the view.
    }

    func setupRightBarItem() {
        let button = UIButton(type: .custom)
        button.setTitle("Copy", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        button.addTarget(self, action: #selector(self.didClickCopyButton), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: button)
        let specItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        specItem.width = -10
        self.navigationItem.rightBarButtonItems = [searchItem, specItem]
    }
    
    @objc func didClickCopyButton(button: UIButton) {
        let pasteBoard = UIPasteboard.general
        pasteBoard.string = self.logString
        
        let alertView = UIAlertController(title: "已复制到粘贴板", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        self.present(alertView, animated: true, completion: nil)
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
