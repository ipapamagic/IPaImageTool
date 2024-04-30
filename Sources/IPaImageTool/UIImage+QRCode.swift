//
//  UIImage+QRCode.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2022/5/15.
//

import UIKit

extension UIImage {
    public static func qrCodeImage(with string:String,size:CGSize = CGSize(width: 100, height: 100),inputCorrectionLevel:String = "M",encoding:String.Encoding = .utf8) -> UIImage? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        let data = string.data(using: encoding)
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(inputCorrectionLevel, forKey: "inputCorrectionLevel")
        guard let image = filter.outputImage?.uiImage else {
            return nil
        }
        return UIImage.createImage(size) { context in
            context.interpolationQuality = .none
            image.draw(in: CGRect(origin: .zero, size: size))
        }
        
        
    }
}
