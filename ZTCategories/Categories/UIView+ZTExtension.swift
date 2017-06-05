//
//  UIView+ZTExtension.swift
//  ZTCategories
//
//  Created by apple on 2017/5/22.
//  Copyright © 2017年 shang. All rights reserved.
//

import UIKit

private protocol ZTDesginable {
    
    
}

@IBDesignable
extension UIView: ZTDesginable {
    
    private static var kBorderColorkey: Void?
    @IBInspectable public var borderColor: UIColor {
        get {
            return objc_getAssociatedObject(self,&UIView.kBorderColorkey ) as! UIColor
            
        }
        set {
            objc_setAssociatedObject(self, &UIView.kBorderColorkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.masksToBounds = false
            layer.borderColor = borderColor.cgColor
        }

    }
    
    private static var kborderWidthkey:Void?
    @IBInspectable public var borderWidth: CGFloat  {
        get {
            return objc_getAssociatedObject(self,&UIView.kborderWidthkey ) as! CGFloat
            
        }
        set {
            objc_setAssociatedObject(self, &UIView.kborderWidthkey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.masksToBounds = false
            layer.borderWidth = borderWidth
        }
    }
    private static var kCornerRadiuskey:Void?
    @IBInspectable public var cornerRadius: CGFloat {
        set{
                objc_setAssociatedObject(self, &UIView.kCornerRadiuskey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            layer.cornerRadius = newValue
        }
        get{
            return objc_getAssociatedObject(self, &UIView.kCornerRadiuskey) as! CGFloat
        }
        
    }
//
//    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
//        didSet {
//            layer.shadowColor = shadowColor.cgColor
//        }
//    }
//    
//    @IBInspectable public var shadowRadius: CGFloat = 0 {
//        didSet {
//            layer.shadowRadius = shadowRadius
//        }
//    }
//    
//    @IBInspectable public var shadowOpacity: CGFloat = 0 {
//        didSet {
//            layer.shadowOpacity = Float(shadowOpacity)
//        }
//    }
//    
//    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
//        didSet {
//            layer.shadowOffset.height = shadowOffsetY
//        }
//    }

    
}
