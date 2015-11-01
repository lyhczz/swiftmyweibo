//
//  UILabel+Extension.swift
//  Myweibo
//
//  Created by mposthh on 15/11/1.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(textColor:UIColor,fontSize:CGFloat) {
        self.init()
        self.textColor = textColor
        self.font = UIFont.systemFontOfSize(fontSize)
    }
    
}