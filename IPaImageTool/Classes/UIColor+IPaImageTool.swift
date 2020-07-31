//
//  UIColor+IPaImageTool.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2020/7/30.
//

import UIKit

extension UIColor {
    public var uiImage:UIImage {
        return UIImage.createImage(CGSize(width: 1, height: 1)) { (context) in
                context.setFillColor(self.cgColor)
                context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            }!
    }
    
}

