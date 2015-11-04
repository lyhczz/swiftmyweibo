//
//  YHRefreshContro.swift
//  Myweibo
//
//  Created by mposthh on 15/11/3.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit

/// 箭头翻转值
private let refreshControlOffest: CGFloat = -60

class YHRefreshContro: UIRefreshControl {

    
    /// 箭头状态
    var rotateFlag = false
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init() {
        super.init()
        
        // 隐藏菊花
        tintColor = UIColor.clearColor()
        
        // 添加自定义控件
        addSubview(refreshView)
        
        // 添加约束
        refreshView.ff_AlignInner(type: ff_AlignType.CenterCenter, referView: self, size: refreshView.bounds.size)
    }
    
    // 覆盖父类的frame属性,实现didSet监听
    override var frame: CGRect {
        didSet {
//            print("frame:\(frame)")
            if frame.origin.y > 0 {
                return
            }
            
            // 判断是否正在刷新
            if refreshing {
                // 开始动画
                refreshView.starLoading()
            }
            
            
            // -60 < frame.origin.y < 0 箭头朝下
            if frame.origin.y > refreshControlOffest && rotateFlag {
                
                print("箭头向下")
                rotateFlag = false
                refreshView.rotateIcon(rotateFlag)
            } else if frame.origin.y < -60 && !rotateFlag { // 当frame.origin.y < -60 箭头朝上
                print("箭头向上")
                rotateFlag = true
                refreshView.rotateIcon(rotateFlag)
            }
        }
    }
    
    /// 重写父类的endRefreshing
    override func endRefreshing() {
        super.endRefreshing()
        
        refreshView.stopLoading()
        
    }
    // MARK: - 懒加载
    private lazy var refreshView: YHRefreshView = YHRefreshView.refreshView()
    
}





class YHRefreshView: UIView {
    
    // 从xib加载view
    class func refreshView() -> YHRefreshView {
        return NSBundle.mainBundle().loadNibNamed("YHRefreshView", owner: nil, options: nil).last as! YHRefreshView
    }
    /// 箭头
    @IBOutlet weak var tipIcon: UIImageView!
    /// 下拉刷新的提示界面
    @IBOutlet weak var tipView: YHRefreshView!
    /// 旋转视图
    @IBOutlet weak var loadingView: UIImageView!
    
    /**
    箭头旋转动画
    
    - parameter rotationFlag: false表示箭头朝下,true表示箭头朝上
    */
    func rotateIcon(rotationFlag: Bool) {
        UIView.animateWithDuration(0.25) { () -> Void in
            self.tipIcon.transform = rotationFlag ? CGAffineTransformMakeRotation(CGFloat(M_PI + 0.01)) : CGAffineTransformIdentity
        }
    }
    
    /**
    开始刷新动画
    */
    func starLoading() {
        // 隐藏tipView
        tipView.hidden = true
        
        let animKey = "animKey"
        
        if let _ = loadingView.layer.animationForKey(animKey) {
            return
        }
        
        // 创建动画
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.duration = 0.25
        anim.toValue = M_PI * 2
        anim.repeatCount = MAXFLOAT
        anim.removedOnCompletion = false
        
        // 开始动画
        loadingView.layer.addAnimation(anim, forKey: animKey)
    }
    
    /**
    结束刷新动画
    */
    func stopLoading() {
        // 显示下拉提示
        tipView.hidden = false
        
        // 停止动画
        loadingView.layer.removeAllAnimations()
    }
    
}






