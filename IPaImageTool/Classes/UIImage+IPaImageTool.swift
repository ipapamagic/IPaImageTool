//
//  UIImage+IPaImageTool.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2015/6/17.
//  Copyright (c) 2015年 AMagicStudio. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
     public func imageWithCropRect(_ rect:CGRect) -> UIImage! {
        UIGraphicsBeginImageContext(rect.size)
        draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
     public func imageWithRotationFix() -> UIImage! {
        if imageOrientation == .up {
            return self
        }
        var transform = CGAffineTransform.identity
        switch (imageOrientation) {
        case .down,.downMirrored:
            transform = transform.translatedBy(x: size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat(M_PI))
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
        case .up,.upMirrored:
            break;
        }
        
        switch (self.imageOrientation) {
        case .upMirrored,.downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up,.down,.left,.right:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
            bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0,
            space: (cgImage?.colorSpace!)!,
            bitmapInfo: UInt32((cgImage?.bitmapInfo.rawValue)!))

        ctx?.concatenate(transform);
        switch (imageOrientation) {
        case .left,.leftMirrored,.right,.rightMirrored:
            // Grr...
            ctx?.draw(cgImage!, in: CGRect(x: 0,y: 0,width: size.height,height: size.width))
            
        default:
            ctx?.draw(cgImage!, in: CGRect(x: 0,y: 0,width: size.width,height: size.height))
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = ctx?.makeImage();
        let img = UIImage(cgImage: cgimg!)
//        CGContextRelease(ctx)
//        CGImageRelease(cgimg)
        return img;
    }
    public func imageWithSize(_ newSize:CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return image!
    }
    public func imageFitSize(_ fitSize:CGSize) -> UIImage {
        var newSize = size
        let ratio = size.height / size.width
        if (newSize.width > fitSize.width) {
            newSize.width = fitSize.width
            newSize.height = newSize.width * ratio
        }
        if(newSize.height > fitSize.height) {
            newSize.height = fitSize.height
            newSize.width = newSize.height / ratio
        }
        
        return imageWithSize(newSize)
    }
    public func imageFitWidth(_ width:CGFloat) -> UIImage {
        var newSize = size
        let ratio = size.height / size.width
        if newSize.width > width {
            newSize.width = width
            newSize.height = newSize.width * ratio
        }
        
        return imageWithSize(newSize)
    }
    
    public func imageFitHeight(_ height:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.width / size.height
        if newSize.height > height {
            newSize.height = height
            newSize.width = newSize.height * ratio
        }
    
        return imageWithSize(newSize)
    }
    public func imageWithWidth(_ width:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.height / size.width
    
        newSize.width = width
        newSize.height = newSize.width * ratio
        return imageWithSize(newSize)
    }
    public func imageWithHeight(_ height:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.width / size.height
    
        newSize.height = height
        newSize.width = newSize.height * ratio
        return imageWithSize(newSize)
    
    }
    public func imageWithRotateRight() -> UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: size.height, height: size.width))
    
        let context = UIGraphicsGetCurrentContext()
        let x = size.width * 0.5
        let y = size.height * 0.5
        context?.translateBy(x: y,y: x)
        context?.rotate(by: CGFloat(M_PI) * 0.5)
        draw(at: CGPoint(x: -x, y: -y))
    
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    public func imageWithRotate180() -> UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: size.width, height: size.height))
    
        let context = UIGraphicsGetCurrentContext();
        let x = size.width * 0.5;
        let y = size.height * 0.5;
        context?.translateBy(x: x,y: y)
        context?.rotate(by: CGFloat(M_PI))
        draw(at: CGPoint(x: -x, y: -y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    public func imageWithRotateLeft() -> UIImage
    {
        UIGraphicsBeginImageContext(CGSize(width: size.height, height: size.width))
    
        let context = UIGraphicsGetCurrentContext()
        let x = size.width * 0.5
        let y = size.height * 0.5
        context?.translateBy(x: y,y: x)
        context?.rotate(by: CGFloat(-M_PI) * 0.5)
        draw(at: CGPoint(x: -x, y: -y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    public func imageWithAspectFillSize(_ fillSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(fillSize)
        draw(aspectFillSize: fillSize)
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    //MARK: draw function
    public func draw(aspectFillSize fillSize:CGSize)
    {
        let sizeRatio = fillSize.width / fillSize.height
        let ratio = size.width / size.height
        var drawRect = CGRect.zero
        if sizeRatio >= ratio {
            drawRect.size.width = fillSize.width
            drawRect.size.height = fillSize.width / ratio
            drawRect.origin.y = -((drawRect.size.height - fillSize.height) * 0.5)
        }
        else {
            drawRect.size.height = fillSize.height
            drawRect.size.width = fillSize.height * ratio
            drawRect.origin.x = -((drawRect.size.width - fillSize.width) * 0.5)
            
        }
        draw(in: drawRect)
    }
    
}


