//
//  UIImage+GIF.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2022/5/5.
//

import UIKit

extension UIImage {
    public class func gifImage(with data:Data,handleFrame:((CGImage)->CGImage?)? = nil) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        var duration:Int = 0
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            var delaySeconds = 0.1
            let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, i, nil)
            let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
            defer {
                gifPropertiesPointer.deallocate()
            }
            let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
            if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) {
                let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

                var delayObject: AnyObject = unsafeBitCast(
                    CFDictionaryGetValue(gifProperties,Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),to: AnyObject.self)
                if delayObject.doubleValue == 0 {
                    delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
                }
                delaySeconds = (delayObject as? Double) ?? 0.1
            }
            
            let delay = Int(delaySeconds * 1000.0)
            delays.append(delay) // Seconds to ms
            duration += delay
        }
        
        
        var gcd = delays.first ?? 1
        for value in delays {
            guard value != gcd else {
                continue
            }
            var result = 0
            var (a,b) = ( value > gcd ) ? ( value, gcd ) : ( gcd , value )
            repeat {
                result = a % b
                a = b
                b = result
            }while result != 0
            gcd = a
        }
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            var cgImage = images[Int(i)]
            frame = UIImage(cgImage: handleFrame?(cgImage) ?? cgImage)
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        let animation = UIImage.animatedImage(with: frames,
                                              duration: Double(duration) / 1000.0)
        return animation
    }
    public class func gifImage(named name:String,handleFrame:((CGImage)->CGImage?)? = nil) -> UIImage? {
        guard let url = Bundle.main
            .url(forResource: name, withExtension: "gif"),let data = try? Data(contentsOf: url) else {
            return nil
        }
        return gifImage(with:data,handleFrame: handleFrame)
    }
}
