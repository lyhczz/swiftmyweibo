//
//  UIImage+Extension.swift
//  照片选择器
//
//  Created by mposthh on 15/11/8.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

extension UIImage {
 
    func scaleImage() -> UIImage {
        let newWigth: CGFloat = 300
        
        if size.width < newWigth {
            return self
        }
        
        // 等比例缩放
        let newHeight = newWigth * size.height / size.width
        let newSize = CGSize(width: newWigth, height: newHeight)
        
        // 开启上下文
        UIGraphicsBeginImageContext(newSize)
        
        // 绘图
        drawInRect(CGRect(origin: CGPointZero, size: newSize))
        
        // 获取新的图片
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 关闭上下文
        UIGraphicsEndImageContext()
        
        // 返回
        return newImage
    }
}
