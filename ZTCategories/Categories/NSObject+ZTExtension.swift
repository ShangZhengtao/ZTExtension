//
//  NSObject+ZTExtension.swift
//  ZTCategories
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 shang. All rights reserved.
//

import Foundation

extension NSObject {
    
    /// 打印属性列表
    class func getPropertyList(){
        var count: UInt32 =  0
        let propertyList = class_copyPropertyList(self.classForCoder(), &count)
        for i in 0..<count {
            let property = propertyList?[Int(i)]
            guard property != nil else {
                return
            }
            if let name = property_getName(property) ,let type = property_getAttributes(property) {
                let strName = String.init(cString: name)
                let strType = String.init(cString: type)
                let info = "<\(strType)>"+" : "+strName
                debugPrint(info)
            }
        }
    }
    
    /// 打印成员变量
    class func getIvars() {
        
        var count: UInt32 = 0
        let ivars = class_copyIvarList(self.classForCoder(), &count)
        for i in 0..<count {
            let ivar = ivars?[Int(i)]
            guard ivar != nil else {
                return
            }
            let name = ivar_getName(ivar)
            let type = ivar_getTypeEncoding(ivar)
            guard name != nil && type != nil else {
                return
            }
            let strName = String.init(cString: name!)
            let strType = String.init(cString: type!)
            let info = "<\(strType)>"+"  :  "+strName
            debugPrint(info)
        }
    }
}
