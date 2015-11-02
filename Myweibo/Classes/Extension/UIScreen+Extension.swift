//
//  UIScreen+Extension.swift
//  Myweibo
//
//  Created by mposthh on 15/11/2.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

extension UIScreen {
    
    class func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.width
    }
    
    class func height() -> CGFloat {
        return UIScreen.mainScreen().bounds.height
    }
}
