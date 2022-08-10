//
//  Data+IPaImageTool.swift
//  Pods
//
//  Created by IPa Chen on 2017/9/20.
//
//

import UIKit
import ImageIO
extension Data {
    public var imageMetaData:[String:Any]? {
        get {
            if let imageSource = CGImageSourceCreateWithData(self as CFData, nil) {
                let options:NSDictionary = [kCGImageSourceShouldCache:false]
                if let imageProperies = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, options as CFDictionary) {
                    return imageProperies as? [String:Any]
                }
            }
            return nil
        }
    }
    public func write(metaData:[String:Any]) -> Data? {
        let destData = NSMutableData()
        if let source = CGImageSourceCreateWithData(self as CFData, nil),let UTI = CGImageSourceGetType(source) ,let destination = CGImageDestinationCreateWithData(destData, UTI, 1, nil){
            
            
            CGImageDestinationAddImageFromSource(destination, source, 0, metaData as CFDictionary)
            
            if CGImageDestinationFinalize(destination)
            {
                return destData as Data
            }
            
            
        }
        return nil
    }
    
}

extension NSData {
    public var imageMetaData:[String:Any]? {
        get {
            return (self as Data).imageMetaData
        }
    }
    public func write(metaData:[String:Any]) -> NSData? {
        return (self as Data).write(metaData: metaData) as NSData?
    }
}
