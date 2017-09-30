//
//  EFGameListCellNode.swift
//  Eason
//
//  Created by Efun on 2017/9/25.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import YYKit

struct EFGameListCellMarker {
    let iconSize = CGSize.init(width: 80, height: 80)
    let titleFont = UIFont.systemFont(ofSize: 20);
    let gameCodeFont = UIFont.systemFont(ofSize: 16);
    let descriptionFont = UIFont.systemFont(ofSize: 11);
    let betweenSpac: CGFloat = 20.0;
    let insetSpac: CGFloat = 10;
}

final class EFGameListCellNode: ASCellNode {
    let iconImageNode: ASNetworkImageNode = ASNetworkImageNode()
    let titleTextNode: ASTextNode = ASTextNode()
    let gameCodeTextNode: ASTextNode = ASTextNode()
    let descriptionTextNode: ASTextNode = ASTextNode()
    let marker: EFGameListCellMarker = EFGameListCellMarker()
    let data = ["XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"]
    
    override init() {
        super.init()
        iconImageNode.backgroundColor = UIColor.gray;
        titleTextNode.attributedText = NSAttributedString(
            string: "Game Name",
            attributes: [
                NSAttributedStringKey.font: marker.titleFont,
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        
        gameCodeTextNode.attributedText = NSAttributedString(
            string: "game code",
            attributes: [
                NSAttributedStringKey.font: marker.gameCodeFont,
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        
        let num = arc4random()%3;
        
        descriptionTextNode.attributedText = NSAttributedString(
            string: data[Int(num)],
            attributes: [
                NSAttributedStringKey.font: marker.descriptionFont,
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        
        descriptionTextNode.maximumNumberOfLines = 0;
        addSubnode(iconImageNode)
        addSubnode(titleTextNode)
        addSubnode(gameCodeTextNode)
        addSubnode(descriptionTextNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        iconImageNode.style.preferredSize = marker.iconSize;
        let textSpac = ASStackLayoutSpec(direction: .vertical,
                                         spacing: marker.betweenSpac,
                                         justifyContent: .start,
                                         alignItems: .start,
                                         children: [titleTextNode, gameCodeTextNode, descriptionTextNode])
        textSpac.style.flexGrow = 1;
        textSpac.style.flexShrink = 1;
        
        let packSpac =  ASStackLayoutSpec(direction: .horizontal,
                                         spacing: marker.insetSpac,
                                         justifyContent: .start,
                                         alignItems: .start,
                                         children: [iconImageNode, textSpac])
        let inset = marker.insetSpac;
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(inset, inset, inset, inset), child: packSpac)
    }
}
