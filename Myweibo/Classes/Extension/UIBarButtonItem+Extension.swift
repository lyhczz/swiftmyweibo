//
//  UIBarButtonItem+Extension.swift
//  Myweibo
//
//  Created by mposthh on 15/10/31.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    /// 带图片的barButton
    convenience init(imageName: String) {
        let button = UIButton()
        
        button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        button.setImage(UIImage(named: "\(imageName)_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        
        self.init(customView:button)
    }
}
