//
//  UIResponder+AMKResponderStandardEditActions.h
//  Pods
//
//  Created by Andy on 2017/7/26.
//
//

#import <UIKit/UIKit.h>

@interface UIResponder (AMKResponderStandardEditActions)

/** 获取当前对象的第一响应者 */
- (instancetype)amk_firstResponder;

/** 获取当前window的第一响应者 */
+ (instancetype)amk_firstResponder;

@end
