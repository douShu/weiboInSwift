//
//  ComposeViewController.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/14.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    
    // MARK: - ----------------------------- 设置UI -----------------------------
    private func setupUI() {
        
        view.backgroundColor = UIColor.whiteColor()
        
        preperNav()
        preperToolbar()
        preperTextview()
    }
    
    
    // MARK: - ----------------------------- 设置textView -----------------------------
    private func preperTextview() {
        
        view.addSubview(textView)
        textView.ff_AlignInner(type: ff_AlignType.TopLeft, referView: view, size: nil, offset: CGPoint(x: 0, y: 64))
        textView.ff_AlignVertical(type: ff_AlignType.TopRight, referView: toolbar, size: nil)
        
        textView.backgroundColor = UIColor.orangeColor()
        
        // 设置站位标签
        placeHolderLabel.text = "分享新鲜事..."
        placeHolderLabel.sizeToFit()
        textView.addSubview(placeHolderLabel)
        placeHolderLabel.ff_AlignInner(type: ff_AlignType.TopLeft, referView: textView, size: nil, offset: CGPoint(x: 5, y: 8))
    }
    
    
    
    // MARK: - ----------------------------- 设置底部视图 -----------------------------
    private func preperToolbar() {
    
        toolbar.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        view.addSubview(toolbar)
        
        toolbar.ff_AlignInner(type: ff_AlignType.BottomLeft, referView: view, size: CGSize(width: UIScreen.mainScreen().bounds.width, height: 44))
        
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
    
    // MARK: - ----------------------------- 设置导航栏 -----------------------------
    private func preperNav() {
    
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "关闭", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        
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
    
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendStatus() {
    
        print("发微博")
    }
    
    func inputEmoticon() {
    
        print("设置表情")
    }
    
    
    // MARK: - ----------------------------- 懒加载控件 -----------------------------
    private lazy var toolbar: UIToolbar = UIToolbar()
    
    // 站位标签
    private lazy var placeHolderLabel: UILabel = UILabel(textLabelColor: UIColor.lightGrayColor(), fontSize: 18)
    
    private lazy var textView: UITextView = {
    
        let tv = UITextView()
        
        tv.font = UIFont.systemFontOfSize(18)
        
        // 能够垂直拖拽
        tv.alwaysBounceVertical = true
        
        // 拖拽关闭键盘
        tv.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        
        return tv
    }()
    
}
