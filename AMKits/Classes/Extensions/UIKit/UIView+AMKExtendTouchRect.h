//
//  UIView+AMKExtendTouchRect.h
//  Pods
//
//  Created by Andy on 2017/7/20.
//
//

#import <UIKit/UIKit.h>

/** 添加对UIView手势交互范围的调整 */
@interface UIView (AMKExtendTouchRect)

@property(nonatomic, assign) UIEdgeInsets amk_touchExtendInset; //!< 调整视图点击区域

@end
