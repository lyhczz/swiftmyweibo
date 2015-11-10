//
//  YHPhotoBrowserCell.swift
//  Myweibo
//
//  Created by mposthh on 15/11/9.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHPhotoBrowserCell: UICollectionViewCell {
    
    // MARK: - 属性
    /// 要显示图片的url
    var url: NSURL? {
        didSet {
            // 判断url是否为空
            guard let imageUrl = url else {
                print("url为空")
                return
            }
            
            // 将imageView置空
            imageView.image = nil
//            // 布局scrollView
//            self.layoutIfNeeded()
            
            // 下载前显示菊花
            indicator.startAnimating()
            
            // 使用SDImage下载
            imageView.sd_setImageWithURL(imageUrl) { (image, error, _, _) -> Void in
                // 下载完成结束菊花
                self.indicator.stopAnimating()
                
                if error != nil {
                    print("下载大图出错\(error)")
                    return
                }
                // 下载完成
//                print("下载图片完成")
                self.layoutImageView(image)

            }
        }
    }
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    // MARK: - 内部方法
    /// 将图片等比例缩放
    private func displaySize(image: UIImage) -> CGSize {
        let newWith = scrollView.bounds.width
        let newHeight = newWith * image.size.height / image.size.width
        return CGSize(width: newWith, height: newHeight)
    }
    
    /// 重写布局imageView
    private func layoutImageView(image: UIImage) {
        // 获得缩放后的大小
        let size = displaySize(image)
        // 判断长短图
        if size.height < scrollView.bounds.height {
            // y方向偏移
            let offsetY = (scrollView.bounds.height - size.height) * 0.5
            
            // 设置image的frame
            imageView.frame = CGRect(origin: CGPoint(x: 0, y: offsetY), size: size)
            
        } else {
            // 设置frame
            imageView.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        // 设置scrollView的偏移
        scrollView.contentSize = size
    }
    
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(indicator)
        
        // 添加约束
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView": scrollView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView": scrollView]))
        
        // 加载指示器
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        
    }

    // MARK: - 懒加载
    /// scrollView
    private lazy var scrollView = UIScrollView()
    
    // imageView
    private lazy var imageView = UIImageView()
    
    // 加载指示器
    private lazy var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
    
}
