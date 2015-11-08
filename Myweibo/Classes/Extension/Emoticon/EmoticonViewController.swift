//
//  EmoticonViewController.swift
//  表情键盘
//
//  Created by mposthh on 15/11/6.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class EmoticonViewController: UIViewController {

    /// 重用标识
    let collectonViewCellIdentifier = "collectonViewCellIdentifier"
    
    /// 记录选中的按钮
    private var selectedButton: UIButton?
    
    /// 按钮起始tag
    private let baseTag = 1000
    
    /// textView
    weak var textView: UITextView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
    }

    // MARK: - 准备UI
    private func prepareUI() {
        
        // 1.添加子控件
        view.addSubview(toolBar)
        view.addSubview(collectionView)
        
        // 2.添加约束
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        let viewDict = ["cv": collectionView, "tb": toolBar]
        
        // 水平方向
        // collectionView 左右两边和父控件对齐
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[cv]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        
        // toolBar 左右两边和父控件对齐
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        
        // 垂直方向
        // collectionView顶部和父控件重合,collectionView底部和toolBar顶部重合,toolBar高44,toolBar底部和父控件底部重合
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cv]-0-[tb(44)]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewDict))
        
        // 设置toolBar
        setupToolBar()
        
        // 设置collectionView
        setupCollectionView()
    }
    
    /// 设置toolBar
    private func setupToolBar() {
        // items数组
        var items = [UIBarButtonItem]()
        
        // 记录按钮索引
        var index = 0
        
        // 创建item
        for package in packages {
            let button = UIButton()
            // 设置title
            let name = package.group_name_cn
            button.setTitle(name, forState: UIControlState.Normal)
            
            // 设置颜色
            button.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Highlighted)
            button.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Selected)
            
            // 添加点击事件
            button.addTarget(self, action: "itemClick:", forControlEvents: UIControlEvents.TouchUpInside)
            // 添加tag确定是哪个按钮
            button.tag = index + baseTag
            
            // 默认第一个按钮为选中状态
            if index == 0 {
                switchSelectedButton(button)
            }
            
            // 设置大小
            button.sizeToFit()
            
            // 创建item
            let item = UIBarButtonItem(customView: button)
            
            items.append(item)
            
            // 添加弹簧
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
            index++
            
        }
        // 移除最后一根弹簧
        items.removeLast()
        // 设置items
        toolBar.items = items
    }
    
    /// 设置collectionView
    private func setupCollectionView() {
        // 注册cell
        collectionView.registerClass(YHEmoticonCell.self, forCellWithReuseIdentifier: collectonViewCellIdentifier)
        // 设置数据源
        collectionView.dataSource = self
        // 设置代理
        collectionView.delegate = self
        // 设置颜色
        collectionView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - 按钮点击事件
    /// toolBar按钮点击事件
    func itemClick(button: UIButton) {
        // 获取相应的section
        let indexPath = NSIndexPath(forItem: 0, inSection: button.tag - baseTag)
        // 切换collectionView显示的section
        collectionView.selectItemAtIndexPath(indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.Left)
        // 改变选中状态
        switchSelectedButton(button)
    }
    
    
    
    
    /**
    切换选中的按钮
    - parameter button: 要选中的按钮
    */
    private func switchSelectedButton(button: UIButton) {
        // 设置当前选中的按钮为normal状态
        selectedButton?.selected = false
        
        // 切换选中的按钮
        button.selected = true
        
        // 设置传入的按钮为选中
        selectedButton = button
        
    }
    
    // MARK: - 懒加载
    /// toolBar
    private lazy var toolBar = UIToolbar()
    
    /// collectionView
    private lazy var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: YHEmoticonLayout())
    
    /// 表情包数据
    private lazy var packages = YHEmoticonPackage.packages
}

// MARK: - 扩展 CZEmoticonViewController 实现 UICollectionViewDataSource UICollectionViewDelegate 协议
extension EmoticonViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 返回组的数量
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return packages.count
    }
    
    // 返回cell的数量
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return packages[section].emoticons!.count
    }
    
    // 返回cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(collectonViewCellIdentifier, forIndexPath: indexPath) as! YHEmoticonCell
        // 赋值
        cell.emoticon = packages[indexPath.section].emoticons![indexPath.item]
        
        return cell
    }
    
    // 监听collectionView停止滚动
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // 获取正在显示的section
        let indexPath = collectionView.indexPathsForVisibleItems().first
        let section = indexPath!.section
        // 获取对应的按钮
        let button = toolBar.viewWithTag(section + baseTag) as! UIButton
        
        // 设置高亮状态
        switchSelectedButton(button)
    }
    
    // 监听cell的点击
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 获取点击的表情模型
        let emoticon = packages[indexPath.section].emoticons![indexPath.item]
        // 插入表情
        textView?.insertEmoticon(emoticon)
        
        // 添加到最近表情
        if indexPath.section != 0 {
            YHEmoticonPackage.addFavorate(emoticon)
        }
    }
}

// MARK: - 自定义cell
/// 表情既有图片也有文字.使用按钮
class YHEmoticonCell: UICollectionViewCell {
    
    
    /// 表情模型
    var emoticon: YHEmoticon? {
        didSet {
            // 判断是否有表情图片
            if emoticon?.pngPath != nil {
                // 设置按钮图片
                emoticonButton.setImage(UIImage(contentsOfFile: emoticon!.pngPath!), forState: UIControlState.Normal)
            } else {
                // 没有图片要清空
                emoticonButton.setImage(nil, forState: UIControlState.Normal)
            }
            
            // 设置emji表情
            emoticonButton.setTitle(emoticon?.emoji, forState: UIControlState.Normal)
            
            // 判断是否是删除按钮
            if emoticon!.removeEmoticon {
                emoticonButton.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
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
    
    
    // MARK: - 准备UI
    private func prepareUI() {
        // 添加子控件
        contentView.addSubview(emoticonButton)
        
        // 设置大小
        emoticonButton.frame = CGRectInset(bounds, 4, 4)
//        emoticonButton.backgroundColor = UIColor.redColor()
        // 设置字体
        emoticonButton.titleLabel?.font = UIFont.systemFontOfSize(32)
        
        // 禁止用户交互
        emoticonButton.userInteractionEnabled = false
    }
    
    // MARK: - 懒加载
    /// 用于显示表情的按钮
    private lazy var emoticonButton = UIButton()
    
}




// MARK: - 自定义 UICollectionViewFlowLayout
class YHEmoticonLayout: UICollectionViewFlowLayout {
    
    // 当collectionview布局之前调用
    override func prepareLayout() {
        super.prepareLayout()
        
        let width = collectionView!.frame.width / 7.0
        let height = collectionView!.frame.height / 3.0
        
        // 设置itemSize
        itemSize = CGSize(width: width, height: height)
        
        // 设置间距
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        
        // 设置分页
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        
        // 滚动方向
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        // 取消回弹效果
        collectionView?.bounces = false
    }
}





