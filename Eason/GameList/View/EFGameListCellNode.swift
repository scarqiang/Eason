//
//  EFGameListCellNode.swift - 游戏列表cell
//  Eason
//
//  Created by Efun on 2017/9/25.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit
import YYKit

/// 一些布局固定参数
struct EFGameListCellMarker {
    let iconSize = CGSize.init(width: 80, height: 80)
    let titleFont = UIFont.systemFont(ofSize: 18);
    let gameCodeFont = UIFont.systemFont(ofSize: 16);
    let descriptionFont = UIFont.systemFont(ofSize: 11);
    let betweenSpac: CGFloat = 15.0;
    let insetSpac: CGFloat = 20;
}


/// 游戏列表的成员cell
final class EFGameListCellNode: ASCellNode {
    
    /// 游戏icon
    let iconImageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    /// 标题
    let titleTextNode: ASTextNode = ASTextNode()
    
    /// game code
    let gameCodeTextNode: ASTextNode = ASTextNode()
    
    /// 游戏描述
    let descriptionTextNode: ASTextNode = ASTextNode()
    
    /// 固定参数值
    let marker: EFGameListCellMarker = EFGameListCellMarker()
    
    override init() {
        super.init()
        titleTextNode.maximumNumberOfLines = 1;
        titleTextNode.style.flexGrow = 1;
        
        iconImageNode.backgroundColor = UIColor.gray;
        iconImageNode.defaultImage = UIImage(named: "defaultEfun.png")
        iconImageNode.layer.cornerRadius = marker.iconSize.height / 2
        iconImageNode.clipsToBounds = true
        
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
        
        descriptionTextNode.maximumNumberOfLines = 0;
        addSubnode(iconImageNode)
        addSubnode(titleTextNode)
        addSubnode(gameCodeTextNode)
        addSubnode(descriptionTextNode)
    }
    
    func setupGameData(model: EFGameListItemModel) {
        titleTextNode.attributedText = NSAttributedString(
            string: "\(model.game_code_info!.game_name)",
            attributes: [
                NSAttributedStringKey.font: marker.titleFont,
                NSAttributedStringKey.foregroundColor: UIColor.black
            ])
        
        gameCodeTextNode.attributedText = NSAttributedString(
            string: "\(model.game_code_info!.game_code)",
            attributes: [
                NSAttributedStringKey.font: marker.gameCodeFont,
                NSAttributedStringKey.foregroundColor: UIColor.gray
            ])
        
        descriptionTextNode.attributedText = NSAttributedString(
            string: model.packaged_date,
            attributes: [
                NSAttributedStringKey.font: marker.descriptionFont,
                NSAttributedStringKey.foregroundColor: UIColor.gray
            ])
        let imgURL = URL(string: model.game_code_info!.icon)
        iconImageNode.setURL(imgURL, resetToDefault: false)
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
                                         alignItems: .center,
                                         children: [iconImageNode, textSpac])
        let inset = marker.insetSpac;
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(inset, inset, inset, inset/2), child: packSpac)
    }
}
