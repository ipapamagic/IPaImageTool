//
//  UIImage+IPaImageTool.h
//  IPaImageTool
//
//  Created by IPaPa on 13/4/16.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface UIImage (IPaImageTool)
- (UIImage*)imageWithRotationFix;
- (UIImage*)imageFitSize:(CGSize)size;
- (UIImage*)imageFitWidth:(CGFloat)width;
- (UIImage*)imageFitHeight:(CGFloat)height;
- (UIImage*)imageWithWidth:(CGFloat)width;
- (UIImage*)imageWithHeight:(CGFloat)height;
- (UIImage*)imageWithSize:(CGSize)size;
- (UIImage*)imageWithRotateRight;
- (UIImage*)imageWithRotate180;
- (UIImage*)imageWithRotateLeft;
- (UIImage*)imageWithCropRect:(CGRect)rect;
- (UIImage*)imageWithAspectFillSize:(CGSize)size;
@end
