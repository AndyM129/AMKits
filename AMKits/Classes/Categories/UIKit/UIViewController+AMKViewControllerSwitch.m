//
//  UIViewController+AMKViewControllerSwitch.m
//  Pods
//
//  Created by Andy on 2017/7/19.
//
//

#import "UIViewController+AMKViewControllerSwitch.h"
#import "UIViewController+AMKLifeCircleBlock.h"

@implementation UIViewController (AMKViewControllerSwitch)

+ (UIViewController *)amk_topViewController {
    UIViewController *topViewController = [[UIApplication sharedApplication].keyWindow rootViewController];
    while (YES) {
        if ([topViewController isKindOfClass:[UINavigationController class]]) {
            topViewController = [(UINavigationController *)topViewController topViewController];
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            topViewController = [(UITabBarController *)topViewController selectedViewController];
        } else if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else {
            break;
        }
    }
    return topViewController;
}

- (UIViewController *)amk_topViewController {
    return [UIViewController amk_topViewController];
}

- (BOOL)amk_goBackAnimated:(BOOL)animated {
    if (self.navigationController && self.self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:animated];
        return YES;
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:NULL];
        return YES;
    }
    return NO;
}

+ (BOOL)amk_goBackAnimated:(BOOL)animated {
    return [[UIViewController amk_topViewController] amk_goBackAnimated:animated];
}

+ (BOOL)amk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion {
    return [[UIViewController amk_topViewController] amk_pushViewController:viewController animated:animated completion:completion];
}

- (BOOL)amk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion {
    return [self amk_gotoViewController:viewController switchStyle:AMKViewControllerSwitchStylePush animated:animated completion:completion];
}

+ (BOOL)amk_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion {
    return [[UIViewController amk_topViewController] amk_presentViewController:viewController animated:animated completion:completion];
}

- (BOOL)amk_presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(UIViewController *))completion {
    return [self amk_gotoViewController:viewController switchStyle:AMKViewControllerSwitchStylePresent animated:animated completion:completion];
}

+ (BOOL)amk_gotoViewController:(UIViewController *)viewController switchStyle:(AMKViewControllerSwitchStyle)switchStyle  animated:(BOOL)animated completion:(void (^)(UIViewController *))completion {
    return [[UIViewController amk_topViewController] amk_gotoViewController:viewController switchStyle:switchStyle animated:animated completion:completion];
}

- (BOOL)amk_gotoViewController:(UIViewController *)viewController switchStyle:(AMKViewControllerSwitchStyle)switchStyle  animated:(BOOL)animated completion:(void (^)(UIViewController *))completion {
    if (completion) {
        [viewController setAmk_viewDidAppearBlock:^(UIViewController *viewController, BOOL animated){
            completion(viewController);
            viewController.amk_viewDidAppearBlock = NULL;
        }];
    }
    
    if (switchStyle == AMKViewControllerSwitchStylePresent) {
        [self presentViewController:viewController animated:animated completion:NULL];
    }
    else {
        if ([self isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)self pushViewController:viewController animated:animated];
        }
        else if (self.navigationController) {
            [self.navigationController pushViewController:viewController animated:animated];
        }
        else if ([[UIApplication sharedApplication].keyWindow.rootViewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *rootViewController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
            UIViewController *selectedViewController = rootViewController.selectedViewController;
            if ([selectedViewController isKindOfClass:[UINavigationController class]]) {
                [(UINavigationController*)selectedViewController pushViewController:viewController animated:animated];
            }
            else{
                NSAssert(selectedViewController.navigationController != nil, @"selectedViewController.navigationController != nil");
                if (selectedViewController.navigationController) {
                    [selectedViewController.navigationController pushViewController:viewController animated:animated];
                }
            }
        } else {
            NSAssert(NO, @"self %@ can not push view controller %@", self, viewController);
            return NO;
        }
    }
    return YES;
}


@end
