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
    public var heifData: Data? {
        guard let cgImage = self.cgImage  else {
            return nil
        }
        return CIImage(cgImage: cgImage).heifData
    }
    @inlinable public static func createImage(_ size:CGSize,rendererFormat:UIGraphicsImageRendererFormat? = nil ,operation:(CGContext)->()) -> UIImage? {
        var renderer:UIGraphicsImageRenderer
        if let rendererFormat = rendererFormat {
            renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        }
        else {
            renderer = UIGraphicsImageRenderer(size: size)
        }
        return renderer.image { rendererContext in
            operation(rendererContext.cgContext)
        }
    }
   
    public func image(apply transform:CGAffineTransform) -> UIImage! {
        let bounds = CGRect(origin: .zero, size: self.size).applying(transform)
        let size = CGSize(width: bounds.width.rounded(.down), height: bounds.height.rounded(.down))
        var format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        
        return UIImage.createImage(size,rendererFormat: format, operation: {
            context in
            context.translateBy(x: size.width * 0.5, y: size.height * 0.5)
            context.concatenate(transform)
            context.translateBy(x: -self.size.width * 0.5, y: -self.size.height * 0.5)
            context.setShouldAntialias(true)
            context.setAllowsAntialiasing(true)
            
            self.draw(at: .zero)
        }) ?? self
    }
    public func image(cropRect rect:CGRect) -> UIImage! {
        var cropRect = rect
       
        if let cgImage = self.cgImage ,let newImage = cgImage.cropping(to: cropRect.applying(CGAffineTransform(scaleX: self.scale, y: self.scale))) {
            return UIImage(cgImage: newImage,scale: self.scale, orientation: self.imageOrientation)
        }
        var format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        return UIImage.createImage(cropRect.size,rendererFormat: format, operation: {
            renderContext in
            draw(at: CGPoint(x: -cropRect.origin.x, y: -cropRect.origin.y))
        }) ?? self
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
            @unknown default:
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
            @unknown default:
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
        let format = UIGraphicsImageRendererFormat()
        format.scale = self.scale
        return UIImage.createImage(newSize,rendererFormat: format) { context in
            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        }!
    }
    public func image(fitSize:CGSize) -> UIImage {
        let oRatio = size.ratio
        let fitSizeRatio = fitSize.ratio
        return oRatio > fitSizeRatio ? image(fitWidth: fitSize.width) : image(fitHeight: fitSize.height)
    }
    public func image(fitWidth width:CGFloat) -> UIImage {
        var newSize = size
        newSize.width = width
        newSize.height = newSize.width / size.ratio
        return image(size:newSize)
    }
    
    public func image(fitHeight height:CGFloat) -> UIImage
    {
        var newSize = size
        newSize.height = height
        newSize.width = newSize.height * size.ratio
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
    @inlinable public var rotateRightImage:UIImage
    {
        get {
            return self.image(rotateBy:.pi * 0.5)
        }
    }
    @inlinable public var rotate180Image:UIImage
    {
        get {
            return self.image(rotateBy:.pi)
        }
    }
    @inlinable public var rotateLeftImage:UIImage
    {
        get {
            return self.image(rotateBy:.pi * -0.5)
        }
    }
    public func image(orientateBy orientation:UIImage.Orientation) -> UIImage {
        switch orientation {
        case .down:
            return self.rotate180Image
        case .left:
            return self.rotateLeftImage
        case .right:
            return self.rotateRightImage
        case .up:
            return self
        case .upMirrored:
            return self.withHorizontallyFlippedOrientation()
        case .downMirrored:
            return self.rotate180Image.withHorizontallyFlippedOrientation()
        case .leftMirrored:
            return self.rotateLeftImage.withHorizontallyFlippedOrientation()
        case .rightMirrored:
            return self.rotateRightImage.withHorizontallyFlippedOrientation()
        @unknown default:
            return self
        }
    }
    public func image(with orientation:UIImage.Orientation) -> UIImage {
        guard let cgImage = self.cgImage else {
            return self.image(orientateBy: orientation)
        }
        return UIImage(cgImage: cgImage, scale: self.scale, orientation: orientation)
    }
    @inlinable public func image(rotateBy angle:CGFloat) -> UIImage
    {
        let transform = CGAffineTransform(rotationAngle: angle)
        return self.image(apply: transform)
    }
    @inlinable public func image(aspectFillSize fillSize:CGSize) -> UIImage
    {
        UIGraphicsBeginImageContext(fillSize)
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


