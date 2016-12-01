//
//  ZPSplashScreenDataManager.swift
//  ZPNewsLaunchDemo
//
//  Created by yueru on 2016/11/30.
//  Copyright © 2016年 yueru. All rights reserved.
//

import UIKit
import SDWebImage

let adImageName = "adImageName";
let adUrl = "adImageUrl";
let adDeadline = "adDeadline";
let PushNSNotificationCenter = "tapAction"

class ZPSplashScreenDataManager: NSObject {
    
    static private(set) var downImage: UIImage?
    static let imageArray = ["http://img1.126.net/channel6/2016/022471/0805/2.jpg?dpi=6401136", "http://image.woshipm.com/wp-files/2016/08/555670852352118156.jpg"]
    static let imgLinkUrl = "http://www.jianshu.com/users/e4c63b354a77/latest_articles"
    static let imageDeadLone = "2016/12/30 18:25"
    
    static let imageUrl = imageArray[1]
    
    
    
    class func getAdvertisingImage() -> UIImage? {
        let path = UserDefaults.standard.value(forKey: adImageName) as? String
        if path == imageUrl {
            return SDImageCache.shared().imageFromDiskCache(forKey: path)
        }
        return nil
    }
    
    /// 初始化广告页
    class func downloadAdvertisingImage() {
        
        
        //如果已经存储过图片则直接加载图片
        
        let path = UserDefaults.standard.value(forKey: adImageName) as? String
        if path != imageUrl {
            guard let url = URL(string: imageUrl) else {
                return
            }
            //移除以前存的图片
            SDImageCache.shared().removeImage(forKey: imageUrl, fromDisk: true)
            //下载图片
            SDWebImageManager.shared().downloadImage(with: url, options: .retryFailed, progress: { (_, _) in
                
            }, completed: { (_, _, _, _, _) in
                
            })
            //存储图片为了标志已经下载过 下次就可以使用
            UserDefaults.standard.set(imageUrl, forKey: adImageName)
            UserDefaults.standard.set(imgLinkUrl, forKey: adUrl)
            UserDefaults.standard.set(imageDeadLone, forKey: adDeadline)
        }
    }
    
}
