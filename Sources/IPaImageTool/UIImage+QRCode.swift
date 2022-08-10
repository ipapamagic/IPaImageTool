//
//  UIImage+QRCode.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2022/5/15.
//

import UIKit

extension UIImage {
    public static func qrCodeImage(with string:String,inputCorrectionLevel:String = "M",encoding:String.Encoding = .utf8) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        let data = string.data(using: encoding)
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(inputCorrectionLevel, forKey: "inputCorrectionLevel")
        return filter.outputImage?.uiImage
    }
}
