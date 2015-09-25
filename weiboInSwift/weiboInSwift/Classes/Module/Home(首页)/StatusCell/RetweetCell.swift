//
//  RetweetCell.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/12.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class RetweetCell: StatusCell {
    
    
    // MARK: - ----------------------------- 属性 -----------------------------
    override var status: Status?{
    
        didSet {
            
            let name = status?.retweeted_status?.user?.name ?? ""
            let text = status?.retweeted_status?.text ?? ""
            
            retweetLabel.text = "@\(name) : \(text)"
        }
    }
    
    // MARK: - ----------------------------- 构造函数 -----------------------------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupRetweetSubview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - ----------------------------- 设置子控件 -----------------------------
    private func setupRetweetSubview() {
    
        contentView.insertSubview(backBtn, belowSubview: pictureView)
        contentView.insertSubview(retweetLabel, aboveSubview: backBtn)
        
        // 设置约束
        backBtn.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: nil, offset: CGPoint(x: -cellSubviewMargin, y: cellSubviewMargin))
        backBtn.ff_AlignVertical(type: ff_AlignType.TopRight, referView: bottomView, size: nil)
        
        retweetLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: backBtn, size: nil, offset: CGPoint(x: cellSubviewMargin, y: cellSubviewMargin))
        
        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: retweetLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: cellSubviewMargin))
        pictureViewHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
        pictureViewWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
        pictureViewTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
    }
    
    // MARK: - ----------------------------- 懒加载属性 -----------------------------
    lazy var retweetLabel: FFLabel = {
        
        let l = FFLabel(textLabelColor: UIColor.darkGrayColor(), fontSize: 14)
        
        l.numberOfLines = 0
        l.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * cellSubviewMargin
        
        /// 设置label的代理
        l.labelDelegate = self
        
        return l
    }()
    
    lazy var backBtn: UIButton = {
        
        let b = UIButton()
        b.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        return b
    }()
}
