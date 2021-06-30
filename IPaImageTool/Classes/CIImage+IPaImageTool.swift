//
//  CIImage+IPaImageTool.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2021/6/29.
//

import UIKit

extension CIImage {
    //due to UIImage(ciImage:CIImage) will not create UIImage correctly,extend CIImage to create CGImage and go to UIImage to make contentMode correctly
    //reference https://developer.apple.com/documentation/coreimage/ciimage/1437833-imagebycroppingtorect
    public var uiImage:UIImage? {
        get {
            let context = CIContext()
            guard let cgImage = context.createCGImage(self, from: self.extent) else {
                return nil
            }
            return UIImage(cgImage: cgImage)
            
        }
    }
    public var heifData:Data? {
        guard var cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first else {
            return nil
        }
        let context = CIContext(options: nil)
        cachePath = (cachePath as NSString).appendingPathComponent("IPaImageToolHeifCache.HEIF")
        let url = URL(fileURLWithPath: cachePath)
        do {
            try context.writeHEIFRepresentation(of: self, to: url, format: .RGBA8, colorSpace: self.colorSpace!)
            return try Data(contentsOf: url)
        }
        catch let error {
            print(error)
        }
        return nil
    }

}
