//
//  UIButton+ZTExtension.swift
//  ZTCategories
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 shang. All rights reserved.
//

import UIKit

// 增加按钮点击热区
// 使用方法 testButton.touchExtendInset = UIEdgeInsets.init(top: -20, left: -20, bottom: -20, right: -20)
extension UIButton {
    
    private  dynamic class func swizzle( targetClass: AnyClass, orig: Selector, new: Selector) {
        let origMethod  = class_getInstanceMethod(targetClass, orig)
        let newMethod   = class_getInstanceMethod(targetClass, new)
        
        let hasAdd = class_addMethod(targetClass, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
        if  hasAdd {
            class_replaceMethod(targetClass, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
        }else {
            method_exchangeImplementations(origMethod, newMethod)
        }
    }
    
    private static var touchExtendInsetKey: Void?
    
    var touchExtendInset: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &(UIButton.touchExtendInsetKey)) as! UIEdgeInsets
        }
        set (newValue){
            objc_setAssociatedObject(self, &(UIButton.touchExtendInsetKey), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private dynamic func myPointInside(_ point: CGPoint,_  evnet: UIEvent) -> Bool {
        let invaild = touchExtendInset == UIEdgeInsets.zero ||
            self.isHidden   ||
            !self.isEnabled
        if invaild {
            return self.myPointInside(point, evnet)
        }
        var hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.touchExtendInset)
        hitFrame.size.width = max(hitFrame.size.width, 0)
        hitFrame.size.height = max(hitFrame.size.height, 0)
        
        return hitFrame.contains(point)
    }
    
    dynamic  override open class func initialize() {
        swizzle(targetClass: self, orig: #selector(point(inside:with:)), new: #selector(myPointInside(_:_:)))
        
    }
    
}

extension UIButton {
    
    /// 设置按钮不同状态的背景颜色
    ///
    /// - Parameters:
    ///   - backgoundColor: color
    ///   - state: state
    func setBackgroundColor(_ backgroundColor: UIColor, _ state: UIControlState) {
        self.setBackgroundImage(self.imageWithColor(backgroundColor), for: state)
    }
    
    private func imageWithColor(_ color: UIColor) -> UIImage? {
        let rect = CGRect.init(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
}

extension UIButton {
    typealias ButtonTappedClosure = ( UIButton)-> Void
    func addAction(state: UIControlEvents, closure:ButtonTappedClosure) {
        objc_setAssociatedObject(self, &UIButton.ButtonTappedClosureKey, closure, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        self.addTarget(self, action: #selector(tappedAction(sender:)), for:state)
    }
    //MARK: Private
    private static var ButtonTappedClosureKey: Void?
    @objc private func tappedAction(sender: UIButton) {
        let closure = objc_getAssociatedObject(self, &UIButton.ButtonTappedClosureKey) as? UIButton.ButtonTappedClosure
        if let closure = closure {
            closure(sender);
        }
    }
    
}

extension UIButton {
    
    /// 倒计时按钮
    ///
    /// - Parameters:
    ///   - duration: 总时间
    ///   - normalTitle: 标题
    ///   - waitTitle: s 每秒变化一次 ss
    func startCountDown( _ duration: Int = 60,
                         _ normalTitle: String = "获取验证码",
                         _ waitTitle: String = "s") {
        //        let color = self.backgroundColor
        //        var timeout = duration
        //        if #available(iOS 10.0, *)  {
        //            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { ( timer: Timer) in
        //                if timeout <= 0 {
        //                    timer.invalidate()
        //                    self.setTitle(normalTitle, for: .normal)
        //                    self.isEnabled = true
        //                    self.backgroundColor = color
        //                }else{
        //                    self .setTitle("\(timeout)\(waitTitle)", for: .disabled)
        //                    self.isEnabled = false
        //                    self.backgroundColor = UIColor.gray
        //                    self.setTitleColor(UIColor.white, for: .disabled)
        //                    timeout = timeout - 1
        //                }
        //            }
        //        } else {
        self.duration = duration
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown(timer:)), userInfo: ["duration": duration, "normalTitle": normalTitle, "waitTitle": waitTitle], repeats: true)
        //                   }
    }
    
    @objc private func countDown (timer: Timer) {
        let color = self.backgroundColor
        let userInfo: [String : Any] = timer.userInfo as! [String : Any]
        let normalTitle: String = userInfo["normalTitle"] as! String
        let waitTitle = userInfo["waitTitle"] as! String
        
        if duration <= 0 {
            timer.invalidate()
            self.setTitle(normalTitle, for: .normal)
            self.isEnabled = true
            self.backgroundColor = color
        }else{
            self .setTitle("\(duration)\(waitTitle)", for: .disabled)
            self.isEnabled = false
            self.backgroundColor = UIColor.gray
            self.setTitleColor(UIColor.white, for: .disabled)
            duration = duration - 1
        }
    }
    
    private static var timerkey: Void?
    private var timer: Timer? {
        set {
            objc_setAssociatedObject(self, &UIButton.timerkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return  objc_getAssociatedObject(self, &UIButton.timerkey) as? Timer
        }
    }
    private static var durationkey: Void?
    private  var duration: Int {
        set {
            objc_setAssociatedObject(self, &UIButton.durationkey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
        get {
            
            return objc_getAssociatedObject(self, &UIButton.durationkey) as! Int
        }
    }
    
}

extension UIButton {
    
    enum ZTButtonImagePosition: Int{
        case left, right, top, bottom
    }
    
    /// 设置按钮图片和标题的位置关系
    ///
    /// - Parameters:
    ///   - position: 位置枚举值
    ///   - spacing:  标题 和图片的间距
    func setImagePosition( _ position: ZTButtonImagePosition,
                           _ spacing: CGFloat) {
        
        let imageW = self.imageView?.image?.size.width  ?? 0
        let imageH = self.imageView?.image?.size.height ?? 0
        
        let text = self.titleLabel?.text
        guard text != nil else {
            return
        }
        //        let font = self.titleLabel?.font ?? UIFont.systemFont(ofSize: 12)
        let margin = spacing
        //        var labelW = NSString.init(string: text!).size(attributes: [NSFontAttributeName: font]).height
        //        var labelH = NSString.init(string: text!).size(attributes: [NSFontAttributeName: font]).width
        let labelW = self.titleLabel?.bounds.size.width ?? 0
        let labelH = self.titleLabel?.bounds.size.height ?? 0
        let imageOffsetX = labelW * 0.5
        let imageOffsetY = labelH * 0.5 + spacing
        
        let labelOffsetX = imageW / 2
        let labelOffsetY = imageH / 2 + margin
        
        
        switch position {
        case .left:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -margin, 0, margin)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, margin, 0, -margin)
        case .right:
            self.imageEdgeInsets = UIEdgeInsetsMake(0, labelW + margin, 0, -labelW - margin)
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageH - margin, 0, imageH + margin)
        case .top:
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX)
        case .bottom:
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX)
            self.titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX)
            
        }
    }
    
}

extension UIButton {
    
    //MARK: Public
    
    
    /// 带有菊花的按钮
    ///
    /// - Parameter title: 等待状态标题
    func showIndicator(title: String)  {
        self.hiddenIndicator()
        self.isWait = true
        self.isHidden = true
        
        self.modalView = UIView.init(frame: self.frame)
        self.modalView.backgroundColor = self.backgroundColor?.withAlphaComponent(0.6)
        self.modalView.layer.cornerRadius = self.layer.cornerRadius
        self.modalView.layer.borderColor = self.layer.borderColor
        self.modalView.layer.borderWidth = self.layer.borderWidth
        self.modalView.layer.masksToBounds = self.layer.masksToBounds
        
        let viewBounds = self.bounds
        
        self.indicatorView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        self.indicatorView.tintColor = self.titleLabel?.textColor
        let indicatorViewBounds = self.indicatorView.bounds
        let y = viewBounds.size.height / 2.0 - indicatorViewBounds.size.height / 2.0
        self.indicatorView.frame = CGRect.init(x: 15, y: y, width: indicatorViewBounds.size.width, height: indicatorViewBounds.size.height)
        self.indicatorView.hidesWhenStopped = true
        
        self.indicatorLabel = UILabel.init(frame: viewBounds)
        self.indicatorLabel.textAlignment = .center
        self.indicatorLabel.text = title
        self.indicatorLabel.textColor = self.titleLabel?.textColor
        self.indicatorLabel.font = self.titleLabel?.font
        
        self.modalView.addSubview(self.indicatorView)
        self.modalView.addSubview(self.indicatorLabel)
        self.superview?.addSubview(self.modalView)
        self.indicatorView.startAnimating()
        
    }
    
    func hiddenIndicator() {
        guard self.isWait else {
            return
        }
        
        self.isWait = false
        self.isHidden = false
        self.modalView.removeFromSuperview()
        
    }
    private static var isWaitkey: Void?
    var isWait: Bool {
        get {
            return (objc_getAssociatedObject(self, &UIButton.isWaitkey) as?
                Bool) ?? false
            
        }
        set (newValue){
            objc_setAssociatedObject(self, &UIButton.isWaitkey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    //MARK: Private
    private static var modalViewKey: Void?
    private var modalView: UIView {
        get {
            return objc_getAssociatedObject(self, &UIButton.modalViewKey) as! UIView
        }
        set (newValue){
            objc_setAssociatedObject(self, &UIButton.modalViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static var indicatorViewkey: Void?
    private var indicatorView: UIActivityIndicatorView {
        get {
            return objc_getAssociatedObject(self, &UIButton.indicatorViewkey) as! UIActivityIndicatorView
        }
        
        set (newValue){
            objc_setAssociatedObject(self, &UIButton.indicatorViewkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static var indicatorLabelkey: Void?
    private var indicatorLabel: UILabel {
        get {
            return objc_getAssociatedObject(self, &UIButton.indicatorLabelkey) as! UILabel
        }
        set (newValue){
            objc_setAssociatedObject(self, &UIButton.indicatorLabelkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
}

