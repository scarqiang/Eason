//
//  EFPlistMainCellNode.swift
//  Eason
//
//  Created by Efun on 2017/10/18.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFPlistMainCellNode: ASCellNode {
    let keyNode = ASTextNode()
    let valueNode = ASTextNode()
    
    convenience init(key: String, value: String) {
        self.init()
        
        keyNode.attributedText = NSAttributedString(
            string: key,
            attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        
        valueNode.attributedText = NSAttributedString(
            string: value,
            attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.gray
            ])
        
        self.addSubnode(keyNode)
        self.addSubnode(valueNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        super.layoutSpecThatFits(constrainedSize)
        
        valueNode.style.flexGrow = 1
        valueNode.maximumNumberOfLines = 0
        let textSpec = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 10,
                                         justifyContent: .spaceBetween,
                                         alignItems: .start,
                                         children: [keyNode, valueNode])
        textSpec.style.flexGrow = 1
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10),
                                 child: textSpec)
    }
    
}
