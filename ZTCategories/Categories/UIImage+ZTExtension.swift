//
//  UIImage+ZTExtension.swift
//  ZTCategories
//
//  Created by apple on 2017/5/12.
//  Copyright © 2017年 shang. All rights reserved.
//

import UIKit


extension UIImage {
    
    //MARK: Public
    
    
    /// 修正相机拍出照片的朝向问题
    ///
    /// - Returns: 方向正确的图片
    func fixImageOrientation() -> UIImage {
        guard self.imageOrientation == .up else {
            return self;
        }
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down,.downMirrored:
            
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            
        case .left, .leftMirrored:
            
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi * 0.5))
            
        case .right,.rightMirrored:
            
            transform = transform.rotated(by: -CGFloat(Double.pi / 2))
            transform = transform.translatedBy(x: 0, y: self.size.height)
            
        default : break
        }
        //处理镜像
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        guard cgImage != nil else {
            return self
        }
        //绘图
        let  context = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: (self.cgImage?.bitsPerComponent)!, bytesPerRow: (cgImage?.bytesPerRow)!, space: (self.cgImage?.colorSpace)!, bitmapInfo: (cgImage?.bitmapInfo.rawValue)!)
        guard  context != nil else {
            return self;
        }
        
        context?.concatenate(transform)
        
        switch imageOrientation {
        case .left,.leftMirrored,.right,.rightMirrored:
            context?.draw(cgImage!, in: CGRect.init(x: 0, y: 0, width: size.height, height: size.width))
        default:
            context?.draw(cgImage!, in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        if let cgimg = context!.makeImage() {
            let image = UIImage.init(cgImage: cgimg)
            return image
        }
        return  self
    }
    
    
    
}
