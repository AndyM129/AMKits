#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSObject+AMKDeallocBlock.h"
#import "NSObject+AMKLocaleDescription.h"
#import "UIView+AMKExtendTouchRect.h"
#import "UIViewController+AMKLifeCircleBlock.h"
#import "UIViewController+AMKViewControllerSwitch.h"

FOUNDATION_EXPORT double AMKitsVersionNumber;
FOUNDATION_EXPORT const unsigned char AMKitsVersionString[];

