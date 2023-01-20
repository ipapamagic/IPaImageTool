//
//  CGContext+IPaImageTool.swift
//  PKLibrary
//
//  Created by IPa Chen on 2022/12/31.
//

import UIKit

extension CGContext {
    @inlinable public func setFillUIColor(_ color:UIColor) {
        self.setFillColor(color.cgColor)
    }
    @inlinable public func setStrokeUIColor(_ color:UIColor) {
        self.setStrokeColor(color.cgColor)
    }
}
