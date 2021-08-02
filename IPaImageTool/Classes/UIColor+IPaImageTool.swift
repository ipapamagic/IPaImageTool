//
//  UIColor+IPaImageTool.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2020/7/30.
//

import UIKit

extension UIColor {
    public convenience init(red:Int,green:Int,blue:Int,alpha:Int) {
        self.init(red: CGFloat(red) / 255.0,  green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    public convenience init(hex: String) {
        var r, g, b, a: CGFloat
        r = 0
        g = 0
        b = 0
        a = 0
        var hexColor = hex
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            hexColor = String(hex[start...])
        }
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            if hexColor.count == 8 {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
            }
            else if hexColor.count == 6 {
                r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                b = CGFloat((hexNumber & 0x0000ff)) / 255
                a = 1
            }
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    public var uiImage:UIImage {
        return UIImage.createImage(CGSize(width: 1, height: 1)) { (context) in
                context.setFillColor(self.cgColor)
                context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            }!
    }
    
}

