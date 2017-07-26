//
//  AMKViewController.m
//  AMKit
//
//  Created by AndyM129 on 07/19/2017.
//  Copyright (c) 2017 AndyM129. All rights reserved.
//

#import "AMKViewController.h"
#import "UIViewController+AMKViewControllerSwitch.h"
#import "NSObject+AMKDeallocBlock.h"


@interface AMKViewController ()

@end

@implementation AMKViewController

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SVProgressHUD setMinimumDismissTimeInterval:1];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self AMKDeallocBlock_Test];
    [self AMKViewControllerSwitch_Test];
}

#pragma mark - Test AMKDeallocBlock

static NSInteger AMKDeallocBlock_kButtonTag = 17072021;
- (void)AMKDeallocBlock_Test {
    // 创建一个按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = AMKDeallocBlock_kButtonTag;
    button.backgroundColor = [UIColor orangeColor];
    [button setTitle:@"点击变为选中态，测试KVO正常" forState:UIControlStateNormal];
    [button setTitle:@"点击移除并销毁按钮" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(AMKDeallocBlock_didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(80);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    
    // 添加KVO
    [button addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    
    // 添加DeallocBlock以在dealloc时移除KVO
    __weak __typeof(self) weakSelf = self;
    [button amk_addDeallocBlock:^(id object){
        [SVProgressHUD showInfoWithStatus:@"触发DeallocBlock:\nKVO移除成功"];
        NSLog(@"移除KVO\nDeallocBlock: %@, \nweakSelf: %@", object, weakSelf);
        if (weakSelf) [object removeObserver:weakSelf forKeyPath:@"selected" context:NULL];
    } forKey:AMKDeallocBlockDefaultKey()];
}

- (void)AMKDeallocBlock_didClickButton:(UIButton *)button {
    if (button.selected == NO) {
        button.selected = YES;
        [SVProgressHUD showInfoWithStatus:@"KVO测试..."];
    } else {
        [SVProgressHUD showInfoWithStatus:@"移除按钮..."];
        [button removeFromSuperview];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([object isKindOfClass:[UIButton class]] && [(UIButton *)object tag]==AMKDeallocBlock_kButtonTag) {
        [SVProgressHUD showInfoWithStatus:@"KVO测试成功"];
        NSLog(@"KVO：%@, %@", object, [change objectForKey:NSKeyValueChangeNewKey]);
    }
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
