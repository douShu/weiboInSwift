//
//  WelcomeViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/9.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    
    // MARK: /**************************** 属性 ****************************/
    private var userIconBottomConstraint: NSLayoutConstraint?
    
    // MARK: /**************************** 初始化方法 ****************************/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(backgroudImg)
        view.addSubview(userIcon)
        view.addSubview(messageLabel)
        
        /// 设置子控件约束
        setupSubviewConstraint()
        
        // 设置用户头像
        if let urlString = UserAccount.sharedUserAccount?.avatar_large {
        
            userIcon.sd_setImageWithURL(NSURL(string: urlString)!)
        }
    }
    
    
    // MARK: /**************************** 头像动画 ****************************/
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        // 头像动画
        userIconAnimation()
    }
    
    func userIconAnimation() {
    
        if let bc = userIconBottomConstraint {
        
            bc.constant = -(UIScreen.mainScreen().bounds.height + bc.constant)
        }
        
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            }) { (_) -> Void in
                
                // TODO: 动画完成之后
                NSNotificationCenter.defaultCenter().postNotificationName(DSUIWindowDidChangeRootControllerNotification, object: isMainVC)
        }
    }
    
    
    // MARK: /**************************** 懒加载属性 ****************************/
    /// 背景图片
    lazy var backgroudImg: UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    /// 用户头像
    lazy var userIcon: UIImageView = {
    
        let img = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 45

        return img
    }()
    
    /// 消息文字
    lazy var messageLabel: UILabel = {
    
        let lb = UILabel()
        
        lb.text = "欢迎归来"
        lb.sizeToFit()
        
        return lb
    }()
    
    /// 设置约束
    private func setupSubviewConstraint() {
    
        // 背景图片
        backgroudImg.ff_Fill(view)
        
        // 用户头像
        let cons = userIcon.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: view, size: CGSize(width: 90, height: 90), offset: CGPoint(x: 0, y: -240))
        userIconBottomConstraint = userIcon.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        
        // 消息文字
        messageLabel.ff_AlignVertical(type: ff_AlignType.BottomCenter, referView: userIcon, size: nil, offset: CGPoint(x: 0, y: 32))
    }
    
  

  }
