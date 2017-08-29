//
//  AMKEmojiHelperTestViewController.m
//  AMKits
//
//  Created by Andy on 2017/8/4.
//  Copyright © 2017年 AndyM129. All rights reserved.
//

#import "AMKEmojiHelperTestViewController.h"
#import "AMKEmojiHelper.h"

@interface AMKEmojiHelperTestViewController ()

@end

@implementation AMKEmojiHelperTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //[self bulidEmojiManagerFromNetWork:YES];
    //[self testHelperMethods];
    [self testHelperMethods2];
}

- (void)bulidEmojiManagerFromNetWork:(BOOL)fromNetWork {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 联网获取映射
        if (fromNetWork) {
            [[AMKEmojiManager defaultManager] reloadDataWithContentsOfUnicodeEmojiChartsProgress:^(NSInteger totals, NSInteger currentCount) {
                if (totals==NSNotFound && currentCount==NSNotFound) {
                    [SVProgressHUD showWithStatus:@"正在下载Emoji映射..."];
                } else {
                    NSString *status = [NSString stringWithFormat:@"正在解析映射...\n(%ld/%ld)", currentCount, totals];
                    [SVProgressHUD showProgress:1.0*currentCount/totals status:status];
                }
            } completion:^(AMKEmojiManager *emojiManager, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSString *status = [NSString stringWithFormat:@"Emoji映射更新失败: %@", error.description];
                        [SVProgressHUD showErrorWithStatus:status];
                    } else {
                        [emojiManager reloadOrderWithProgress:^(NSInteger totals, NSInteger currentCount) {
                            NSString *status = [NSString stringWithFormat:@"正在排序...\n(%ld/%ld)", currentCount, totals];
                            [SVProgressHUD showProgress:1.0*currentCount/totals status:status];
                        } completion:^(AMKEmojiManager *emojiManager, NSError *error) {
                            [SVProgressHUD showWithStatus:@"完成排序"];
                        }];
                        
                        [SVProgressHUD showWithStatus:@"正在写入文件..."];
                        NSString *filename = [NSString stringWithFormat:@"%@.json", [NSDate date]];
                        NSString *filepath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
                        filepath = [filepath stringByAppendingPathComponent:filename];
                        [emojiManager writeToFile:filepath atomically:YES completion:^(AMKEmojiManager *emojiManager, NSError *error) {
                            if (error) {
                                NSString *status = [NSString stringWithFormat:@"Emoji映射更新失败: %@", error.description];
                                [SVProgressHUD showErrorWithStatus:status];
                            } else {
                                [SVProgressHUD showSuccessWithStatus:@"Emoji映射更新成功"];
                            }
                        }];
                    }
                });
            }];
        }
        // 加载本地文件
        else {
            NSString *filepath = [NSString stringWithFormat:@"%@/Frameworks/AMKits.framework/%@", [NSBundle mainBundle].bundlePath, AMKEmojiMappingFilename];
            [[AMKEmojiManager defaultManager] reloadDataWithContentsOfFile:filepath completion:^(AMKEmojiManager *emojiManager, NSError *error) {
                if (error) {
                    NSString *status = [NSString stringWithFormat:@"Emoji映射更新失败: %@", error.description];
                    [SVProgressHUD showErrorWithStatus:status];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"Emoji映射更新成功"];
                }
            }];
        }
    });
}

- (void)testHelperMethods {
    NSError *error = nil;
    NSString *filename = @"AMKEmojiMapping.json";
    NSString *filepath = [NSString stringWithFormat:@"%@/Frameworks/AMKits.framework/%@", [NSBundle mainBundle].bundlePath, filename];
    [[AMKEmojiManager defaultManager] reloadDataWithContentsOfFile:filepath completion:NULL];
    
    /*
     NSArray *array = [NSArray amk_sortedEmojisDescendingByNo];
     for (AMKBaseEmoji *emoji in array) {
     NSLog(@"No.%g %@", emoji.no, emoji.unicode);
     }
     */
    
    //    NSLog(@"%@", [NSDictionary amk_emojiMappingOfUnicodeToCheatCodes]);
    //    NSLog(@"%@", [NSDictionary amk_emojiMappingOfCheatCodesToUnicode]);
    
    
    // emoji大全的网页
    NSString *testText = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.baobao360.com/fuhao/mobile/emoji.html"] encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"%@", error);
    } else {
        // 验证是否含有emoji
        /*
         BOOL containsEmojiInUnicode = [testText amk_containsEmojiInUnicode];
         BOOL containsEmojiInCheatCodes = [testText amk_containsEmojiInCheatCodes];
         NSLog(@"containsEmojiInUnicode: %@", containsEmojiInUnicode?@"YES":@"NO");
         NSLog(@"containsEmojiInCheatCodes: %@", containsEmojiInCheatCodes?@"YES":@"NO");
         */
        
        // 自定义emoji替换测试
        NSString *replacingEmojiCheatCodesTest1 = [testText amk_stringByReplacingEmojiInUnicodeWithString:^NSString *(NSString *unicode, NSString *cheatCodes, BOOL *stop) {
            return @"";
        }];
        NSLog(@"%@", replacingEmojiCheatCodesTest1);
    }
    
}

- (void)testHelperMethods2 {
    // 加载
    NSError *error = nil;
    NSString *filename = @"AMKEmojiMapping.json";
    NSString *filepath = [NSString stringWithFormat:@"%@/Frameworks/AMKits.framework/%@", [NSBundle mainBundle].bundlePath, filename];
    [[AMKEmojiManager defaultManager] reloadDataWithContentsOfFile:filepath completion:NULL];
    
    // 输出下排序
    NSArray *array = [NSArray amk_sortedEmojis];
    for (AMKBaseEmoji *emoji in array) {
        NSLog(@"No.%g %@ (长度 %ld)", emoji.no, emoji.unicode, emoji.unicode.length);
    }

    // 布局UI
    NSString *emojiString = @"💓💘☸️💞🖤🏁🖍✏️🖋🔗📙😍🙂🙃😐🙄🤔😠😰😩😧😭👹💀🤛🏾🤞🏻👤💪🏻👮🏽‍♀️👨🏽‍🌾👩🏼‍🎓🙅🏽🙎🏻👩‍👩‍👧‍👦👨‍👨‍👧‍👦👩‍👧‍👦👩‍👩‍👦‍👦👨‍👧‍👦👕👡🎩🎒💼🐯🐸🙊🐗🦅🐛🕷🐊🐡🐄🐃🐩🐁🦃🐇🌻🥀🌸🐚🌕🌘🌙🌛❄️⛈💨💧🍈🍌🥑🍑🍤🧀🍟🌮🍢🍨🍰🍵🥄🍽🏈🏐🏹🤾🏻‍♂️🥇🎯🚵🏾🎮🎷🚐🛴🚛🚂🚊🛩🚦🗺🎢🏖🏚🏣🏤🏦🕋🕹💾📀⏲⏳⌛️⚒⛏🔩🕳🔮🛌🖼🎏🏮📪📭📉🗃📗📰🔗✂️🏳🔏🔐💞💖💝🕉♍️♐️♑️🚳🔞❗️❇️🚸🌐🚻📶🆙🆖0️⃣🔟#️⃣⏹⬆️◀️↖️⤴️➖💱💱🔛🔶🔲▪️◻️🔊📢🕒🕗🕚🕣🇭🇰🇩🇿🇪🇪🇦🇹🇧🇬🇧🇭🇮🇸🇷🇺🇫🇷🇫🇴🇫🇯🇬🇵🇬🇩🇭🇹🇨🇲🇨🇨🇰🇲🇨🇰🇷🇼🇲🇹🇲🇼🇲🇲🇲🇽🇸🇸🇯🇵🇳🇫🇷🇸（待处理字符串...）";
    
    UITextView *inputTextView = [[UITextView alloc] init];
    inputTextView.text = @"（待处理字符串...）";
    inputTextView.tag = 1708060026;
    inputTextView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:inputTextView];
    
    UITextView *outputTextView = [[UITextView alloc] init];
    outputTextView.text = @"处理后...";
    outputTextView.editable = NO;
    outputTextView.tag = 1708060027;
    outputTextView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
    outputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view addSubview:outputTextView];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.tag = 1708060028;
    submitButton.backgroundColor = submitButton.tintColor;
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(testHelperMethods2_didClickSubmitBUtton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    
    [inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.right.mas_equalTo(self.view);
    }];
    [outputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(inputTextView.mas_bottom).offset(20);
        make.height.mas_equalTo(inputTextView);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(submitButton.mas_top);
    }];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(testHelperMethods2_clearInputTextView:)];
}

- (void)testHelperMethods2_clearInputTextView:(UIBarButtonItem *)sender {
    UITextView *inputTextView = [self.view viewWithTag:1708060026];
    UITextView *outputTextView = [self.view viewWithTag:1708060027];
    inputTextView.text = @"";
    outputTextView.text = @"";
}

- (void)testHelperMethods2_didClickSubmitBUtton:(UIButton *)sender {
    UITextView *inputTextView = [self.view viewWithTag:1708060026];
    UITextView *outputTextView = [self.view viewWithTag:1708060027];
    NSString *text = inputTextView.text;
    NSString *outputText = [text amk_stringByReplacingEmojiInUnicodeWithString:^NSString *(NSString *unicode, NSString *cheatCodes, BOOL *stop) {
        return nil;//@"  ";
    }];
    outputTextView.text = outputText;
    NSLog(@"%@", outputText);
    [SVProgressHUD showSuccessWithStatus:@"已处理"];
}

@end
