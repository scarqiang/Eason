//
//  EFPlistItemCellNode.swift - 检测plist内容状态的cell node
//  Eason
//
//  Created by Efun on 2017/10/18.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFPlistItemCellNode: ASCellNode {
    let titleNode = ASTextNode()
    let valueNode = ASTextNode()
    let iconImageNode = ASImageNode()
    var model: [String: Any]?
    var title = ""
    
    convenience init(model: [String: Any], title: String) {
        self.init()
        self.model = model
        self.title = title
        self.backgroundColor = UIColor.white
        self.setupCellContent(model: model)
    }
    
    private func setupCellContent(model: [String: Any]) {
        titleNode.attributedText = NSAttributedString(
            string: self.title,
            attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])

        valueNode.attributedText = NSAttributedString(
            string: model["item"] as! String,
            attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.gray
            ])
        
        iconImageNode.image = model["pass"] as! Int == 1 ? #imageLiteral(resourceName: "check") : #imageLiteral(resourceName: "close")
        
        self.addSubnode(valueNode)
        self.addSubnode(titleNode)
        self.addSubnode(iconImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        super.layoutSpecThatFits(constrainedSize)
        
        self.valueNode.style.flexGrow = 1
        self.valueNode.maximumNumberOfLines = 0
        let textSpec = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 5,
                                         justifyContent: .start,
                                         alignItems: .stretch,
                                         children: [self.titleNode, self.valueNode])
        
        iconImageNode.style.preferredSize = CGSize(width: 40, height: 40)
        textSpec.style.flexGrow = 1
        let minW = UIScreen.main.bounds.width - 60
        textSpec.style.maxSize = CGSize(width: minW, height: CGFloat.greatestFiniteMagnitude)
        
        iconImageNode.style.alignSelf = .end
        let wapSpec = ASStackLayoutSpec(direction: .horizontal,
                                         spacing: 10,
                                         justifyContent: .spaceBetween,
                                         alignItems: .stretch,
                                         children: [textSpec, iconImageNode])
        let edgeInset = UIEdgeInsetsMake(10, 10, 10, 5)
        return ASInsetLayoutSpec(insets: edgeInset, child: wapSpec)
    }
}
