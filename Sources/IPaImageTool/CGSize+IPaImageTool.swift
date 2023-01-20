//
//  CGSize+IPaImageTool.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2022/11/16.
//

import UIKit

extension  CGSize {
    @inlinable public var ratio:CGFloat {
        return self.width / self.height
    }
    public func sizeFit(_ ratio:CGFloat) -> CGSize {
        let maxWidth = self.width
        let maxHeight = self.height
        let maxRatio = maxWidth / maxHeight
        
        var targetWidth = maxWidth
        var targetHeight = maxHeight
        
        if ratio > maxRatio {
            // width driven
            targetHeight = targetWidth / ratio
        }
        else {
            //height driven
            targetWidth = targetHeight * ratio
        }
        return CGSize(width: targetWidth, height: targetHeight)
    }
    @inlinable public func size(orientateBy orientation:UIImage.Orientation) -> CGSize {
        switch orientation {
        case .left,.right,.leftMirrored,.rightMirrored:
            return CGSize(width: self.height, height: self.width)
        default:
            return self
            
        }
    }
}
