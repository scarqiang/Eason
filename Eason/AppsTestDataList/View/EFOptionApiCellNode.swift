//
//  EFOptionApiCellNode.swift - 可选api 列表的cell node
//  Eason
//
//  Created by Efun on 2017/11/4.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

/// 可选api 列表的cell node
class EFOptionApiCellNode: ASCellNode {
    let titleNode = ASTextNode()
    let valueNode = ASTextNode()
    let iconImageNode = ASImageNode()
    var api = ""
    var apiDescription = ""
    var isChoose: Bool {
        set {
            self.iconImageNode.isHidden = !newValue
        }
        get {
            return !self.iconImageNode.isHidden
        }
    }
    
    convenience init(api: String, description: String) {
        self.init()
        self.api = api
        self.apiDescription = description
        self.backgroundColor = UIColor.white
        self.setupCellContent()
    }
    
    private func setupCellContent() {
        
        self.iconImageNode.image = #imageLiteral(resourceName: "selected")
        self.iconImageNode.isHidden = true
        
        titleNode.attributedText = NSAttributedString(
            string: self.api,
            attributes: [
                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16),
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        
        valueNode.attributedText = NSAttributedString(
            string: self.apiDescription,
            attributes: [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: UIColor.gray
            ])
        
        self.addSubnode(valueNode)
        self.addSubnode(titleNode)
        self.addSubnode(iconImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        super.layoutSpecThatFits(constrainedSize)
        
        self.valueNode.style.flexGrow = 1
        self.valueNode.style.flexShrink = 1
        self.valueNode.maximumNumberOfLines = 0
        let textSpec = ASStackLayoutSpec(direction: .vertical,
                                         spacing: 5,
                                         justifyContent: .start,
                                         alignItems: .stretch,
                                         children: [self.titleNode, self.valueNode])
        
        iconImageNode.style.preferredSize = CGSize(width: 40, height: 40)
        textSpec.style.flexGrow = 1
        textSpec.style.flexShrink = 1
        let minW = UIScreen.main.bounds.width - 60
        textSpec.style.maxSize = CGSize(width: minW, height: CGFloat.greatestFiniteMagnitude)
        
        iconImageNode.style.alignSelf = .end
        let wapSpec = ASStackLayoutSpec(direction: .horizontal,
                                        spacing: 10,
                                        justifyContent: .spaceBetween,
                                        alignItems: .stretch,
                                        children: [textSpec, iconImageNode])
        
        let maxW = UIScreen.main.bounds.width / 3
        wapSpec.style.maxSize = CGSize(width: maxW, height: CGFloat.greatestFiniteMagnitude)
        
        let edgeInset = UIEdgeInsetsMake(10, 10, 10, 5)
        return ASInsetLayoutSpec(insets: edgeInset, child: wapSpec)
    }
}
