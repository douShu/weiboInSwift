//
//  PhotoCell.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/18.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
 
    lazy var imageView: UIImageView = UIImageView()
    lazy var scroolView = UIScrollView()
    lazy var screenBounds: CGRect = UIScreen.mainScreen().bounds
    lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    var imgURL: NSURL? {
    
        didSet {
            
            /// 还原scroolview的设置, 避免复用
            scroolView.contentSize = CGSizeZero
            scroolView.contentOffset = CGPointZero
            scroolView.contentInset = UIEdgeInsetsZero
            
            /// 转菊花
            indicator.startAnimating()
            
            imageView.image = nil
            
            imageView.sd_setImageWithURL(imgURL) { (image, error, _, _) -> Void in
                
                /// 停止菊花
                self.indicator.stopAnimating()
                
                if image == nil {
                
                    /// 设置站位图片
                    return
                }
                
                /// 设置image的位置
                let s = self.displaySize(self.imageView.image!)
                if s.height > self.screenBounds.height {
                
                    print(self.imageView)
                    
                    self.imageView.frame = CGRect(origin: CGPointZero, size: s)
                    self.scroolView.contentSize = s
                } else {
                
                    self.imageView.frame = CGRect(origin: CGPointZero, size: s)
                    self.imageView.center = self.scroolView.center
                }
            }
        }
    }
    
    
    // MARK: - ----------------------------- 设置图片大小 -----------------------------
    private func displaySize(image: UIImage) -> CGSize {
    
        var s = image.size
        
        s.height = s.height * screenBounds.width / s.width
        s.width = screenBounds.width
        
        return s
    }
    
    // MARK: - ----------------------------- 构造函数 -----------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
    
        contentView.addSubview(scroolView)
        scroolView.addSubview(imageView)
        contentView.addSubview(indicator)
        
        setupScroolView()
        setupIndicator()
    }
    
    private func setupIndicator() {
    
        indicator.center = scroolView.center
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: scroolView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
//        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: scroolView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
    }
    
    private func setupScroolView() {
        
        scroolView.delegate = self
        scroolView.minimumZoomScale = 0.5
        scroolView.maximumZoomScale = 2
        
        /// 设置约束
        scroolView.frame = screenBounds
//        let dict = ["sv": scroolView, "iv": imageView]
//        scroolView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[sv]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
//        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[sv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: dict))
    }
}

extension PhotoCell: UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        imageView.center = scrollView.center
    }
}