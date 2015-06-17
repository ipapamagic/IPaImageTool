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
    func imageWithCropRect(rect:CGRect) -> UIImage! {
        UIGraphicsBeginImageContext(rect.size)
        drawAtPoint(CGPointMake(-rect.origin.x, -rect.origin.y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func imageWithRotationFix() -> UIImage! {
        if imageOrientation == .Up {
            return self
        }
        var transform = CGAffineTransformIdentity
        switch (imageOrientation) {
        case .Down,.DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        case .Left,.LeftMirrored:
            transform = CGAffineTransformTranslate(transform,size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        case .Right,.RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
        case .Up,.UpMirrored:
            break;
        }
        
        switch (self.imageOrientation) {
        case .UpMirrored,.DownMirrored:
            transform = CGAffineTransformTranslate(transform, size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            
        case .LeftMirrored,.RightMirrored:
            transform = CGAffineTransformTranslate(transform, size.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        case .Up,.Down,.Left,.Right:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGBitmapContextCreate(nil, Int(size.width), Int(size.height),
            CGImageGetBitsPerComponent(CGImage), 0,
            CGImageGetColorSpace(CGImage),
            CGImageGetBitmapInfo(CGImage))

        CGContextConcatCTM(ctx, transform);
        switch (imageOrientation) {
        case .Left,.LeftMirrored,.Right,.RightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,size.height,size.width), CGImage)
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,size.width,size.height), CGImage)
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx);
        let img = UIImage(CGImage: cgimg)
//        CGContextRelease(ctx)
//        CGImageRelease(cgimg)
        return img;
    }
    func imageWithSize(size:CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(size)
        drawInRect(CGRectMake(0, 0, size.width, size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return image
    }
    func imageFitSize(size:CGSize) -> UIImage {
        var newSize = size
        let ratio = size.height / size.width
        if (newSize.width > size.width) {
            newSize.width = size.width
            newSize.height = newSize.width * ratio
        }
        if(newSize.height > size.height) {
            newSize.height = size.height
            newSize.width = newSize.height / ratio
        }
        
        return imageWithSize(newSize)
    }
    func imageFitWidth(width:CGFloat) -> UIImage {
        var newSize = size
        let ratio = size.height / size.width
        if newSize.width > width {
            newSize.width = width
            newSize.height = newSize.width * ratio
        }
        
        return imageWithSize(newSize)
    }
    
    func imageFitHeight(height:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.width / size.height
        if newSize.height > height {
            newSize.height = height
            newSize.width = newSize.height * ratio
        }
    
        return imageWithSize(newSize)
    }
    func imageWithWidth(width:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.height / size.width
    
        newSize.width = width
        newSize.height = newSize.width * ratio
        return imageWithSize(newSize)
    }
    func imageWithHeight(height:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.width / size.height
    
        newSize.height = height
        newSize.width = newSize.height * ratio
        return imageWithSize(newSize)
    
    }
    func imageWithRotateRight() -> UIImage
    {
        UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width))
    
        let context = UIGraphicsGetCurrentContext()
        let x = size.width * 0.5
        let y = size.height * 0.5
        CGContextTranslateCTM(context, y,x)
        CGContextRotateCTM(context, CGFloat(M_PI) * 0.5)
        drawAtPoint(CGPointMake(-x, -y))
    
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image;
    }
    func imageWithRotate180() -> UIImage
    {
        UIGraphicsBeginImageContext(CGSizeMake(size.width, size.height))
    
        let context = UIGraphicsGetCurrentContext();
        let x = size.width * 0.5;
        let y = size.height * 0.5;
        CGContextTranslateCTM(context, x,y)
        CGContextRotateCTM(context, CGFloat(M_PI))
        drawAtPoint(CGPointMake(-x, -y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func imageWithRotateLeft() -> UIImage
    {
        UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width))
    
        let context = UIGraphicsGetCurrentContext()
        let x = size.width * 0.5
        let y = size.height * 0.5
        CGContextTranslateCTM(context, y,x)
        CGContextRotateCTM(context, CGFloat(-M_PI) * 0.5)
        drawAtPoint(CGPointMake(-x, -y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    func imageWithAspectFillSize(size:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(size)
        let sizeRatio = size.width / size.height
        let ratio = size.width / size.height
        var drawRect = CGRectZero
        if sizeRatio >= ratio {
            drawRect.size.width = size.width
            drawRect.size.height = size.width / ratio
            drawRect.origin.y = -((drawRect.size.height - size.height) * 0.5)
        }
        else {
            drawRect.size.height = size.height
            drawRect.size.width = size.height * ratio
            drawRect.origin.x = -((drawRect.size.width - size.width) * 0.5)
    
        }
        drawInRect(drawRect)
    
    
    
    
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image
    }

}


