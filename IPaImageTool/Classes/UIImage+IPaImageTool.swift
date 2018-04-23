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
    public func image(apply transform:CGAffineTransform) -> UIImage! {
        let bounds = CGRect(origin: .zero, size: self.size).applying(transform)
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.translateBy(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
      
        context.concatenate(transform)
        self.draw(at: CGPoint(x: -self.size.width * 0.5, y: -self.size.height * 0.5))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
        
    }
    public func image(cropRect rect:CGRect) -> UIImage! {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        draw(at: CGPoint(x: -rect.origin.x, y: -rect.origin.y))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    public var rotationFixImage:UIImage! {
        get {
            if imageOrientation == .up {
                return self
            }
            var transform = CGAffineTransform.identity
            switch (imageOrientation) {
            case .down,.downMirrored:
                transform = transform.translatedBy(x: size.width, y: self.size.height)
                transform = transform.rotated(by: .pi)
            case .left,.leftMirrored:
                transform = transform.translatedBy(x: size.width, y: 0)
                transform = transform.rotated(by: .pi*0.5)
            case .right,.rightMirrored:
                transform = transform.translatedBy(x: 0, y: size.height)
                transform = transform.rotated(by: .pi * (-0.5))
            case .up,.upMirrored:
                break
            }
            
            switch (self.imageOrientation) {
            case .upMirrored,.downMirrored:
                transform = transform.translatedBy(x: size.width, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
                
            case .leftMirrored,.rightMirrored:
                transform = transform.translatedBy(x: size.height, y: 0)
                transform = transform.scaledBy(x: -1, y: 1)
            case .up,.down,.left,.right:
                break
            }
            
            // Now we draw the underlying CGImage into a new context, applying the transform
            // calculated above.
            let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                bitsPerComponent: (cgImage?.bitsPerComponent)!, bytesPerRow: 0,
                space: (cgImage?.colorSpace!)!,
                bitmapInfo: UInt32((cgImage?.bitmapInfo.rawValue)!))

            ctx?.concatenate(transform)
            switch (imageOrientation) {
            case .left,.leftMirrored,.right,.rightMirrored:
                // Grr...
                ctx?.draw(cgImage!, in: CGRect(x: 0,y: 0,width: size.height,height: size.width))
                
            default:
                ctx?.draw(cgImage!, in: CGRect(x: 0,y: 0,width: size.width,height: size.height))
            }
            
            // And now we just create a new UIImage from the drawing context
            let cgimg = ctx?.makeImage()
            let img = UIImage(cgImage: cgimg!)
    //        CGContextRelease(ctx)
    //        CGImageRelease(cgimg)
            return img
        }
    }
    public func image(size newSize:CGSize) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    public func image(fitSize:CGSize) -> UIImage {
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
        
        return image(size:newSize)
    }
    public func image(fitWidth width:CGFloat) -> UIImage {
        var newSize = size
        let ratio = size.height / size.width
        if newSize.width > width {
            newSize.width = width
            newSize.height = newSize.width * ratio
        }
        
        return image(size:newSize)
    }
    
    public func image(fitHeight height:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.width / size.height
        if newSize.height > height {
            newSize.height = height
            newSize.width = newSize.height * ratio
        }
    
        return image(size:newSize)
    }
    public func image(withWidth width:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.height / size.width
    
        newSize.width = width
        newSize.height = newSize.width * ratio
        return image(size:newSize)
    }
    public func image(withHeight height:CGFloat) -> UIImage
    {
        var newSize = size
        let ratio = size.width / size.height
    
        newSize.height = height
        newSize.width = newSize.height * ratio
        return image(size:newSize)
    
    }
    public var rotateRightImage:UIImage
    {
        get {
            return self.image(rotateBy:.pi * 0.5)
        }
    }
    public var rotate180Image:UIImage
    {
        get {
            return self.image(rotateBy:.pi)
        }
    }
    public var rotateLeftImage:UIImage
    {
        get {
            return self.image(rotateBy:.pi * -0.5)
        }
    }
    public func image(rotateBy angle:CGFloat) -> UIImage
    {
        let transform = CGAffineTransform(rotationAngle: angle)
        return self.image(apply: transform)
    }
    public func image(aspectFillSize fillSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(fillSize, false, 0)
        draw(aspectFillSize: fillSize)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func blurImage(radius:Float) -> UIImage {
        guard let cgImage = cgImage,let filter = CIFilter(name: "CIGaussianBlur") else {
            return self
        }
        let context = CIContext(options: nil)
        // create our blurred image
        let inputImage = CIImage(cgImage: cgImage)
        
        
        // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(NSNumber(value:radius), forKey: "inputRadius")
        let result = filter.value(forKey: kCIOutputImageKey) as! CIImage
        
        guard let newCGImage = context.createCGImage(result, from: inputImage.extent) else {
            return self
        }
        // CIGaussianBlur has a tendency to shrink the image a little,
        // this ensures it matches up exactly to the bounds of our original image
        let returnImage = UIImage(cgImage: newCGImage)
    
        
        return returnImage
    
        
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


