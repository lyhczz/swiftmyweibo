//
//  UITextView+Emoticon.swift
//  表情键盘
//
//  Created by mposthh on 15/11/7.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

extension UITextView {
    
    /**
    获取带表情图片的文本字符串
    - returns: 带表情图片的文本字符串
    */
    func emoticonText() -> String {
        
        var strM = ""
        
        // 遍历获取属性文本里面的每一段,将每一段拼接起来
        attributedText.enumerateAttributesInRange(NSRange(location: 0, length: attributedText.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            
            // 判断是否带有附件
            if let attachment = dict["NSAttachment"] as? YHTextAttachment {
                // 获取表情的名称
                strM += attachment.name!
            } else {
                // 普通文本 直接截取
                let str = (self.attributedText.string as NSString).substringWithRange(range)
                strM += str
            }
        }
        return strM
    }
    
    
    /**
    插入表情
    - parameter emoticon: 表情模型
    */
    func insertEmoticon(emoticon: YHEmoticon) {
        
        // 插入emoji
        if let emoji = emoticon.emoji {
            insertText(emoji)
        }
        
        // 插入表情文本
        if let pngPath = emoticon.pngPath {
            // 附件
            let attachment = YHTextAttachment()
            attachment.image = UIImage(contentsOfFile: pngPath)
            // 保存表情传输的名字
            attachment.name = emoticon.chs
            
            // 获取文本的高度
            let lineHeght = font?.lineHeight ?? 10
            // 设置附件的大小
            attachment.bounds = CGRect(x: 0, y: -4, width: lineHeght, height: lineHeght)
            
            // 创建带附件的属性文本
            let attrString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            attrString.addAttribute(NSFontAttributeName, value: self.font!, range: NSRange(location: 0, length: 1))
            
            // 获取textView现有的文本
            let attrStringM = NSMutableAttributedString(attributedString: self.attributedText)
            // 记录当前的光标位置
            let selectedRange = self.selectedRange
            
            
            // 替换
            attrStringM.replaceCharactersInRange(self.selectedRange, withAttributedString: attrString)
            // 设置文本
            attributedText = attrStringM
            
            // 设置光标位置
            self.selectedRange = NSRange(location: selectedRange.location + 1, length: 0)
            // 主动调用 textViewDidChange
            delegate?.textViewDidChange!(self)
            // 主动发送 UITextViewTextDidChangeNotification 通知
            NSNotificationCenter.defaultCenter().postNotificationName(UITextViewTextDidChangeNotification, object: self)
        }
        
        // 如果是删除按钮,删除文字
        if emoticon.removeEmoticon {
            deleteBackward()
        }
    }
}
