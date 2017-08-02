//
//  AMKEmojiManager.m
//  AMKits
//
//  Created by Andy on 2017/8/1.
//  Copyright © 2017年 AndyM129. All rights reserved.
//

#import "AMKEmojiManager.h"
#import "MJExtension.h"

NSString * const AMKEmojiManagerErrorDomain = @"com.andy.AMKEmojiManager";
NSString * const AMKEmojiManagerErrorFilePathUserInfoKey = @"filePath";

#pragma mark - AMKBaseEmoji

@implementation AMKBaseEmoji

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cldrs" : @"NSString"};
}

+ (AMKSkinTonesEmojiType)skinTonesEmojiTypeWithEmojiInUnicode:(NSString *)unicode {
    if ([unicode containsString:@"🏻"]) return AMKSkinTonesEmojiTypeLight;
    if ([unicode containsString:@"🏼"]) return AMKSkinTonesEmojiTypeMediumLight;
    if ([unicode containsString:@"🏽"]) return AMKSkinTonesEmojiTypeMedium;
    if ([unicode containsString:@"🏾"]) return AMKSkinTonesEmojiTypeMediumDark;
    if ([unicode containsString:@"🏿"]) return AMKSkinTonesEmojiTypeDark;
    return AMKSkinTonesEmojiTypeNormal;
}

- (NSMutableArray<NSString *> *)cheatCodes {
    if (!_cheatCodes) {
        _cheatCodes = [NSMutableArray array];
    }
    return _cheatCodes;
}

@end

#pragma mark - AMKSkinTonesEmoji

@implementation AMKSkinTonesEmoji

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

@end

#pragma mark - AMKEmoji

@implementation AMKEmoji

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"skinTonesEmojis" : @"AMKSkinTonesEmoji"};
}

- (NSMutableArray<AMKSkinTonesEmoji *> *)skinTonesEmojis {
    if (!_skinTonesEmojis) {
        _skinTonesEmojis = [NSMutableArray array];
    }
    return _skinTonesEmojis;
}

@end

#pragma mark - AMKEmojiSubGroup

@implementation AMKEmojiSubGroup

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"emojis" : @"AMKEmoji"};
}

- (NSMutableArray<AMKEmoji *> *)emojis {
    if (!_emojis) {
        _emojis = [NSMutableArray array];
    }
    return _emojis;
}

@end

#pragma mark - AMKEmojiGroup

@implementation AMKEmojiGroup

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"subGroups" : @"AMKEmojiSubGroup"};
}

- (NSMutableArray<AMKEmojiSubGroup *> *)subGroups {
    if (!_subGroups) {
        _subGroups = [NSMutableArray array];
    }
    return _subGroups;
}

@end

#pragma mark - AMKEmojiManager

#import "TFHpple.h"
@implementation AMKEmojiManager

+ (instancetype)defaultManager {
    static AMKEmojiManager *defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[AMKEmojiManager alloc] init];
    });
    return defaultManager;
}

+ (id)mj_replacedKeyFromPropertyName121:(NSString *)propertyName {
    return [propertyName mj_underlineFromCamel];
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"groups" : @"AMKEmojiGroup"};
}

- (void)reloadDataWithContentsOfUnicodeEmojiChartsProgress:(AMKEmojiManagerReloadDataProgressBlock)progressBlock completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock {
    
    // 更新信息
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSString *date = [format stringFromDate:[NSDate date]];
    self.updateTime = date;
    self.version = @"1.0";
    
    // 保存当前解析到的相关对象
    NSError *error = nil;
    AMKEmojiGroup *group = nil;
    AMKEmojiSubGroup *subGroup = nil;
    AMKEmoji *emoji = nil;
    AMKSkinTonesEmoji *skinTonesEmoji = nil;
    
    if (progressBlock) progressBlock(NSNotFound, NSNotFound);
    
    // 联网获取全量Emoji说明
    NSString *url = [NSString stringWithFormat:@"http://www.unicode.org/emoji/charts/full-emoji-list.html"];
    NSURL *URL = [NSURL URLWithString:url];
    NSData *htmlData = [NSData dataWithContentsOfURL:URL];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    
    // 解析出title
    NSArray *titleArray = [xpathParser searchWithXPathQuery:@"//head/title"];
    for (TFHppleElement *title in titleArray) {
        if (title.isTextNode) continue;
        self.name = title.text;
        break;
    }
    
    // 解析Emoji说明的表格
    NSArray *tableArray = [xpathParser searchWithXPathQuery:@"//div[@class='main']/table"];
    
    // 解析出当前Emoji总个数
    NSInteger currentCount = 0; //!< 当前已解析的Emoji数量
    TFHppleElement *fullEmojiMoreInformationTable = (TFHppleElement *)[tableArray objectAtIndex:1];
    NSArray *infoTableTrArray = fullEmojiMoreInformationTable.children;
    for (NSInteger trIndex=infoTableTrArray.count-1; trIndex>=0; trIndex--) {
        TFHppleElement *tr = [infoTableTrArray objectAtIndex:trIndex];
        if (tr.isTextNode || ![tr.tagName isEqualToString:@"tr"]) continue;
        TFHppleElement *td = tr.children.lastObject;
        self.totals = [td.text integerValue];
        if (progressBlock) progressBlock(self.totals, currentCount);
        break;
    }
    
    // 解析Emoji信息
    TFHppleElement *fullEmojiListTable = (TFHppleElement *)[tableArray firstObject];
    NSArray *fullEmojiListTableTrArray = fullEmojiListTable.children;
    for (TFHppleElement *tr in fullEmojiListTableTrArray) {
        if (tr.isTextNode || ![tr.tagName isEqualToString:@"tr"]) continue;
        
        NSInteger tdIndex = -1;
        for (TFHppleElement *td in tr.children) {
            if (td.isTextNode) continue;
            tdIndex ++;
            
            // 提取分组标题
            if ([td.tagName isEqualToString:@"th"]) {
                TFHppleElement *th = td;
                
                // 分组
                if ([th.attributes[@"class"]isEqualToString:@"bighead"]) {
                    group = [[AMKEmojiGroup alloc] init];
                    NSMutableString *groupName = [NSMutableString string];
                    for (TFHppleElement *tag in th.children) {
                        [groupName appendFormat:@"%@", tag.text];
                    }
                    group.name = groupName;
                    [[AMKEmojiManager defaultManager].groups addObject:group];
                }
                // 子分组
                else if ([th.attributes[@"class"] isEqualToString:@"mediumhead"]) {
                    subGroup = [[AMKEmojiSubGroup alloc] init];
                    NSMutableString *subGroupName = [NSMutableString string];
                    for (TFHppleElement *tag in th.children) {
                        [subGroupName appendFormat:@"%@", tag.text];
                    }
                    subGroup.name = subGroupName;
                    [group.subGroups addObject:subGroup];
                }
            }
            // 提取emoji信息
            else if ([td.tagName isEqualToString:@"td"]) {
                if (td.isTextNode) continue;
                
                // unicode
                if (tdIndex == 2) {
                    NSString *unicode = td.text;
                    AMKSkinTonesEmojiType skinTonesEmojiType = [AMKBaseEmoji skinTonesEmojiTypeWithEmojiInUnicode:unicode];
                    if (skinTonesEmojiType == AMKSkinTonesEmojiTypeNormal) {
                        skinTonesEmoji = nil;
                        
                        emoji = [[AMKEmoji alloc] init];
                        emoji.unicode = unicode;
                        [subGroup.emojis addObject:emoji];
                    } else {
                        skinTonesEmoji = [[AMKSkinTonesEmoji alloc] init];
                        skinTonesEmoji.unicode = unicode;
                        skinTonesEmoji.skinTonesEmojiType = skinTonesEmojiType;
                        [emoji.skinTonesEmojis addObject:skinTonesEmoji];
                    }
                    currentCount ++;
                    if (progressBlock) progressBlock(self.totals, currentCount);
                }
                // AMKEmojiSupportVendorApple
                else if (tdIndex == 3) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorApple;
                    }
                }
                // AMKEmojiSupportVendorGoogle
                else if (tdIndex == 4) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorGoogle;
                    }
                }
                // AMKEmojiSupportVendorTwitter
                else if (tdIndex == 5) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorTwitter;
                    }
                }
                // AMKEmojiSupportVendorOne
                else if (tdIndex == 6) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorOne;
                    }
                }
                // AMKEmojiSupportVendorFacebook
                else if (tdIndex == 7) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorFacebook;
                    }
                }
                // AMKEmojiSupportVendorFacebookMobile
                else if (tdIndex == 8) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorFacebookMobile;
                    }
                }
                // AMKEmojiSupportVendorSamsung
                else if (tdIndex == 9) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorSamsung;
                    }
                }
                // AMKEmojiSupportVendorWindows
                else if (tdIndex == 10) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorWindows;
                    }
                }
                // AMKEmojiSupportVendorGmail
                else if (tdIndex == 11) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorGmail;
                    }
                }
                // AMKEmojiSupportVendorSB
                else if (tdIndex == 12) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorSB;
                    }
                }
                // AMKEmojiSupportVendorDCM
                else if (tdIndex == 13) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorDCM;
                    }
                }
                // AMKEmojiSupportVendorKDDI
                else if (tdIndex == 14) {
                    NSString *classStr = [td.attributes objectForKey:@"class"];
                    NSArray *classArray = [classStr componentsSeparatedByString:@" "];
                    BOOL isGoogleSupport = [classArray containsObject:@"miss"] ? NO : YES;
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    if (isGoogleSupport) {
                        baseEmoji.supportVendor = baseEmoji.supportVendor | AMKEmojiSupportVendorKDDI;
                    }
                }
                // CLDR Short Name
                else if (tdIndex == 15) {
                    AMKBaseEmoji *baseEmoji = skinTonesEmoji ?: emoji;
                    baseEmoji.shortName = td.text;
                }
            }
        }
    }
    
    // 返回主线程并执行回调
    if (completionBlock) completionBlock(self, error);
    
}

- (void)reloadDataWithContentsOfFile:(NSString *)path completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock {
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        NSDictionary *keyValues = [json mj_JSONObject];
        AMKEmojiManager *manager = [AMKEmojiManager mj_objectWithKeyValues:keyValues];
        self.name = manager.name;
        self.version = manager.version;
        self.updateTime = manager.updateTime;
        self.totals = manager.totals;
        self.groups = manager.groups;
    } else {
        NSDictionary *userInfo = @{AMKEmojiManagerErrorFilePathUserInfoKey: path};
        error = [NSError errorWithDomain:AMKEmojiManagerErrorDomain code:AMKEmojiManagerErrorOptionsFileNotExists userInfo:userInfo];
    }
    
    // 返回主线程并执行回调
    if (completionBlock) completionBlock(self, error);
}

- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock {
    NSError *error = nil;
    NSDictionary *keyValues = [self mj_keyValues];
    NSString *json = [keyValues mj_JSONString];
    BOOL ok = [json writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!ok) {
        NSLog(@"Update Failed: %@", error);
    } else {
        NSLog(@"Update Success: %@", path);
    }
    
    // 返回主线程并执行回调
    if (completionBlock) completionBlock(self, error);
}

- (void)reloadOrder {
    NSError *error = nil;
    NSInteger no = 0;
    NSURL *URL = [NSURL URLWithString:@"http://www.unicode.org/emoji/charts/emoji-ordering-rules.txt"];
    NSString *text = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (NSInteger lineIndex=6; lineIndex<lines.count; lineIndex++) {
        NSString *line = [lines objectAtIndex:lineIndex];
        if ([line hasPrefix:@"<"]) continue;
        
        // 该行的每个字是一个Emoji
        if ([line hasPrefix:@"<*"]) {
            for (NSInteger index=2; index<line.length-1; index++) {
                no ++;
                NSRange range = NSMakeRange(index, 1);
                NSString *emojiInUnicode = [text substringWithRange:range];
                NSLog(@"No.%ld    %@", no, emojiInUnicode);
            }
        }
        // 该行的Emoji是以 << 分隔的
        else if ([line hasPrefix:@"< "]) {
            text = [text substringFromIndex:2];
            text = [text stringByReplacingOccurrencesOfString:@"=" withString:@"<<"];
            NSArray *emojiInUnicodes = [text componentsSeparatedByString:@" << "];
            for (NSInteger index=0; index<emojiInUnicodes.count; index++) {
                no ++;
                NSString *emojiInUnicode = [emojiInUnicodes objectAtIndex:index];
                NSLog(@"No.%ld    %@", no, emojiInUnicode);
            }
        }
    }
}

- (NSMutableArray<AMKEmojiGroup *> *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

@end
