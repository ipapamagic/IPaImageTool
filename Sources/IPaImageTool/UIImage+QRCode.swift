//
//  UIImage+QRCode.swift
//  IPaImageTool
//
//  Created by IPa Chen on 2022/5/15.
//

import UIKit

extension UIImage {
    public enum IPaQRCodeCorrectionLevel: String {
        case L = "L"
        case M = "M"
        case Q = "Q"
        case H = "H"
    }
    public static func qrCodeImage(with string:String,size:CGSize = CGSize(width: 100, height: 100),inputCorrectionLevel:IPaQRCodeCorrectionLevel = .M,encoding:String.Encoding = .utf8) -> UIImage? {
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        let data = string.data(using: encoding)
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue(inputCorrectionLevel.rawValue, forKey: "inputCorrectionLevel")
        guard let outputImage = filter.outputImage else {
            return nil
        }
        let scaleX = size.width / outputImage.extent.size.width
        let scaleY = size.height / outputImage.extent.size.height
        let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        return UIImage(ciImage: transformedImage)
    }
    public static func barCode128Image(with string: String, size: CGSize = CGSize(width: 100, height: 50)) -> UIImage? {
        
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        let data = string.data(using: .ascii)
        filter.setDefaults()
        filter.setValue(data, forKey: "inputMessage")
        
        guard let outputImage = filter.outputImage else {
            return nil
        }
        
        let scaleX = size.width / outputImage.extent.size.width
        let scaleY = size.height / outputImage.extent.size.height
        let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        return UIImage(ciImage: transformedImage)
    }
    public static func barCode39Image(with string: String, size: CGSize = CGSize(width: 300, height: 100)) -> UIImage? {
        // Code 39 字符對應的條形碼模式
        let code39Encoding: [Character: String] = [
            "0": "101001101101", "1": "110100101011", "2": "101100101011", "3": "110110010101",
            "4": "101001101011", "5": "110100110101", "6": "101100110101", "7": "101001011011",
            "8": "110100101101", "9": "101100101101", "A": "110101001011", "B": "101101001011",
            "C": "110110100101", "D": "101011001011", "E": "110101100101", "F": "101101100101",
            "G": "101010011011", "H": "110101001101", "I": "101101001101", "J": "101011001101",
            "K": "110101010011", "L": "101101010011", "M": "110110101001", "N": "101011010011",
            "O": "110101101001", "P": "101101101001", "Q": "101010110011", "R": "110101011001",
            "S": "101101011001", "T": "101011011001", "U": "110010101011", "V": "100110101011",
            "W": "110011010101", "X": "100101101011", "Y": "110010110101", "Z": "100110110101",
            "-": "100101011011", ".": "110010101101", " ": "100110101101", "$": "100100100101",
            "/": "100100101001", "+": "100101001001", "%": "101001001001", "*": "100101101101"
        ]
        
        // Code 39 需要用 "*" 包裹字符串
        let content = "*\(string.uppercased())*"
        
        // 編碼為條形碼的序列
        var barcodeSequence = ""
        for char in content {
            if let encoded = code39Encoding[char] {
                barcodeSequence += encoded + "0" // 每個字符之間加入一個窄間隔
            } else {
                // 非法字符，無法生成條形碼
                return nil
            }
        }
        
        // 繪製條形碼圖片
        let scaleX = size.width / CGFloat(barcodeSequence.count)
        let scaleY = size.height
        
        return UIImage.createImage(size, operation: {
            context in
            context.setFillColor(UIColor.black.cgColor)
            context.setStrokeColor(UIColor.clear.cgColor)
            
            for (index, bit) in barcodeSequence.enumerated() {
                if bit == "1" {
                    let rect = CGRect(x: CGFloat(index) * scaleX, y: 0, width: scaleX, height: scaleY)
                    context.fill(rect)
                }
            }
        })
    }
}
