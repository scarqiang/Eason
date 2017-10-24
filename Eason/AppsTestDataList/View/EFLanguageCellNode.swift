//
//  EFLanguageCellNode.swift
//  Eason
//
//  Created by Efun on 2017/10/19.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFLanguageCellNode: ASCellNode {
    let imageNode = ASImageNode()
    let countryNode = ASTextNode()
    var countryString: String?
    let checkImageNode = ASImageNode()
    
    convenience init(country: String) {
        self.init()
        countryString = country
        self.setupSubnode()
    }
    
    func setupSubnode() {
        
        if self.countryString != nil {
            if countryString!.hasPrefix("zh") {
                imageNode.image = #imageLiteral(resourceName: "china")
            }
            else if countryString!.hasPrefix("ar") {
                imageNode.image = #imageLiteral(resourceName: "saudi-arabia")
            }
            else if countryString!.hasPrefix("de") {
                imageNode.image = #imageLiteral(resourceName: "germany")
            }
            else if countryString!.hasPrefix("es") {
                imageNode.image = #imageLiteral(resourceName: "spain")
            }
            else if countryString!.hasPrefix("en") {
                imageNode.image = #imageLiteral(resourceName: "united-kingdom")
            }
            else if countryString!.hasPrefix("fr") {
                imageNode.image = #imageLiteral(resourceName: "france")
            }
            else if countryString!.hasPrefix("id") {
                imageNode.image = #imageLiteral(resourceName: "indonesia")
            }
            else if countryString!.hasPrefix("ja") {
                imageNode.image = #imageLiteral(resourceName: "japan")
            }
            else if countryString!.hasPrefix("ko") {
                imageNode.image = #imageLiteral(resourceName: "south-korea")
            }
            else if countryString!.hasPrefix("pt") {
                imageNode.image = #imageLiteral(resourceName: "portugal")
            }
            else if countryString!.hasPrefix("vi") {
                imageNode.image = #imageLiteral(resourceName: "vietnam")
            }
            else if countryString!.hasPrefix("ru") {
                imageNode.image = #imageLiteral(resourceName: "russia")
            }
            else if countryString!.hasPrefix("th") {
                imageNode.image = #imageLiteral(resourceName: "thailand")
            }
            else {
                imageNode.image = #imageLiteral(resourceName: "united-nations")
            }
        }
        countryNode.attributedText = NSAttributedString(string: countryString!, attributes: [
            NSAttributedStringKey.font: UIFont(name: "MarkerFelt-Thin", size: 24)!,
            NSAttributedStringKey.foregroundColor: UIColor.black
        ])
        
        checkImageNode.image = #imageLiteral(resourceName: "check-mark-2-xxl")
        
        self.addSubnode(imageNode)
        self.addSubnode(countryNode)
        self.addSubnode(checkImageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        super.layoutSpecThatFits(constrainedSize)
        
        checkImageNode.style.preferredSize = CGSize(width: 40, height: 40)
        imageNode.style.preferredSize = CGSize(width: 50, height: 50)
        let imageSpec = ASStackLayoutSpec(direction: .horizontal,
                                          spacing: 10,
                                          justifyContent: .start,
                                          alignItems: .center,
                                          children: [imageNode, countryNode])
        
        let wapSpec = ASStackLayoutSpec(direction: .horizontal,
                                        spacing: 0,
                                        justifyContent: .spaceBetween,
                                        alignItems: .center,
                                        children: [imageSpec, checkImageNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 5), child: wapSpec)
    }
}
