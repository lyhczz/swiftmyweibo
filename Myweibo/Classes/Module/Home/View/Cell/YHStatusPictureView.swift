//
//  YHStatusPictureView.swift
//  Myweibo
//
//  Created by mposthh on 15/11/2.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

class YHStatusPictureView: UICollectionView {

    
    // MARK: - 属性
    // collectionView的布局
    private var pictureLayout = UICollectionViewFlowLayout()
    /// 微博模型
    var status: YHStatus? 
    
    // MARK: - 构造函数
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: pictureLayout)
     
    }
    
    /// 计算配图宽高
    func calcViewSize() -> CGSize {
        // 每个item的size
        let itemSize = CGSize(width: 90, height: 90)
        // 设置布局的size
        pictureLayout.itemSize = itemSize
        pictureLayout.minimumLineSpacing = 0
        pictureLayout.minimumInteritemSpacing = 0
        
        // item之间的间距
        let margin: CGFloat = 10
        
        // 最大列数
        let column = 3
        
        // 获得配图的数量
        let count = status?.pic_urls?.count ?? 0
        
        // 根据配图数量计算尺寸
        // 没有图片
        if count == 0 {
            return CGSizeZero
        }
        
        // 只有一张图片
        if count == 1 {
            let size = CGSize(width: 150, height: 120)
            pictureLayout.itemSize = size
            return size
        }
        
        // 超过一张图片,设置间距
        pictureLayout.minimumInteritemSpacing = margin
        pictureLayout.minimumLineSpacing = margin
        
        // 4张图片
        if count == 4 {
            let width = itemSize.width * 2 + margin
            return CGSize(width: width, height: width)
        }
        
        // 其他
        // 计算行数
        let row = (count + column - 1) / column
        
        // 宽度
        let width = itemSize.width * CGFloat(column) + margin * (CGFloat(column) - 1)
        
        // 高度
        let height = itemSize.width * CGFloat(row) + margin * (CGFloat(row) - 1)
        
        return CGSize(width: width, height: height)
    }
    
    
    
}
