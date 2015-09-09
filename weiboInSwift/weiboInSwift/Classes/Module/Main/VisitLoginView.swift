//
//  VisitLoginView.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/7.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

protocol VisitLoginViewDelegate: NSObjectProtocol {

    // 将要注册
    func visitLoginViewWillRegist()
    
    // 将要登录
    func visitLoginViewWillLogin()
}


class VisitLoginView: UIView {

    // 代理属性
    weak var delegate: VisitLoginViewDelegate?
    
// MARK: /**************************** 监听按钮点击事件 ****************************/

    // 注册
    func clickRegistBtn() {
    
        delegate?.visitLoginViewWillRegist()
    }
    // 登录
    func clickLoginBtn() {
    
        delegate?.visitLoginViewWillLogin()
    }
    
    // 设置每个VC的登录界面
    func setupLoginImageView(isHome: Bool, imgName: String, message: String) {
    
        if isHome {
        
            return
        }
        
        iconView.hidden = true
        imgView.image = UIImage(named: imgName)
        messageLabel.text = message
    }

    // MARK:  创建view视图
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setupSubview()
        
    }
    required init?(coder aDecoder: NSCoder) {
        
        // 禁止使用 SB/XIB
        // fatalError("init(coder:) has not been implemented")
        
        super.init(coder: aDecoder)
        
        setupSubview()
    }
    
    // 添加控件
    private func setupSubview() {
        
        // 设置背景颜色
        backgroundColor = UIColor(white: 237.0 / 255.0, alpha: 1.0)
        
        // 添加控件
        addSubview(iconView)
        addSubview(maskImgView)
        addSubview(imgView)
        addSubview(messageLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        // 设置约束
        setupSubviewsConstraint()
        
        // 开始动画
        setupAnimation()
    }

    // MARK:  懒加载控件
    // 转图
    private lazy var iconView: UIImageView = {
        
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))

        return iv
    }()
    private func setupAnimation() {
    
        let anim = CABasicAnimation()
        
        anim.keyPath = "transform.rotation"
        
        anim.toValue = 2 * M_PI
        
        anim.repeatCount = MAXFLOAT
        
        anim.removedOnCompletion = false
        
        iconView.layer.addAnimation(anim, forKey: nil)
    }
    
    // 遮蔽图片
    private lazy var maskImgView: UIImageView = {
    
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return iv
    }()
    
    // 房子
    private lazy var imgView: UIImageView = {
    
        let iv = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        
        return iv
    }()
    
    // 消息文字
    private lazy var messageLabel: UILabel = {
    
       let l = UILabel()
        
        // 设置l属性
        l.text = "关注一些人, 回这里看看有什么惊喜"
        l.font = UIFont.systemFontOfSize(14)
        l.textColor = UIColor.darkGrayColor()
        l.numberOfLines = 0
        l.preferredMaxLayoutWidth = 240
        
        return l
    }()
    
    // 注册按钮
    private lazy var registerButton: UIButton = {
        
        let btn = UIButton()
        
        // 设置btn属性
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitle("注册", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(16)
        
        // 监听点击
        btn.addTarget(self, action: "clickRegistBtn", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
    }()

    // 登录按钮
    private lazy var loginButton: UIButton = {
        
        let btn = UIButton()
        
        // 设置btn属性
        btn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        btn.setTitle("登录", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
        btn.titleLabel?.font = UIFont.systemFontOfSize(16)
        
        // 监听登录
        btn.addTarget(self, action: "clickLoginBtn", forControlEvents: UIControlEvents.TouchUpInside)
        
        return btn
        }()
    
    // 设置约束
    private func setupSubviewsConstraint() {
    
        // 转图
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -60))
        
        // 小房子
        imgView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: imgView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        // 消息文字
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: messageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15))
        
        // 注册按钮
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 0, constant: 80))
        addConstraint(NSLayoutConstraint(item: registerButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 0, constant: 35))
        
        // 登录按钮
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: messageLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 15))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 0, constant: 80))
        addConstraint(NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute(rawValue: 0)!, multiplier: 0, constant: 35))
        
        // 遮蔽图片
        maskImgView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[mask]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mask": maskImgView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[mask]-(-35)-[regBtn]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mask": maskImgView, "regBtn": registerButton]))
    }
}
