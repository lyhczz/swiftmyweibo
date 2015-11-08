//
//  YHPhotoSelectorViewController.swift
//  照片选择器
//
//  Created by mposthh on 15/11/8.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHPhotoSelectorViewController: UICollectionViewController, YHPhotoSelectorCellDelegate {

    // MARK: - 属性
    /// 照片数组
    var photos = [UIImage]()
    
    /// 最多选择照片数
    private let maxPhotoCount = 6
    
    /// 当前点击的cell的indexpath
    private var currentIndexPath: NSIndexPath?
    
    /// collectionView 的 布局
    private var layout = UICollectionViewFlowLayout()
    
    ///photoSeletorCell重用标识
    private let photoSeletorCellReuseIdentifier = "photoSeletorCellReuseIdentifier"
    
    // MARK: -  构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    init() {
        super.init(collectionViewLayout: layout)
    }
    
    // MARK: - UI相关方法
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareCollectionView()
    }
    private func prepareCollectionView() {
     
        // 注册cell
        collectionView?.registerClass(YHPhotoSelectorCell.self, forCellWithReuseIdentifier: photoSeletorCellReuseIdentifier)
        
        // 设置背景
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        // 设置itemSize
        layout.itemSize = CGSize(width: 80, height: 80)
        
        // 设置每组的间距
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    // MARK: - CollectionView数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count < maxPhotoCount ? photos.count + 1 : photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(photoSeletorCellReuseIdentifier, forIndexPath: indexPath) as! YHPhotoSelectorCell
        
        cell.backgroundColor = UIColor.brownColor()
        
        // 设置代理
        cell.cellDelegate = self
        // 设置图片
        if indexPath.item < photos.count {
            cell.image = photos[indexPath.item]
        } else {
            cell.image = nil
        }
        return cell
    }
    
    // MARK: - YHPhotoSelectorCellDelegate代理方法
    func photoSelectorCellAddPhoto(cell: YHPhotoSelectorCell) {
        print(__FUNCTION__)
        
        // 判断用户是否同意访问相册
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            print("用户不允许访问相册")
            return
        }
        
        // 弹出相册
        let picker = UIImagePickerController()
        // 设置代理
        picker.delegate = self
        
        // 记录当前的indexpath
        currentIndexPath = collectionView?.indexPathForCell(cell)
        
        // 消失
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func photoSelectorCellRemovePhoto(cell: YHPhotoSelectorCell) {
        print(__FUNCTION__)
        // 获得cell的index
        if let indexPath = collectionView?.indexPathForCell(cell) {
            // 删除对应的照片
            photos.removeAtIndex(indexPath.item)
            
            // 刷新数据
            collectionView?.reloadData()
        }
    }
}

// MARK: - 扩展 CZPhotoSelectorViewController 实现 UIImagePickerControllerDelegate 协议
extension YHPhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // key: UIImagePickerControllerOriginalImage
        let image = (info[UIImagePickerControllerOriginalImage] as! UIImage).scaleImage()
        
        // 判断当前点击的是什么cell
        if currentIndexPath?.item == photos.count {
            // 添加到照片数组
            photos.append(image)
        } else {
            // 替换照片
            photos[currentIndexPath!.item] = image
        }
        
        // 刷新界面
        collectionView?.reloadData()
        
        // 关闭相册控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}


// MARK: - cell的点击事件代理
protocol YHPhotoSelectorCellDelegate: NSObjectProtocol {
    
    /// 加号按钮点击事件
    func photoSelectorCellAddPhoto(cell: YHPhotoSelectorCell)
    
    /// 删除按钮点击事件
    func photoSelectorCellRemovePhoto(cell: YHPhotoSelectorCell)
}


// MARK: - 自定义cell
class YHPhotoSelectorCell: UICollectionViewCell {
    
    /// 代理
    weak var cellDelegate: YHPhotoSelectorCellDelegate?
    
    /// 要显示的图片
    var image: UIImage? {
        didSet {
            // image == nil 说明是加号按钮
            if image == nil {
                addButton.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
                addButton.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
            } else {
                addButton.setImage(image, forState: UIControlState.Normal)
                addButton.setImage(image, forState: UIControlState.Highlighted)
            }
            
            // 如果是最后一个按钮不需要显示删除按钮
            removeButton.hidden = image == nil
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
        contentView.addSubview(addButton)
        contentView.addSubview(removeButton)
        
        // 添加约束
        let viewsDict = ["ab": addButton, "rb": removeButton]
        addButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        // add按钮
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[ab]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
        // remove按钮
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[rb]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[rb]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDict))
        
    }

    
    // MARK: - 懒加载控件
    /// 加号按钮
    private lazy var addButton: UIButton = {
        let button = UIButton()
        // 设置图片
        button.setImage(UIImage(named: "compose_pic_add"), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "compose_pic_add_highlighted"), forState: UIControlState.Highlighted)
        // 设置image显示模式
        button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        // 添加点击事件
        button.addTarget(self, action: "addButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    /// 删除按钮
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        // 设置图片
        button.setImage(UIImage(named: "compose_photo_close"), forState: UIControlState.Normal)
        // 添加点击事件
        button.addTarget(self, action: "removeButtonClick", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    // MARK: - 按钮点击事件
    /// 加号按钮点击事件
    func addButtonClick() {
        cellDelegate?.photoSelectorCellAddPhoto(self)
    }
    
    /// 删除按钮点击事件
    func removeButtonClick() {
        cellDelegate?.photoSelectorCellRemovePhoto(self)
    }
}






