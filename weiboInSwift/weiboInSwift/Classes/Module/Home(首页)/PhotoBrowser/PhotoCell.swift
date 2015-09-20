//
//  PhotoCell.swift
//  weiboInSwift
//
//  Created by 逗叔 on 15/9/18.
//  Copyright © 2015年 逗叔. All rights reserved.
//

import UIKit
import SDWebImage

@objc protocol PhotoCellDelegate: NSObjectProtocol {

    /// 缩放比例
    optional func photoCellZoom(scale: CGFloat)
    
    /// 结束缩放
    optional func photoCellEndZoom()
}

class PhotoCell: UICollectionViewCell {
 
    var photoDelegate: PhotoCellDelegate?
    lazy var imageView: UIImageView = UIImageView()
    lazy var scroolView = UIScrollView()
    lazy var screenBounds: CGRect = UIScreen.mainScreen().bounds
    lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    var imgURL: NSURL? {
    
        didSet {
            
            /// 1> 还原scroolview的设置, 避免复用
            imageView.transform = CGAffineTransformIdentity
            scroolView.contentSize = CGSizeZero
            scroolView.contentOffset = CGPointZero
            scroolView.contentInset = UIEdgeInsetsZero
            
            /// 2> 转菊花
            indicator.startAnimating()
            
            imageView.image = nil
            
            /// 3> 加载图片
            imageView.sd_setImageWithURL(imgURL) { (image, error, _, _) -> Void in
                
                /// 停止菊花
                self.indicator.stopAnimating()
                
                if image == nil {
                
                    /// 设置站位图片
                    return
                }
                
                /// 设置image的位置
                let s = self.displaySize(self.imageView.image!)
                if s.height < self.scroolView.bounds.height {
                    // 垂直居中
                    let y = (self.scroolView.bounds.height - s.height) * 0.5
                    self.imageView.frame = CGRect(origin: CGPointZero, size: s)
                    // 设置间距，能够保证缩放完成后，同样能够显示完整画面
                    self.scroolView.contentInset = UIEdgeInsets(top: y, left: 0, bottom: y, right: 0)
                } else {
                    // 长图
                    self.imageView.frame = CGRect(origin: CGPointZero, size: s)
                    // contentSize
                    self.scroolView.contentSize = s
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
    }
    
    private func setupScroolView() {
        
        scroolView.delegate = self
        scroolView.minimumZoomScale = 0.5
        scroolView.maximumZoomScale = 2
        
        /// 设置约束
        scroolView.frame = screenBounds
    }
}

extension PhotoCell: UIScrollViewDelegate {

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        photoDelegate?.photoCellZoom!(imageView.transform.a)
        
        // 重新计算间距
        // 通过 transform 改变view的缩放，bound本身没有变化，frame会变化
        var offsetX = (scrollView.bounds.width - imageView.frame.width) * 0.56
        // 如果边距小于0，需要修正
        offsetX = offsetX < 0 ? 0 : offsetX
        
        var offsetY = (scrollView.bounds.height - imageView.frame.height) * 0.5
        offsetY = offsetY < 0 ? 0 : offsetY
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: 0, right: 0)

    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        photoDelegate?.photoCellEndZoom!()
    }
}