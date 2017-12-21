//
//  EFAPIDataCellNode.swift - 检测api内容cell node
//  Eason
//
//  Created by Efun on 2017/10/19.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFAPIDataCellNode: ASCellNode {
    var model: EFResultExternalInterfaceModel?
    let descriptionNode = ASTextNode()
    let apiNode = ASTextNode()
    let parameterNode = ASTextNode()
    
    convenience init(model: EFResultExternalInterfaceModel) {
        self.init()
        self.model = model
        self.backgroundColor = UIColor(hexString: "18223a")
        self.setupSubNodes(model: model)
    }
    
    func setupSubNodes(model: EFResultExternalInterfaceModel) {
        let descirption1 = NSMutableAttributedString(string: "描述：",
                                              attributes: [
                                                NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                                                NSAttributedStringKey.foregroundColor: UIColor(hexString: "ff3366")!
            ])
        
        let descirption2 = NSAttributedString(string: model.apiDescription,
                                              attributes: [
                                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                                                NSAttributedStringKey.foregroundColor: UIColor(hexString: "f2f4f9")!
            ])
        descirption1.append(descirption2)
        self.descriptionNode.attributedText = descirption1.copy() as? NSAttributedString
        self.addSubnode(descriptionNode)
        descriptionNode.maximumNumberOfLines = 0
        
        let apiText1 = NSMutableAttributedString(string: "方法：",
                                                     attributes: [
                                                        NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                                                        NSAttributedStringKey.foregroundColor: UIColor(hexString: "ff3366")!
            ])
        
        let apiText2 = NSAttributedString(string: model.api,
                                              attributes: [
                                                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                                                NSAttributedStringKey.foregroundColor: UIColor(hexString: "b5b7b9")!
            ])
        
        apiText1.append(apiText2)
        self.apiNode.attributedText = apiText1.copy() as? NSAttributedString
        self.addSubnode(apiNode)
        apiNode.maximumNumberOfLines = 0
        
        let parameter1 = NSMutableAttributedString(string: "参数：",
                                                 attributes: [
                                                    NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14),
                                                    NSAttributedStringKey.foregroundColor: UIColor(hexString: "ff3366")!
            ])
        
        let parameter2 = NSAttributedString(string: model.parameters,
                                          attributes: [
                                            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                                            NSAttributedStringKey.foregroundColor: UIColor(hexString: "839095")!
            ])
        
        parameter1.append(parameter2)
        self.parameterNode.attributedText = parameter1.copy() as? NSAttributedString
        self.addSubnode(parameterNode)
        parameterNode.maximumNumberOfLines = 0
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        super.layoutSpecThatFits(constrainedSize)
        
        let textSpec = ASStackLayoutSpec.init(direction: .vertical, spacing: 8, justifyContent: .spaceBetween, alignItems: .stretch, children: [descriptionNode, apiNode, parameterNode])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(8, 8, 8, 8), child: textSpec)
    }
    
}
