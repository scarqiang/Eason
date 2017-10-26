//
//  EFSearchBarNode.swift
//  Eason
//
//  Created by Efun on 2017/10/20.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

protocol EFSearchBarNodeDelegate {
    func didClickSearchButton(bar: EFSearchBarNode, keyword: String)
}

class EFSearchBarNode: ASDisplayNode, ASEditableTextNodeDelegate {
    let textNode = ASEditableTextNode()
    
    let iconNode = ASImageNode()
    var delegate: EFSearchBarNodeDelegate?
    
    convenience init(delegate: EFSearchBarNodeDelegate) {
        self.init()
        self.backgroundColor = UIColor(hexString: "c2c3c4")
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.setupSubNode()
        self.delegate = delegate
    }
    
    func setupSubNode() {
        iconNode.image = #imageLiteral(resourceName: "search-icon")
        textNode.scrollEnabled = false
        textNode.attributedPlaceholderText = NSAttributedString(string: "请输入关键字或game code", attributes: [
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
            NSAttributedStringKey.foregroundColor : UIColor(hexString: "8a8b8c")!
            ])
        textNode.textView.font = UIFont.systemFont(ofSize: 15)
        textNode.delegate = self
        textNode.returnKeyType = .search
        self.addSubnode(textNode)
        self.addSubnode(iconNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        super.layoutSpecThatFits(constrainedSize)
        
        textNode.style.flexGrow = 1
        iconNode.style.preferredSize = CGSize(width: 30, height: 30)
        let wapSpec = ASStackLayoutSpec(direction: .horizontal,
                                        spacing: 2,
                                        justifyContent: .start,
                                        alignItems: .center,
                                        children: [iconNode, textNode])
        
        return wapSpec
    }
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        self.textNode.becomeFirstResponder()
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        self.textNode.resignFirstResponder()
        return true
    }
    
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            
            if editableTextNode.attributedText?.string == nil || editableTextNode.attributedText?.length == 0 {
                return false
            }

            textNode.resignFirstResponder()
            if self.delegate != nil {
                self.delegate?.didClickSearchButton(bar: self, keyword: (editableTextNode.attributedText?.string)!)
            }
            return false
        }
        
        return true
    }
    
}
