//
//  TopView.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/11.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class TopView: UIView {

    
    // MARK: - |----------------------------- 属性 -----------------------------|
    var status: Status? {
    
        didSet {
            
            if let url = status?.user?.imageURL {
                
                iconView.sd_setImageWithURL(url)
            }
            nameLabel.text = status?.user?.name ?? ""
            vipIconView.image = status?.user?.vipImage
            memberIconView.image = status?.user?.memberImage
            
            // TODO: 后面会讲
            timeLabel.text = NSDate.sinaDate((status?.created_at)!)?.dateDesctiption
            sourceLabel.text = status?.source
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    
    
    // MARK: - |----------------------------- 构造方法 -----------------------------|
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - |----------------------------- 设置子控件 -----------------------------|
    private func setupSubview() {
    
        addSubview(sepView)
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(memberIconView)
        addSubview(vipIconView)
        
        // 设置布局
        sepView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: self, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 10))
        iconView.ff_AlignVertical(type: ff_AlignType.BottomLeft, referView: sepView, size: CGSize(width: 35, height: 35), offset: CGPoint(x: cellSubviewMargin, y: cellSubviewMargin))
        nameLabel.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: iconView, size: nil, offset: CGPoint(x: cellSubviewMargin, y: 0))
        timeLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: cellSubviewMargin, y: 0))
        sourceLabel.ff_AlignHorizontal(type: ff_AlignType.BottomRight, referView: timeLabel, size: nil, offset: CGPoint(x: cellSubviewMargin, y: 0))
        memberIconView.ff_AlignHorizontal(type: ff_AlignType.TopRight, referView: nameLabel, size: nil, offset: CGPoint(x: cellSubviewMargin, y: 0))
        vipIconView.ff_AlignInner(type: ff_AlignType.BottomRight, referView: iconView, size: nil, offset: CGPoint(x: cellSubviewMargin, y: cellSubviewMargin))
    }
    
    
    // MARK: - |----------------------------- 懒加载子控件 -----------------------------|
    // 灰色分隔
    private lazy var sepView: UIView = {
    
        let v = UIView()
        v.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        return v
    }()
    
    // 头像
    private lazy var iconView: UIImageView = UIImageView()
    
    // 姓名
    private lazy var nameLabel: UILabel = UILabel(textLabelColor: UIColor.darkGrayColor(), fontSize: 14)
    
    // 时间标签
    private lazy var timeLabel: UILabel = UILabel(textLabelColor: UIColor.orangeColor(), fontSize: 9)
    
    // 来源标签
    private lazy var sourceLabel: UILabel = UILabel(textLabelColor: UIColor.lightGrayColor(), fontSize: 9)
    
    // 会员图标
    private lazy var memberIconView: UIImageView = UIImageView(image: UIImage(named: "common_icon_membership_level1"))
    
    // vip图标
    private lazy var vipIconView: UIImageView = UIImageView(image: UIImage(named: "avatar_vip"))
}
