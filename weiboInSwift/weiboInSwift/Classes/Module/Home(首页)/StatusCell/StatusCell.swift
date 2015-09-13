//
//  StatusCell.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/11.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

let cellSubviewMargin: CGFloat = 8.0

/// cell的标识符
enum StatusCellID: String {

    case NormalCell = "NormalCell"
    case RetweetCell = "RetweetCell"
    
    // 静态函数
    static func cellID(status: Status) -> String {
    
        return status.retweeted_status == nil ? StatusCellID.NormalCell.rawValue : StatusCellID.RetweetCell.rawValue
    }
}

class StatusCell: UITableViewCell {
    
    
    // MARK: - ----------------------------- 属性 -----------------------------
    var status: Status? {
    
        didSet   {
        
            // 给topview传递模型
            topView.status = status
            
            // 给内容文字赋值
            contentLabel.text = status?.text ?? ""
            
            // 给配图传模型
            pictureView.status = status
            pictureViewHeightCons?.constant = pictureView.bounds.height
            pictureViewWidthCons?.constant = pictureView.bounds.width
            pictureViewTopCons?.constant = (pictureView.bounds.height == 0 ? 0 : cellSubviewMargin)
            pictureView.reloadData()
        }
    }
    
    // MARK: - ----------------------------- 设置cell高度 -----------------------------
    func rowHeight(status: Status) -> CGFloat {
        
        self.status = status
        
        // 强行更新frame
        layoutIfNeeded()
        return CGRectGetMaxY(bottomView.frame)
        
    }
    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    // MARK: - ----------------------------- 设置cell上的控件 -----------------------------
    private func setupSubview() {
    
        contentView.addSubview(topView)
        contentView.addSubview(contentLabel)
        contentView.addSubview(pictureView)
        contentView.addSubview(bottomView)
        
        // 顶部视图
        topView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: contentView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 53))
        
        // 内容标签
        contentLabel.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: topView, size: nil, offset: CGPoint(x: cellSubviewMargin, y: cellSubviewMargin))
//        contentView.addConstraint(NSLayoutConstraint(item: contentLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: -2 * cellSubviewMargin))
        
        // 配图
//        let cons = pictureView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: contentLabel, size: CGSize(width: 290, height: 290), offset: CGPoint(x: 0, y: cellSubviewMargin))
//        pictureViewHeightCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Height)
//        pictureViewWidthCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Width)
//        pictureViewTopCons = pictureView.ff_Constraint(cons, attribute: NSLayoutAttribute.Top)
        
        
        // 底部视图
        bottomView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: pictureView, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44), offset: CGPoint(x: -cellSubviewMargin, y: cellSubviewMargin))
        
        // 底部约束
//        contentView.addConstraint(NSLayoutConstraint(item: bottomView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
    }
    
    
    // MARK: - ----------------------------- 懒加载控件 -----------------------------
    lazy var topView: TopView = TopView()
    
    lazy var contentLabel: UILabel = {
    
        let l = UILabel(textLabelColor: UIColor.darkGrayColor(), fontSize: 15)
        
        // 设置下面属性, 避免label换行不准
        l.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 2 * cellSubviewMargin

        l.numberOfLines = 0
        l.sizeToFit()
        
        return l
    }()
    
    lazy var bottomView: BottomView = BottomView()
    
    lazy var pictureView: PictureView = PictureView()
    
    // 图片视图的宽高约束
    var pictureViewWidthCons: NSLayoutConstraint?
    var pictureViewHeightCons: NSLayoutConstraint?
    var pictureViewTopCons: NSLayoutConstraint?
    
    
    
}
