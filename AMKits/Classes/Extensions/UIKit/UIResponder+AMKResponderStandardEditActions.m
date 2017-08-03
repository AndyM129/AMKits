//
//  UIResponder+AMKResponderStandardEditActions.m
//  Pods
//
//  Created by Andy on 2017/7/26.
//
//

#import "UIResponder+AMKResponderStandardEditActions.h"

@implementation UIResponder (AMKResponderStandardEditActions)

- (instancetype)amk_firstResponder {
    return [self performSelector:@selector(firstResponder)];
}

+ (instancetype)amk_firstResponder {
    return [[[UIApplication sharedApplication] keyWindow] amk_firstResponder];
}

@end
