//
//  YHPhotoBrowserViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/11/8.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHPhotoBrowserViewController: UIViewController {

    // MARK: - 属性
    // cell的重用标识
    let YHPhotoBrowserViewCellIdentifier = "YHPhotoBrowserViewCellIdentifier"
    
    /// 要显示大图的urls数组
    private var urls: [NSURL]
    
    /// indexPath
    var indexPath: NSIndexPath
    
    /// 流水布局
    private var layout = UICollectionViewFlowLayout()
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init(urls: [NSURL], indexPath: NSIndexPath) {
        self.urls = urls
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }

    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame.size.width += 15
        
        prepareUI()
        
        pageLabel.text = "\(indexPath.item + 1) / \(urls.count)"
    }
    
    
    // MAKR: - 按钮点击事件
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save() {
        
    }
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        view.addSubview(collectionView)
        view.addSubview(pageLabel)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        // 添加按钮点击事件
        closeButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
        
        // 设置约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        pageLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        let viewDict = ["cv": collectionView, "pl": pageLabel, "cb": closeButton, "sb": saveButton]
        
        // collectionView填充父控件
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        collectionView.frame = view.bounds
        
        // pageLabel
        // 水平居中
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        // 距离顶部20
        view.addConstraint(NSLayoutConstraint(item: pageLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20))
        
        // 关闭和保存按钮
        // v
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[sb(35)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        // h
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[cb(75)]-(>=0)-[sb(75)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        
        prepareCollectionView()
    }
    
    /// 准备CollectionView
    private func prepareCollectionView() {
        // 注册cell
        collectionView.registerClass(YHPhotoBrowserCell.self, forCellWithReuseIdentifier: YHPhotoBrowserViewCellIdentifier)
        
        // itemSize 
        layout.itemSize = view.bounds.size
        
        // 滚动方法
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 间距
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        // 分页显示
        collectionView.pagingEnabled = true
        
        // 设置数据源和代理
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    // MARK: - 懒加载控件
    /// collectionView
    private lazy var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layout)
    
    /// 关闭按钮
    private lazy var closeButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "关闭", titleColor: UIColor.whiteColor(), fontSzie: 12)
    /// 保存按钮
    private lazy var saveButton: UIButton = UIButton(bkgImageName: "health_button_orange_line", title: "保存", titleColor: UIColor.whiteColor(), fontSzie: 12)
    
    /// 页码标签
    private lazy var pageLabel: UILabel = UILabel(textColor: UIColor.whiteColor(), fontSize: 15)
    
}

// MARK: - 扩展
extension YHPhotoBrowserViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    // 返回cell的数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urls.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(YHPhotoBrowserViewCellIdentifier, forIndexPath: indexPath) as! YHPhotoBrowserCell
        // 获得对应的url
        let url = urls[indexPath.item]
        // 赋值给cell
        cell.url = url
        
//        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
    
    // 监听cell的停止滚动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if let indexPath = collectionView.indexPathsForVisibleItems().first {
            
            // 设置给当前的cell的属性
            self.indexPath = indexPath
            
            // 设置页码
            self.pageLabel.text = "\(indexPath.item + 1) / \(urls.count)"
        }
    }
}




