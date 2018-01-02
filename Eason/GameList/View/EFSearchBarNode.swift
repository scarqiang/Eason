//
//  EFSearchBarNode.swift - 搜索页面的顶部bar
//  Eason
//
//  Created by Efun on 2017/10/20.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

/// 搜索页面代理
protocol EFSearchBarNodeDelegate {
    
    /// 点击搜索按钮代理方法
    ///
    /// - Parameters:
    ///   - bar: EFSearchBarNode
    ///   - keyword: 关键字
    func didClickSearchButton(bar: EFSearchBarNode, keyword: String)
    
    /// 当搜索栏中的字体变化监听代理方法
    ///
    /// - Parameters:
    ///   - text: 搜索框的输入的文字
    ///   - keyword: 搜索框输入中的文字
    func shouldChange(text: String, keyword: String)
}

class EFSearchBarNode: ASDisplayNode, ASEditableTextNodeDelegate {
    
    /// 搜索框中的textview
    let textNode = ASEditableTextNode()
    
    /// 收缩框中的icon
    let iconNode = ASImageNode()
    
    /// 代理
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
        
        if text.count > 0 {
            
            var keyword = text
            
            if editableTextNode.attributedText != nil && editableTextNode.attributedText?.length != 0 {
                keyword = editableTextNode.attributedText!.string + keyword
            }
            self.delegate!.shouldChange(text: text, keyword: keyword)
             return true
        }
        
        if editableTextNode.attributedText != nil && editableTextNode.attributedText?.length != 0 && text == "" {
            
            var keyword = editableTextNode.attributedText!.string
            keyword.removeLast()
            self.delegate!.shouldChange(text: text, keyword: keyword)
            return true
        }
        
        return true
    }
    
}
