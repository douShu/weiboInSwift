//
//  BottomView.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/12.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class BottomView: UIView {

    
    // MARK: - ----------------------------- 构造方法 -----------------------------
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupSubview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - ----------------------------- 添加子控件 -----------------------------
    private func setupSubview() {
        
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        addSubview(retweetBtn)
        addSubview(commentBtn)
        addSubview(likeBtn)
        
        // 设置约束
        ff_HorizontalTile([retweetBtn, commentBtn, likeBtn], insets: UIEdgeInsetsZero)
        
    }
    
    
    // MARK: - ----------------------------- 懒加载控件 -----------------------------
    private lazy var retweetBtn: UIButton = UIButton(title: "转发", imgName: "timeline_icon_retweet")
    private lazy var commentBtn: UIButton = UIButton(title: "评论", imgName: "timeline_icon_comment")
    private lazy var likeBtn: UIButton = UIButton(title: "赞", imgName: "timeline_icon_unlike")

}
