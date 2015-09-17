//
//  ComposeViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/14.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SVProgressHUD

class ComposeViewController: UIViewController {

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // 设置界面
        setupUI()
        
        // 通知: 监听键盘
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
    }
    
    deinit {
    
        // 取消键盘通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    // MARK: - ----------------------------- 键盘通知 -----------------------------
    func keyboardChanged(notify: NSNotification) {
    
        print(notify)
        
        let userInfo = notify.userInfo as! [String : AnyObject]
        
        // 取到键盘弹出的时间
        let  durationTime = userInfo["UIKeyboardAnimationDurationUserInfoKey"]?.doubleValue
        
        let curve = userInfo["UIKeyboardAnimationCurveUserInfoKey"]?.integerValue
        
        // 取出键盘的y值
        let keyboardY = userInfo["UIKeyboardFrameEndUserInfoKey"]?.CGRectValue.origin.y
        
        print(toolBarBottomCon?.constant)
        
        // toolBar的底部约束
        toolBarBottomCon?.constant = -(screenH - keyboardY!)

        // 动画更新约束
        UIView.animateWithDuration(durationTime!) { () -> Void in
            
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve!)!)
            
            // 强制更新约束
            self.view.layoutIfNeeded()
        }
        
    }
    
    
    // MARK: - ----------------------------- 视图生命周期方法 -----------------------------
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // 将textView变为第一响应者
        textView.becomeFirstResponder()
    }
    
    
    // MARK: - ----------------------------- 设置UI -----------------------------
    private func setupUI() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        view.addSubview(textView)
        view.addSubview(photoSelectedVC.view)
        view.addSubview(toolbar)
        
        preperNav()
        preperToolbar()
        preperTextview()
        preperPhotoView()
    }
    
    func preperPhotoView() {
        
        /// 响应者链条
        addChildViewController(photoSelectedVC)
        
        var s = UIScreen.mainScreen().bounds.size
        
        s.height = 0.6 * s.height
        
        photoSelectedVC.view.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: s)
        
    }
    
    private func preperTextview() {
        
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil, offset: CGPoint(x: 0, y: 0))
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolbar, size: nil)
        
        textView.backgroundColor = UIColor.whiteColor()
        
        // 设置站位标签
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.sizeToFit()
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
        
        /// 增加一个提醒用户输入文本标签
        view.addSubview(lengthLabel)
        lengthLabel.sizeToFit()
        lengthLabel.text = String(MaxTextLength)
        lengthLabel.textColor = UIColor.darkGrayColor()
        lengthLabel.ff_AlignInner(type: ff_AlignType.BottomRight, referView: textView, size: nil, offset: CGPoint(x: -8, y: -8))    }
    
    private func preperToolbar() {
    
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        let cons = toolbar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))
        toolBarBottomCon = toolbar.ff_Constraint(cons, attribute: NSLayoutAttribute.Bottom)
        
        let itemSettings = [["imageName": "compose_toolbar_picture"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            ["imageName": "compose_addbutton_background"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in itemSettings {
        
            items.append(UIBarButtonItem(imgName: dict["imageName"]!, target: self, action: dict["action"]))
            
            // 追加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        
        toolbar.items = items
    }

    private func preperNav() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        
        // 标题栏
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 32))
        
        let tl = UILabel(textLabelColor: UIColor.darkGrayColor(), fontSize: 15)
        tl.text = "发微博"
        tl.sizeToFit()
        titleView.addSubview(tl)
        tl.ff_AlignInner(type: ff_AlignType.TopCenter, referView: titleView, size: nil)
        
        let nl = UILabel(textLabelColor: UIColor.darkGrayColor(), fontSize: 13)
        nl.text = UserAccount.sharedUserAccount?.name ?? ""
        nl.sizeToFit()
        titleView.addSubview(nl)
        nl.ff_AlignInner(type: ff_AlignType.BottomCenter, referView: titleView, size: nil)
        
        navigationItem.titleView = titleView
    }
    
    
    // MARK: - ----------------------------- 监听方法 -----------------------------
    func close() {
        
        // 取消textview的响应
        textView.resignFirstResponder()
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendStatus() {
        
        /// 1> 检测文本的长度
        let text = textView.emoticonText
        
        if text.characters.count > MaxTextLength {
        
            SVProgressHUD.showInfoWithStatus("您输入的文本太长", maskType: SVProgressHUDMaskType.Gradient)
            
            return
        }
        
        /// 2> 发布微博
        let image = photoSelectedVC.photos.last
        NetworkTool.sharedNetworkTool.updateStatuses(text, image: image) { (result, error) -> () in
            
            if error != nil {
            
                SVProgressHUD.showInfoWithStatus("您的网络不给力", maskType: SVProgressHUDMaskType.Black)
                
                return
            }
            
            self.close()
        }
    }
    
    func inputEmoticon() {
        
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    
        /// 注销键盘
        textView.resignFirstResponder()
        
        textView.inputView = (textView.inputView == nil) ? emoticonVC.view : nil
        
//         NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChanged:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        /// 激活键盘
        textView.becomeFirstResponder()
    }
    
    
    // MARK: - ----------------------------- 懒加载控件 -----------------------------
    private lazy var toolbar: UIToolbar = UIToolbar()
    
    // 站位标签
    private lazy var placeHolderLabel: UILabel = UILabel(textLabelColor: UIColor.lightGrayColor(), fontSize: 18)
    
    private lazy var textView: UITextView = {
    
        let tv = UITextView()
        
        tv.delegate = self
        
        tv.font = UIFont.systemFontOfSize(18)
        
        // 能够垂直拖拽
        tv.alwaysBounceVertical = true
        
        // 拖拽关闭键盘
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        
        return tv
    }()
    
    /// 照片选择控制器
    private lazy var photoSelectedVC = PhotoSelectedCollectionViewController()
    
    /// 表情键盘控制器
    private lazy var emoticonVC: EmoticonViewController = EmoticonViewController { [weak self] (emoticon) -> () in
        
        self?.textView.insertEmoticon(emoticon)
    }
    
    /// 屏幕高度
    private lazy var screenH: CGFloat = UIScreen.mainScreen().bounds.height
    
    /// toolBar的底部约束
    private var toolBarBottomCon: NSLayoutConstraint?
    
    /// 提示用户还可以输入多少文本
    private lazy var lengthLabel: UILabel = UILabel()
    
    /// 用户最多可以输入的文本字数
    private let MaxTextLength = 10
    
}

extension ComposeViewController: UITextViewDelegate {

    func textViewDidChange(textView: UITextView) {
        
        /// 设置站位标签的显示与隐藏
        placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
        /// 提醒用户输入多少字
        let text = textView.emoticonText
        let count = text.characters.count
        let len = MaxTextLength - count
        lengthLabel.text = String(len)
        lengthLabel.textColor = len > 0 ? UIColor.darkGrayColor() : UIColor.redColor()
    }
}
