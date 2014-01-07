//
//  UIImage+IPaImageTool.m
//  IPaImageTool
//
//  Created by IPaPa on 13/4/16.
//  Copyright (c) 2013年 IPaPa. All rights reserved.
//

#import "UIImage+IPaImageTool.h"

@implementation UIImage (IPaImageTool)
-(UIImage*)imageWithCropRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    [self drawAtPoint:CGPointMake(-rect.origin.x, -rect.origin.y)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage*)imageWithRotationFix
{
    
    if (self.imageOrientation == UIImageOrientationUp) {
        return self;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
-(UIImage*)imageWithSize:(CGSize)size
{
    UIImage *image;
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage*)imageFitSize:(CGSize)size
{
    CGSize newSize = self.size;
    CGFloat ratio = self.size.height / self.size.width;
    if (newSize.width > size.width) {
        newSize.width = size.width;
        newSize.height = newSize.width * ratio;
    }
    if(newSize.height > size.height) {
        newSize.height = size.height;
        newSize.width = newSize.height / ratio;
    }
    
    return [self imageWithSize:newSize];
}
-(UIImage*)imageFitWidth:(CGFloat)width
{
    CGSize newSize = self.size;
    CGFloat ratio = self.size.height / self.size.width;
    if (newSize.width > width) {
        newSize.width = width;
        newSize.height = newSize.width * ratio;
    }
    
    return [self imageWithSize:newSize];
}
-(UIImage*)imageFitHeight:(CGFloat)height
{
    CGSize newSize = self.size;
    CGFloat ratio = self.size.width / self.size.height;
    if (newSize.height > height) {
        newSize.height = height;
        newSize.width = newSize.height * ratio;
    }
    
    return [self imageWithSize:newSize];
}
-(UIImage*)imageWithWidth:(CGFloat)width
{
    CGSize newSize = self.size;
    CGFloat ratio = self.size.height / self.size.width;

    newSize.width = width;
    newSize.height = newSize.width * ratio;
    
    
    return [self imageWithSize:newSize];
}
-(UIImage*)imageWithHeight:(CGFloat)height
{
    CGSize newSize = self.size;
    CGFloat ratio = self.size.width / self.size.height;

    newSize.height = height;
    newSize.width = newSize.height * ratio;
    return [self imageWithSize:newSize];

}
-(UIImage*)imageWithRotateRight
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.height, self.size.width));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = self.size.width * 0.5;
    CGFloat y = self.size.height * 0.5;
    CGContextTranslateCTM(context, y,x);
    
    CGContextRotateCTM(context, M_PI * 0.5);
    [self drawAtPoint:CGPointMake(-x, -y)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage*)imageWithRotate180
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = self.size.width * 0.5;
    CGFloat y = self.size.height * 0.5;
    CGContextTranslateCTM(context, x,y);
    
    CGContextRotateCTM(context, M_PI);
    [self drawAtPoint:CGPointMake(-x, -y)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
-(UIImage*)imageWithRotateLeft
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.height, self.size.width));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat x = self.size.width * 0.5;
    CGFloat y = self.size.height * 0.5;
  
    CGContextTranslateCTM(context, y,x);
    
    CGContextRotateCTM(context, -M_PI * 0.5);
    [self drawAtPoint:CGPointMake(-x, -y)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
