//
//  UIViewController+AMKViewControllerSwitch.h
//  Pods
//
//  Created by Andy on 2017/7/19.
//
//

#import <UIKit/UIKit.h>

/** 视图控制器转场方式 */
typedef NS_ENUM(NSInteger, AMKViewControllerSwitchStyle) {
    AMKViewControllerSwitchStylePush = 0,    //!< push
    AMKViewControllerSwitchStylePresent      //!< Present
};

/** UIViewController切换相关扩展 */
@interface UIViewController (AMKViewControllerSwitch)

/** Top视图控制器 */
- (UIViewController *)amk_topViewController;

/** Top视图控制器 */
+ (UIViewController *)amk_topViewController;

/** 返回上一个ViewController */
- (BOOL)amk_goBackAnimated:(BOOL)animated;

/** 返回 [UIViewController amk_topViewController] 的上一个ViewController */
+ (BOOL)amk_goBackAnimated:(BOOL)animated;

/** 以PUSH的方式前往ViewController */
+ (BOOL)amk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion;

/** 以PUSH的方式前往ViewController */
- (BOOL)amk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion;

/** 以present的方式前往ViewController */
+ (BOOL)amk_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion;

/** 以present的方式前往ViewController */
- (BOOL)amk_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion;

/** 以指定的方式前往ViewController */
+ (BOOL)amk_gotoViewController:(UIViewController *)viewController switchStyle:(AMKViewControllerSwitchStyle)switchStyle  animated:(BOOL)animated completion:(void (^)(UIViewController *))completion;

/** 以指定的方式前往ViewController */
- (BOOL)amk_gotoViewController:(UIViewController *)viewController switchStyle:(AMKViewControllerSwitchStyle)switchStyle  animated:(BOOL)animated completion:(void (^)(UIViewController *))completion;

@end
