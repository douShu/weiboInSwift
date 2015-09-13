//
//  NormalCell.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/12.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class NormalCell: StatusCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: cellSubviewMargin))
        pictureViewHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureViewWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
