//
//  UIButton+Extension.swift
//  Myweibo
//
//  Created by mposthh on 15/11/1.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, fontSize: CGFloat, textColor: UIColor, imageName: String) {
        self.init()
        // 文字内容
        setTitle(title, forState: UIControlState.Normal)
        // 文字大小
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        // 文字颜色
        setTitleColor(textColor, forState: UIControlState.Normal)
        // 图片
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
    }
}