//
//  AMKEmojiHelperDemo.m
//  AMKits
//
//  Created by Andy on 2017/8/1.
//  Copyright © 2017年 AndyM129. All rights reserved.
//

#import "AMKEmojiHelperDemo.h"
#import "MJExtension.h"
#import "AMKEmojiManager.h"


@interface AMKEmojiHelperDemo ()

@end

@implementation AMKEmojiHelperDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSStringFromClass(self.class);
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self buildConf];
    //[self getEmojiOrderingRulesTxt];
    [self bulidEmojiManagerFromNetWork:YES];
}

/** http://www.unicode.org/emoji/charts/emoji-ordering-rules.txt */
- (void)getEmojiOrderingRulesTxt {
    NSError *error = nil;
    NSURL *URL = [NSURL URLWithString:@"http://www.unicode.org/emoji/charts/emoji-ordering-rules.txt"];
    NSString *text = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"%@", text);
}

/** 设计配置文件结构 */
- (void)buildConf {
    // 基本信息
    NSMutableDictionary *conf = [NSMutableDictionary dictionary];
    conf[@"title"] = @"emoji映射";
    conf[@"version"] = @"0.1.0";
    conf[@"updateTime"] = @"2017-08-01 00:00";

    // 分类数组
    NSMutableArray *groups = [NSMutableArray array];
    conf[@"groups"] = groups;
    
    // 每一个分组
    NSMutableDictionary *group = [NSMutableDictionary dictionary];
    group[@"name"] = @"Smileys & People";
    group[@"icon"] = @"图标";
    [groups addObject:group];
    
    // 每一个子分组
    NSMutableDictionary *subgroups = [NSMutableDictionary dictionary];
    group[@"subgroups"] = subgroups;

    // 分类中的emoji元素数组
    NSMutableArray *emojis = [NSMutableArray array];
    subgroups[@"emojis"] = emojis;
    
    // 每一个emoji元素
    NSMutableDictionary *emoji = [NSMutableDictionary dictionary];
    emoji[@"unicode"] = @"👨";  //!< emoji
    emoji[@"support"] = @{      //!< 各方对该表情是否支持
                          @"Apple" : @YES,
                          @"Google" : @YES,
                          };
    emoji[@"no"] = @123;    //!< 序号，用于emoji查找的优先级
    emoji[@"cldr"] = @[@":man:"];   //!<
    emoji[@"skinTones"] = @[@"👨🏻", @"👨🏾"];
    [emojis addObject:emoji];
    
    NSLog(@"%@", conf);
}

- (void)bulidEmojiManagerFromNetWork:(BOOL)fromNetWork {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AMKEmojiManagerReloadDataCompletionBlock completionBlock = ^(AMKEmojiManager *emojiManager, NSError *error) {
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
        };
        
        // 联网获取映射
        if (fromNetWork) {
            [[AMKEmojiManager defaultManager] reloadDataWithContentsOfUnicodeEmojiChartsProgress:^(NSInteger totals, NSInteger currentCount) {
                if (totals==NSNotFound && currentCount==NSNotFound) {
                    [SVProgressHUD showWithStatus:@"正在下载Emoji映射..."];
                } else {
                    NSString *status = [NSString stringWithFormat:@"正在解析映射...\n(%ld/%ld)", currentCount, totals];
                    [SVProgressHUD showProgress:1.0*currentCount/totals status:status];
                }
            } completion:completionBlock];
        }
        // 加载本地文件
        else {
            NSString *filename = @"AMKEmojiConf.json";
            NSString *filepath = [[NSBundle mainBundle] pathForResource:filename ofType:nil inDirectory:@""];
            [[AMKEmojiManager defaultManager] reloadDataWithContentsOfFile:filepath completion:completionBlock];
        }
    });
}


@end
