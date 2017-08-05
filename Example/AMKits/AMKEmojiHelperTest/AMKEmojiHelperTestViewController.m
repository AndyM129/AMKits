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
    [self testHelperMethods];
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
                        [emojiManager reloadOrder];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSString *status = [NSString stringWithFormat:@"Emoji映射更新失败: %@", error.description];
                        [SVProgressHUD showErrorWithStatus:status];
                    } else {
                        [SVProgressHUD showSuccessWithStatus:@"Emoji映射更新成功"];
                    }
                });
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
    NSArray *array = [NSArray amk_emojisOrderedDescendingByNo];
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

@end
