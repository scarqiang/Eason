//
//  EFSettingCellNode.swift - 设置界面的cell
//  Eason
//
//  Created by Efun on 2017/10/24.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

/// 设置界面的cell
class EFSettingCellNode: ASCellNode {
    
    /// 开关
    let switchView = UISwitch()
    
    /// 包裹swichNode的node
    var switchNode: ASDisplayNode?
    
    /// 标题node
    let titleNode = ASTextNode()
    
    /// 标题
    var title: String?
    
    /// 代理
    var delegate: EFSettingCellNodeDelegate?
    
    convenience init(title: String, delegate: EFSettingCellNodeDelegate) {
        self.init()
        self.backgroundColor = UIColor.white
        self.title = title
        switchNode = ASDisplayNode(viewBlock: { () -> UIView in
            return self.switchView
        })
        self.addSubnode(switchNode!)
        self.switchView.addTarget(self, action: #selector(didClickSwitch(sender:)), for: .touchUpInside)
        self.delegate = delegate
        self.switchNode?.backgroundColor = UIColor.clear
        titleNode.attributedText = NSAttributedString(string: title, attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        self.addSubnode(titleNode)
    }
    
    @objc func didClickSwitch(sender: UISwitch) {
        if let delegate = self.delegate {
            delegate.didClickSwitchButton(isOn: sender.isOn, indexPath: self.indexPath!)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        switchNode?.style.preferredSize = CGSize(width: 60, height: 30)
        
        let wrapSpec = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .spaceBetween, alignItems: .center, children: [titleNode, switchNode!])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: wrapSpec)
    }
}

protocol EFSettingCellNodeDelegate {
    func didClickSwitchButton(isOn: Bool, indexPath: IndexPath) -> Void
}
