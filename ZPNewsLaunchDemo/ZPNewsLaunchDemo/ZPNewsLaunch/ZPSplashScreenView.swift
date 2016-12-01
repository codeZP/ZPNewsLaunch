//
//  ZPSplashScreenView.swift
//  ZPNewsLaunchDemo
//
//  Created by yueru on 2016/11/30.
//  Copyright © 2016年 yueru. All rights reserved.
//

import UIKit

class ZPSplashScreenView: UIView {

    //MARK: - 外部的接口
    /// 广告显示的时间
    var showTime = 0
    /// 图片
    var image: UIImage? {
        didSet {
            if image != nil {
                adImageView?.image = image
            }
        }
    }
    /// 图片对应的url地址
    var imageLinkUrl: String?
    ///广告的有效时间
    var imageDeadLine: String?
    
    /// 展示广告
    func showSplashScreen(withTime showTime: Int) {
        self.showTime = showTime
        countButton?.setTitle("跳过\(showTime)", for: .normal)
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy/MM/dd HH:mm"
        //获取当前时间
        let currentDayStr = dateFmt.string(from: Date())
        let currentDate = dateFmt.date(from: currentDayStr)
        var deadLineDate: Date?
        
        if let imageDeadLine = imageDeadLine {
            //广告的时间
            deadLineDate = dateFmt.date(from: imageDeadLine)
        }else {
            deadLineDate = dateFmt.date(from: currentDayStr)
        }
        let result = deadLineDate?.compare(currentDate!)
        if result == .orderedAscending {
            dismiss()
        }else {
            startTimer()
            let window = UIApplication.shared.delegate!.window!
            window?.isHidden = false
            window?.addSubview(self)
        }
    }
    
    //MARK: - 内部使用
    private var adImageView: UIImageView?
    private var countButton: UIButton?
    private var count = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        adImageView = UIImageView(frame: frame)
        adImageView?.isUserInteractionEnabled = true
        adImageView?.contentMode = .scaleAspectFit
        adImageView?.clipsToBounds = true
        adImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushToAdVC)))
        
        countButton = UIButton(type: .custom)
        countButton?.frame = CGRect(x: UIScreen.main.bounds.width - 84, y: 30, width: 60, height: 30)
        countButton?.addTarget(self, action: #selector(dismiss), for: .touchDragInside)
        countButton?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        countButton?.setTitleColor(UIColor.white, for: .normal)
        countButton?.backgroundColor = UIColor(colorLiteralRed: 38 / 255.0, green: 38 / 255.0, blue: 38 / 255.0, alpha: 0.6)
        countButton?.layer.cornerRadius = 5
        
        addSubview(adImageView!)
        addSubview(countButton!)
        
    }
    
    private func startTimer() {
        count = showTime
        RunLoop.main.add(countTime!, forMode: .commonModes)
    }
    
    /// 定时器调用事件
    @objc private func countDown() {
        count = count - 1
        countButton?.setTitle("跳过\(count)", for: .normal)
        if count == 0 {
            dismiss()
        }
    }
    @objc private func pushToAdVC() {
        dismiss()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: PushNSNotificationCenter), object: imageLinkUrl)
    }
    
    
    /// 移除广告也
    @objc private func dismiss() {
        countTime?.invalidate()
        countTime = nil
        UIView.animate(withDuration: 0.25, animations: { 
            self.alpha = 0.0
            }) { (_) in
                self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //AMRK: - 懒加载
    private lazy var countTime: Timer? = {
        let time = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        return time
    }()
    
    
    
    
}
