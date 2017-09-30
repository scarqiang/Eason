//
//  EFGameModuleCellNode.swift
//  Eason
//
//  Created by Efun on 2017/9/28.
//  Copyright © 2017年 Efun. All rights reserved.
//

import UIKit

class EFGameModuleCellNode: ASCellNode, ASTableDelegate, ASTableDataSource {
    private let tableNode = ASTableNode()
    var barHeight: CGFloat?
    override init() {
        super.init()
        
        barHeight = UIApplication.shared.statusBarFrame.size.height + 44
        tableNode.delegate = self
        tableNode.dataSource = self
        self.addSubnode(tableNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tableNode.style.preferredSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - EFSwitchBarNode.viewHeight - self.barHeight!)
        let spac = ASStackLayoutSpec(direction: .vertical,
                                     spacing: 0.0,
                                     justifyContent: .start,
                                     alignItems: .start,
                                     children: [tableNode])
        return spac
    }
    
    // MARK: ASTableNode data source and delegate.
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        
        let node = EFGameListCellNode()
        return node;
    }
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1;
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
}
