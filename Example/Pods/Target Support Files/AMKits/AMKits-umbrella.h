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

#import "AMKEmojiHelper.h"
#import "AMKEmojiManager.h"
#import "NSArray+AMKEmojiHelper.h"
#import "NSDictionary+AMKEmojiHelper.h"
#import "NSString+AMKEmojiHelper.h"
#import "NSObject+AMKDeallocBlock.h"
#import "NSObject+AMKLocaleDescription.h"
#import "UIResponder+AMKResponderStandardEditActions.h"
#import "UIView+AMKExtendTouchRect.h"
#import "UIViewController+AMKLifeCircleBlock.h"
#import "UIViewController+AMKViewControllerSwitch.h"

FOUNDATION_EXPORT double AMKitsVersionNumber;
FOUNDATION_EXPORT const unsigned char AMKitsVersionString[];

