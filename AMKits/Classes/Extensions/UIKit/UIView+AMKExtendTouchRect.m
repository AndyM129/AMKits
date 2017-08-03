//
//  UIView+AMKExtendTouchRect.m
//  Pods
//
//  Created by Andy on 2017/7/20.
//
//

#import "UIView+AMKExtendTouchRect.h"
#import <objc/runtime.h>


@implementation UIView (AMKExtendTouchRect)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^__method_swizzling)(SEL, SEL) = ^(SEL sel, SEL _sel) {
            Method  method = class_getInstanceMethod(self, sel);
            Method _method = class_getInstanceMethod(self, _sel);
            method_exchangeImplementations(method, _method);
        };
        __method_swizzling(@selector(pointInside:withEvent:), @selector(amk_pointInside:withEvent:));
    });
}

- (UIEdgeInsets)amk_touchExtendInset {
    return [objc_getAssociatedObject(self, @selector(amk_touchExtendInset)) UIEdgeInsetsValue];
}

- (void)setAmk_touchExtendInset:(UIEdgeInsets)touchExtendInset {
    objc_setAssociatedObject(self, @selector(amk_touchExtendInset), [NSValue valueWithUIEdgeInsets:touchExtendInset], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)amk_pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.amk_touchExtendInset, UIEdgeInsetsZero) || self.hidden ||
        ([self isKindOfClass:UIControl.class] && !((UIControl *)self).enabled)) {
        return [self amk_pointInside:point withEvent:event]; // original implementation
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.amk_touchExtendInset);
    hitFrame.size.width = MAX(hitFrame.size.width, 0); // don't allow negative sizes
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    return CGRectContainsPoint(hitFrame, point);
}

@end
