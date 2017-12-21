//
//  EFNetworkCellNode.swift - 检测网络信息cell node
//  Eason
//
//  Created by Efun on 2017/10/19.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFNetworkCellNode: ASCellNode {
    
    var dic: [String: Any]?
    let textNode = ASTextNode()
    
    convenience init(dic: [String: Any]) {
        self.init()
        self.dic = dic
        self.setupSubnode()
    }
    
    func setupSubnode() {
        self.textNode.attributedText = NSAttributedString(string: "\(dic!)", attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        self.textNode.maximumNumberOfLines = 0
        self.addSubnode(textNode)
        
        if dic?.values == nil {
            return
        }
        
        for (key, value) in dic?.values.first as! [String: Any]  {
            if key == "method" {
                if value as? String == "Response" {
                    self.backgroundColor = UIColor(hexString: "ef4758")
                }
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        super.layoutSpecThatFits(constrainedSize)
        
        textNode.style.flexGrow = 1
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: textNode)
    }
}
