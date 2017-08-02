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
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor whiteColor];

    //[self AMKDeallocBlock_Test];
    //[self AMKViewControllerSwitch_Test];
    //[self AMKLogManager_Test];
    //[self AMKEmojiHelper_Test];
    //[self AMKEmojiHelper_Test4];
    //NSLog(@"%@", [NSDictionary amk_emojiMappingOfUnicodeToCheatCodes]);
    //NSLog(@"%@", [NSDictionary amk_emojiMappingOfCheatCodesToUnicode]);
    
    [self.navigationController pushViewController:[NSClassFromString(@"AMKEmojiHelperDemo") new] animated:YES];
}

//#pragma mark - AMKEmoji
//
///** 验证emoji识别的覆盖率 */
//- (void)AMKEmojiHelper_Test {
//    NSError *error = nil;
//    // emoji大全的网页
//    NSString *testText = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.baobao360.com/fuhao/mobile/emoji.html"] encoding:NSUTF8StringEncoding error:&error];
//    if (error) {
//        NSLog(@"%@", error);
//    } else {
//        // 验证是否含有emoji
////        BOOL containsEmojiInUnicode = [testText amk_containsEmojiInUnicode];
////        BOOL containsEmojiInCheatCodes = [testText amk_containsEmojiInCheatCodes];
////        NSLog(@"containsEmojiInUnicode: %@", containsEmojiInUnicode?@"YES":@"NO");
////        NSLog(@"containsEmojiInCheatCodes: %@", containsEmojiInCheatCodes?@"YES":@"NO");
//        
//        // emoji替换测试
//        NSString *replacingEmojiCheatCodesTest1 = [testText amk_stringByReplacingEmojiUnicodeWithString:^NSString *(NSString *unicode, NSString *cheatCodes, BOOL *stop) {
//            NSLog(@"=====");
//            *stop = YES;
//            return @"andy";
//        }];
//        NSLog(@"%@", replacingEmojiCheatCodesTest1);
//        
////        NSString *replacingEmojiCheatCodesTest2 = [testText amk_stringByReplacingEmojiCheatCodesWithString:^NSString *(NSString *cheatCodes, NSString *unicode, BOOL *stop) {
////            NSLog(@"+++++");
////            *stop = NO;
////            return @"andy";
////        }];
////        NSLog(@"%@", replacingEmojiCheatCodesTest2);
////        
////        // 转码测试
////        NSString *replacingEmojiUnicodeWithCheatCodesTest = [testText amk_stringByReplacingEmojiUnicodeWithCheatCodes];
////        NSLog(@"%@", replacingEmojiUnicodeWithCheatCodesTest);
////
////        NSString *replacingEmojiCheatCodesWithUnicode = [testText amk_stringByReplacingEmojiCheatCodesWithUnicode];
////        NSLog(@"%@", replacingEmojiCheatCodesWithUnicode);
//    }
//}
//
///** 现有emoji映射测试 */
//- (void)AMKEmojiHelper_Test2 {
//    NSDictionary *dic = nil;
//    NSArray *emojiCheatCodesArray = [dic allKeys];
//    NSArray *emojiUnicodeArray = [dic allValues];
//    for (NSString *cheatCodes in emojiCheatCodesArray) {
//        NSString *unicode = [dic objectForKey:cheatCodes];
////        NSString *myCheatCodes = [unicode amk_stringByReplacingEmojiUnicodeWithCheatCodes];
////        NSLog(@"%@ => %@\t\t%@\t\t\t%@", unicode, cheatCodes, myCheatCodes, [cheatCodes isEqualToString:myCheatCodes]?@"":@"<<<<<<<<<<<<<<<<");
//        
//        NSString *myUnicode = [cheatCodes amk_stringByReplacingEmojiCheatCodesWithUnicode];
//        NSLog(@"%@ => %@\t\t%@\t\t\t%@", cheatCodes, unicode, myUnicode, [unicode isEqualToString:myUnicode]?@"":@"<<<<<<<<<<<<<<<<");
//    }
//}
//
///** 生成emoji映射表 */
//- (void)AMKEmojiHelper_Test3 {
//    NSError *error = nil;
//    NSString *categorieName = nil;                  //!< 分类名称
//    
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmojiMap_1" ofType:@"txt"];
//    NSString *text = [NSString stringWithContentsOfFile:plistPath encoding:NSUTF8StringEncoding error:&error];
//    NSArray *array = [text componentsSeparatedByString:@"\n"];
//    for (NSString *line in array) {
//        NSArray<NSString *> *values = [line componentsSeparatedByString:@"\t"];
//        if (values.count == 1) {
//            categorieName = values[0];
//        } else if (values.count == 3) {
//            NSString *unicode = values[0];
//            NSString *cheatCodes = [NSString stringWithFormat:@":%@:", values[2].underlineString];
//
//            NSArray *addedCheatCodesArray = nil;
//            AMKEmoji *emoji = [[AMKEmojiManager sharedManager] addEmojiWithCategoryName:categorieName unicode:unicode cheatCodesArray:@[cheatCodes] addedCheatCodesArray:&addedCheatCodesArray];
//            if (addedCheatCodesArray.count) {
//                NSLog(@"添加新的配置：%@, 最终如下\n[%@] %@", [addedCheatCodesArray componentsJoinedByString:@", "], categorieName, emoji);
//            }
//        }
//    }
//
//    [[AMKEmojiManager sharedManager] writeToFile:@"" atomically:YES];
//}
//
///** 添加emoji映射表 */
//- (void)AMKEmojiHelper_Test4 {
//    NSString *defaultCategoryName = @"Other";
//    NSDictionary *unicodeToCheatCodesMap = [NSDictionary amk_emojiMappingOfUnicodeToCheatCodes];
//    for (NSString *unicode in unicodeToCheatCodesMap) {
//        NSArray  *cheatCodesArray = [unicodeToCheatCodesMap objectForKey:unicode];
//        if (![cheatCodesArray isKindOfClass:[NSArray class]]) {
//            cheatCodesArray = @[cheatCodesArray];
//        }
//        
//        NSString *categoryName = [defaultCategoryName copy];
//        NSArray *addedCheatCodesArray = nil;
//        AMKEmoji *emoji = [[AMKEmojiManager sharedManager] addEmojiWithUnicode:unicode cheatCodesArray:cheatCodesArray defaultCategoryName:&categoryName addedCheatCodesArray:&addedCheatCodesArray];
//        if (addedCheatCodesArray.count) {
//            NSLog(@"添加新的配置：%@, 最终如下\n[%@] %@", [addedCheatCodesArray componentsJoinedByString:@", "], categoryName, emoji);
//        }
//    }
//    [[AMKEmojiManager sharedManager] writeToFile:nil atomically:YES];
//    NSLog(@"%@", [AMKEmojiManager sharedManager]);
//
//}

#pragma mark - AMKLogManager

static int kOriginalStderrHandle = 0;

- (void)AMKLogManager_Test {
    [self AMKLogManager_redirectNSLog];
    
    
//    #define NSLog(FORMAT, ...) printf("%sLine %d: %s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

    
    // 模拟日志输出
    NSLog(@"%@", [NSDate date]);
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSString *string = [[NSDate date] description];
        NSLog(@"%@", string);
        //printf("%s\n", string.UTF8String);
    }];
    
    // 将日志输出重定向回来
    __weak __typeof(self) wekSelf = self;
    [NSTimer scheduledTimerWithTimeInterval:5 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [wekSelf AMKLogManager_restoreNSLog];
    }];
}

/** 重定向日志输出 */
- (void)AMKLogManager_redirectNSLog {
    kOriginalStderrHandle = dup(STDERR_FILENO);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *loggingPath = [documentsPath stringByAppendingPathComponent:@"/mylog.log"];
    NSLog(@"重定向日志输出：%@",loggingPath);
    freopen([loggingPath cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
}

/** 将日志输出重定向回来 */
- (void)AMKLogManager_restoreNSLog {
    dup2(kOriginalStderrHandle, STDERR_FILENO);
    NSLog(@"重定向回默认日志输出");
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
