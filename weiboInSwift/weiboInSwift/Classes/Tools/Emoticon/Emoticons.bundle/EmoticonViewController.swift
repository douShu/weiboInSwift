//
//  EmoticonViewController.swift
//  EmoticonsKeyboard
//
//  Created by 逗叔 on 15/9/15.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit

/// cell的标识符
let DSCollectionCellID = "DSCollectionCellID"

class EmoticonViewController: UIViewController {
    
    // MARK: - ----------------------------- 数据 -----------------------------
    private lazy var emoticonPackages = EmoticonPackage.loadPackages()
    
    /// 回调闭包: 将选中的表情传递给textView
    var selectedEmoticonCallBack: (emoticon: Emoticon) -> ()

    
    // MARK: - ----------------------------- 构造函数 -----------------------------
    init(finished: (emoticon: Emoticon) -> ()) {
    
        /// 回调闭包初始化
        selectedEmoticonCallBack = finished
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置UI
        setupUI()
    }
    
    
    // MARK: - ----------------------------- 设置UI界面 -----------------------------
    private func setupUI() {
    
        /// 添加控件
        view.addSubview(toolbar)
        view.addSubview(collectionView)
        
        /// 设置约束
        let subviewsDict = ["cv": collectionView, "tb": toolbar]
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: subviewsDict))
        view.addConstraint(NSLayoutConstraint(item: toolbar, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 44))
        view.addConstraint(NSLayoutConstraint(item: toolbar, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: subviewsDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-[tb]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: subviewsDict))
        
        // 设置表情栏和视图 
        setupToolbar()
        setupCollectionView()
    }

    
    // MARK: - ----------------------------- 设置表情栏和视图 -----------------------------
    private func setupToolbar() {
        
        // 设置toolbar上面控件的颜色
        toolbar.tintColor = UIColor.darkGrayColor()
        
        var items = [UIBarButtonItem]()
        let itemArry = emoticonPackages
        
        /// item 的tag标记
        var index = 0
        for itemName in itemArry {
        
            let item = UIBarButtonItem(title: itemName.groupName, style: UIBarButtonItemStyle.Plain, target: self, action: "clickItemBtn:")
            
            items.append(item)
            items.last?.tag = index
            index++
            
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        
        items.removeLast()
        toolbar.items = items
    }
    
    private func setupCollectionView() {
    
        // 注册cell
        collectionView.registerClass(DSCollectionCell.self, forCellWithReuseIdentifier: DSCollectionCellID)
        
        /// 设置数据源
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.whiteColor()
    }
    
    
    // MARK: - ----------------------------- 监听表情栏 -----------------------------
    func clickItemBtn(item: UIBarButtonItem) {
    
        let indexPath = NSIndexPath(forItem: 0, inSection: item.tag)
        
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
    }
    
    // MARK: - ----------------------------- 懒加载属性 -----------------------------
    /// 表情栏
    lazy var toolbar: UIToolbar = UIToolbar()

    /// 表情视图集合
    lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: DSLayout())
    
    private class DSLayout: UICollectionViewFlowLayout {
    
        private override func prepareLayout() {
            
            minimumInteritemSpacing = 0
            minimumLineSpacing = 0
            scrollDirection = UICollectionViewScrollDirection.Horizontal
            collectionView?.pagingEnabled = true
            collectionView?.showsHorizontalScrollIndicator = false
            
            let w = collectionView!.bounds.width / 7.0
            itemSize = CGSize(width: w, height: w)
            
            // let y: CGFloat = ((collectionView?.bounds.height)! - 3 * w) / 0.49999
            // sectionInset = UIEdgeInsets(top: y, left: 0, bottom: 0, right: y)
        }
    }
}



// MARK: - ----------------------------- collectionView的数据源和代理方法 -----------------------------
extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    /// delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let emoticon = emoticonPackages[indexPath.section].emoticons![indexPath.item]
        
        selectedEmoticonCallBack(emoticon: emoticon)
    }
    /// 组
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return emoticonPackages.count
    }
    
    /// 每组多少个cell
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emoticonPackages[section].emoticons!.count
    }
    
    /// 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DSCollectionCellID, forIndexPath: indexPath) as! DSCollectionCell
        
        cell.emoticon = emoticonPackages[indexPath.section].emoticons![indexPath.row]
        
        return cell
    }
}


// MARK: - ----------------------------- 自定义cell -----------------------------
class DSCollectionCell: UICollectionViewCell {

    
    // MARK: - ----------------------------- 属性 -----------------------------
    /// 表情模型
    var emoticon: Emoticon? {
    
        didSet {
            
            /// 如果找不到图片， 会将图片清空
            emoticanBtn.setImage(UIImage(contentsOfFile: emoticon!.imgPath), forState: UIControlState.Normal)
            
            emoticanBtn.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            
            /// 添加删除按钮
            if emoticon!.removeEmoticon {
            
                emoticanBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emoticanBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
            }
        }
    }
    
    
    // MARK: - ----------------------------- 懒加载属性 -----------------------------
    lazy var emoticanBtn: UIButton = UIButton()
    
    
    // MARK: - ----------------------------- 构造函数 -----------------------------
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        emoticanBtn.frame = CGRectInset(bounds, 4, 4)
        
        emoticanBtn.userInteractionEnabled = false
        
        /// 设置字体大小, 以保证emoji的大小
        emoticanBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
        
        addSubview(emoticanBtn)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}