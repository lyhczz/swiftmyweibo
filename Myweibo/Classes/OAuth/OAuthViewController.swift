//
//  OAuthViewController.swift
//  Myweibo
//
//  Created by mposthh on 15/10/28.
//  Copyright © 2015年 mposhh. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "新浪微博"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        
        // 加载授权地址
        let request = NSURLRequest(URL: Networktools.shareInstance.oauthUrl())
        webView.loadRequest(request)
        
    }
    /// 关闭
    func close() {
        SVProgressHUD.dismiss()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 将控制器的View设置为webView
    override func loadView() {
        view = webView
        webView.delegate = self;
        
    }

    // MARK: - 懒加载
    var webView = UIWebView()
}

// MARK: - OAuthViewController 扩展实现 UIWebViewDelegate 方法
extension OAuthViewController:UIWebViewDelegate {
    
    // 开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.showWithStatus("正在加载")
    }
    // 完成加载网页
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 取消 https://www.baidu.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330 
        // 授权 https://www.baidu.com/?code=2d6b841097f68ac92205d54582cf7c39
        
        let urlStr = request.URL!.absoluteString
        
        // 判断是否为回调地址
        if !(urlStr.hasPrefix(Networktools.shareInstance.redirect_uri)) {
           return true
        }
        
        // 判断后面是否跟参数
        if let query = request.URL?.query {
            let nsQuery = query as NSString
            let codeStr = "code="
            print("query:\(query)")
            if nsQuery.hasPrefix(codeStr) {
                
                let code = nsQuery.substringFromIndex(codeStr.characters.count)
                print("code:\(code)")
                // 发送code
                loadAccessToken(code)
                
                
            } else {
                close()
                
            }
        }
        return false
    }
    
    /**
    利用网络单例加载access token
    
    - parameter code: code
    */
    func loadAccessToken(code:String) {
        Networktools.shareInstance.loadAccessToken(code) { (result, error) -> () in
            
            if error != nil || result == nil {
                // 提示授权失败
                SVProgressHUD.showErrorWithStatus("授权失败")
                // 1秒后关闭提示框
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), { () -> Void in
                    self.close()
                })
                return
            }
            
            print("result:\(result)")
            // 字典转模型
            let account = YHUserAccount(dict: result!)
            print("account:\(account)")
            
        }
    }
}







