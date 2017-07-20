//
//  AMKViewController.m
//  AMKit
//
//  Created by AndyM129 on 07/19/2017.
//  Copyright (c) 2017 AndyM129. All rights reserved.
//

#import "AMKViewController.h"
#import "UIViewController+AMKViewControllerSwitch.h"

@interface AMKViewController ()

@end

@implementation AMKViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self AMKViewControllerSwitch_Test];
}

#pragma mark - Test UIViewController+AMKViewControllerSwitch

- (void)AMKViewControllerSwitch_Test {
    self.title = @"AMKViewControllerSwitch Test";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(AMKViewControllerSwitch_didClickRightBarButtonItem:)];
    if (self.presentingViewController) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(AMKViewControllerSwitch_didClickLeftBarButtonItem:)];
    }
}

- (void)AMKViewControllerSwitch_didClickRightBarButtonItem:(UIBarButtonItem *)barButtonItem {
    AMKViewControllerSwitchStyle style = arc4random()%2;
    
    UIViewController *viewController = [[AMKViewController alloc] init];
    if (style == AMKViewControllerSwitchStylePresent) {
        viewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    }
    [self amk_gotoViewController:viewController switchStyle:style animated:YES completion:^(UIViewController *viewController) {
        NSLog(@"Done");
    }];
}

- (void)AMKViewControllerSwitch_didClickLeftBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self amk_goBackAnimated:YES];
}


@end
