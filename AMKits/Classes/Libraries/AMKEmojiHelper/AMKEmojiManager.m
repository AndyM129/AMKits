//
//  AMKEmojiManager.m
//  AMKits
//
//  Created by Andy on 2017/8/1.
//  Copyright © 2017年 AndyM129. All rights reserved.
//

#import "AMKEmojiManager.h"
#import "YYModel.h"

NSString * const AMKEmojiMappingFilename = @"AMKEmojiMapping.json";
NSString * const AMKUnicodeEmojiChartsUrl = @"http://www.unicode.org/emoji/charts/full-emoji-list.html";
NSString * const AMKUnicodeEmojiOrderingRulesUrl = @"http://www.unicode.org/emoji/charts/emoji-ordering-rules.txt";
NSString * const AMKEmojiManagerErrorDomain = @"com.andy.AMKEmojiManager";
NSString * const AMKEmojiManagerErrorFilePathUserInfoKey = @"filePath";

#pragma mark - AMKBaseEmoji

@implementation AMKBaseEmoji

- (NSMutableArray<NSString *> *)cheatCodes {
    if (!_cheatCodes) {
        _cheatCodes = [NSMutableArray array];
    }
    return _cheatCodes;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"No.%g %@ (%@ - %ld) => %@", self.no, self.unicode, self.shortName, self.supportVendor, [self.cheatCodes componentsJoinedByString:@"、"]];
}

- (NSComparisonResult)compareWithNo:(AMKBaseEmoji *)emoji {
    if (self.no > emoji.no) return NSOrderedDescending;
    if (self.no < emoji.no) return NSOrderedAscending;
    return NSOrderedSame;
}

#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"unicode" : @"unicode",
             @"shortName" : @"short_name",
             @"supportVendor" : @"support_vendor",
             @"cheatCodes" : @"cheat_codes",
             @"no" : @"no"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"cheatCodes" : @"NSString"};
}

+ (AMKSkinTonesEmojiType)skinTonesEmojiTypeWithEmojiInUnicode:(NSString *)unicode {
    static NSData *dataForSkinTonesEmojiTypeLight;
    static NSData *dataForSkinTonesEmojiTypeMediumLight;
    static NSData *dataForSkinTonesEmojiTypeMedium;
    static NSData *dataForSkinTonesEmojiTypeMediumDark;
    static NSData *dataForSkinTonesEmojiTypeDark;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataForSkinTonesEmojiTypeLight          = [@"🏻" dataUsingEncoding:NSUTF8StringEncoding];
        dataForSkinTonesEmojiTypeMediumLight    = [@"🏼" dataUsingEncoding:NSUTF8StringEncoding];
        dataForSkinTonesEmojiTypeMedium         = [@"🏽" dataUsingEncoding:NSUTF8StringEncoding];
        dataForSkinTonesEmojiTypeMediumDark     = [@"🏾" dataUsingEncoding:NSUTF8StringEncoding];
        dataForSkinTonesEmojiTypeDark           = [@"🏿" dataUsingEncoding:NSUTF8StringEncoding];
    });

    NSData *unicodeData = [unicode dataUsingEncoding:NSUTF8StringEncoding];
    if ([unicodeData rangeOfData:dataForSkinTonesEmojiTypeLight options:NSDataSearchBackwards range:NSMakeRange(0, unicodeData.length)].location != NSNotFound) {
        return AMKSkinTonesEmojiTypeLight;
    }
    if ([unicodeData rangeOfData:dataForSkinTonesEmojiTypeMediumLight options:NSDataSearchBackwards range:NSMakeRange(0, unicodeData.length)].location != NSNotFound) {
        return AMKSkinTonesEmojiTypeMediumLight;
    }
    if ([unicodeData rangeOfData:dataForSkinTonesEmojiTypeMedium options:NSDataSearchBackwards range:NSMakeRange(0, unicodeData.length)].location != NSNotFound) {
        return AMKSkinTonesEmojiTypeMedium;
    }
    if ([unicodeData rangeOfData:dataForSkinTonesEmojiTypeMediumDark options:NSDataSearchBackwards range:NSMakeRange(0, unicodeData.length)].location != NSNotFound) {
        return AMKSkinTonesEmojiTypeMediumDark;
    }
    if ([unicodeData rangeOfData:dataForSkinTonesEmojiTypeDark options:NSDataSearchBackwards range:NSMakeRange(0, unicodeData.length)].location != NSNotFound) {
        return AMKSkinTonesEmojiTypeDark;
    }
    return AMKSkinTonesEmojiTypeNormal;
}

@end

#pragma mark - AMKSkinTonesEmoji

@implementation AMKSkinTonesEmoji

- (NSString *)description {
    return [NSString stringWithFormat:@"No.%g %@ (%@ - %ld - %ld) => %@", self.no, self.unicode, self.shortName, self.supportVendor, self.skinTonesEmojiType, [self.cheatCodes componentsJoinedByString:@"、"]];
}

#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"skinTonesEmojiType" : @"skin_tones_emoji_type"};
}

@end

#pragma mark - AMKEmoji

@implementation AMKEmoji

- (NSMutableArray<AMKSkinTonesEmoji *> *)skinTonesEmojis {
    if (!_skinTonesEmojis) {
        _skinTonesEmojis = [NSMutableArray array];
    }
    return _skinTonesEmojis;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"No.%g %@ (%@ - %ld) => %@, %@", self.no, self.unicode, self.shortName, self.supportVendor, [self.cheatCodes componentsJoinedByString:@"、"], self.skinTonesEmojis];
}

#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"skinTonesEmojis" : @"skin_tones_emojis"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"skinTonesEmojis" : @"AMKSkinTonesEmoji"};
}

@end

#pragma mark - AMKEmojiSubGroup

@implementation AMKEmojiSubGroup

- (NSMutableArray<AMKEmoji *> *)emojis {
    if (!_emojis) {
        _emojis = [NSMutableArray array];
    }
    return _emojis;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"## %@ %@", self.name, self.emojis];
}

#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"name",
             @"emojis" : @"emojis"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"emojis" : @"AMKEmoji"};
}

@end

#pragma mark - AMKEmojiGroup

@implementation AMKEmojiGroup

- (NSMutableArray<AMKEmojiSubGroup *> *)subGroups {
    if (!_subGroups) {
        _subGroups = [NSMutableArray array];
    }
    return _subGroups;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"# %@ %@", self.name, self.subGroups];
}

#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"name",
             @"icon" : @"icon",
             @"subGroups" :@"sub_groups"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"subGroups" : @"AMKEmojiSubGroup"};
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
        
        NSString *path = [[NSBundle mainBundle] pathForResource:AMKEmojiMappingFilename ofType:nil];
        [defaultManager reloadDataWithContentsOfFile:path completion:^(AMKEmojiManager *emojiManager, NSError *error) {
            NSLog(@"Emoji映射加载完毕: %@", path);
        }];
    });
    return defaultManager;
}

- (NSMutableArray<AMKEmojiGroup *> *)groups {
    if (!_groups) {
        _groups = [NSMutableArray array];
    }
    return _groups;
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
    NSString *url = [NSString stringWithFormat:AMKUnicodeEmojiChartsUrl];
    NSURL *URL = [NSURL URLWithString:url];
    NSData *htmlData = [NSData dataWithContentsOfURL:URL];
    if (!htmlData.length) {
        NSError *error = [NSError errorWithDomain:AMKEmojiManagerErrorDomain code:AMKEmojiManagerErrorOptionsDataEmpty userInfo:nil];
        completionBlock==nil ?: completionBlock(self, error);
        return;
    }
    
    // 解析出title
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
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
    if (tableArray.count >= 2) {
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
    } else {
        NSError *error = [NSError errorWithDomain:AMKEmojiManagerErrorDomain code:AMKEmojiManagerErrorOptionsDataEmpty userInfo:nil];
        NSLog(@"%@", error);
        progressBlock==nil ?: progressBlock(NSNotFound, currentCount);
    }
    
    // 解析Emoji信息
    TFHppleElement *fullEmojiListTable = (TFHppleElement *)[tableArray firstObject];
    NSArray *fullEmojiListTableTrArray = fullEmojiListTable.children;
    if (!fullEmojiListTable || !fullEmojiListTableTrArray.count) {
        NSError *error = [NSError errorWithDomain:AMKEmojiManagerErrorDomain code:AMKEmojiManagerErrorOptionsEmojiListNotFound userInfo:nil];
        completionBlock==nil ?: completionBlock(self, error);
        return;
    }
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
    
    if (completionBlock) completionBlock(self, error);
}

- (void)reloadDataWithContentsOfFile:(NSString *)path completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock {
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSString *json = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        AMKEmojiManager *manager = [AMKEmojiManager yy_modelWithJSON:json];
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
    NSString *json = [self yy_modelToJSONString];
    BOOL ok = [json writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (!ok) {
        NSLog(@"Update Failed: %@", error);
    } else {
        NSLog(@"Update Success: %@", path);
    }
    
    // 返回主线程并执行回调
    if (completionBlock) completionBlock(self, error);
}

- (void)reloadOrderWithProgress:(AMKEmojiManagerReloadDataProgressBlock)progressBlock completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock {
    NSError *error = nil;
    AMKBaseEmoji *emoji = nil;
    NSInteger no = 1;
    __block NSInteger currentCount = 0;
    
    // 1. 加载《表情符号排序规则》排序
    NSURL *URL = [NSURL URLWithString:AMKUnicodeEmojiOrderingRulesUrl];
    NSString *text = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:&error];
    if (!text || !text.length) {
        NSError *error = [NSError errorWithDomain:AMKEmojiManagerErrorDomain code:AMKEmojiManagerErrorOptionsDataEmpty userInfo:nil];
        completionBlock==nil ?: completionBlock(self, error);
        return;
    }
    
    // 2. 根据《表情符号排序规则》排序
    BOOL(^__setEmojiNo)(NSString *, NSInteger, AMKBaseEmoji **) = ^(NSString *emojiInUnicode, NSInteger no, AMKBaseEmoji **theEmoji){
        *theEmoji = nil;
        
        for (AMKEmojiGroup *group in self.groups) {
            for (AMKEmojiSubGroup *subGroup in group.subGroups) {
                for (AMKEmoji *emoji in subGroup.emojis) {
                    
                    // 基础emoji
                    if ([emoji.unicode isEqualToString:emojiInUnicode]) {
                        emoji.no = no;
                        *theEmoji = emoji;
                        progressBlock == nil ?: progressBlock(self.totals, ++currentCount);
                        
                        // 当基础emoji有带色调的emoji时，将色调信息以小数位数值体现
                        for (AMKSkinTonesEmoji *skinTonesEmoji in emoji.skinTonesEmojis) {
                            skinTonesEmoji.no = emoji.no + skinTonesEmoji.skinTonesEmojiType*0.1;
                            progressBlock == nil ?: progressBlock(self.totals, ++currentCount);
                        }
                        return YES;
                    }
                }
            }
        }
        return NO;
    };
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    for (NSInteger lineIndex=0; lineIndex<lines.count; lineIndex++) {
        NSString *line = [lines objectAtIndex:lineIndex];

        // 该行的每个字是一个Emoji
        if ([line hasPrefix:@"<*"]) {
            NSRange range;
            for (NSInteger index=2; index<line.length; index+=range.length) {
                range = [line rangeOfComposedCharacterSequenceAtIndex:index];
                NSString *emojiInUnicode = [line substringWithRange:range];
                if (__setEmojiNo(emojiInUnicode, no, &emoji)) {
                    no ++;
                    NSLog(@"No.%ld\t%@", no, emojiInUnicode);
                }
            }
        }
        // 该行的Emoji是以 << 分隔的
        else if ([line hasPrefix:@"< "]) {
            line = [line substringFromIndex:2];
            line = [line stringByReplacingOccurrencesOfString:@"=" withString:@"<<"];
            NSArray *emojiInUnicodes = [line componentsSeparatedByString:@" << "];
            for (NSInteger index=0; index<emojiInUnicodes.count; index++) {
                NSString *emojiInUnicode = [emojiInUnicodes objectAtIndex:index];
                if (__setEmojiNo(emojiInUnicode, no, &emoji)) {
                    no ++;
                    NSLog(@"No.%ld\t%@", no, emojiInUnicode);
                }
            }
        }
    }
    
    // 3. 查漏补缺，找出未编号的表情，以单独的号段递增补充排序
    no = 10000;
    for (AMKEmojiGroup *group in self.groups) {
        for (AMKEmojiSubGroup *subGroup in group.subGroups) {
            for (AMKEmoji *emoji in subGroup.emojis) {
                if (emoji.no > 0) continue;
                NSLog(@"No.%ld\t%@", no, emoji.unicode);
                
                emoji.no = no;
                progressBlock == nil ?: progressBlock(self.totals, ++currentCount);

                for (AMKSkinTonesEmoji *skinTonesEmoji in emoji.skinTonesEmojis) {
                    skinTonesEmoji.no = emoji.no + skinTonesEmoji.skinTonesEmojiType*0.1;
                    progressBlock == nil ?: progressBlock(self.totals, ++currentCount);
                }
                no ++;
            }
        }
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@\nversion: %@\nupdateTime: %@\ntotals: %ld%@", self.name, self.version, self.updateTime, self.totals, self.groups];
}

#pragma mark YYModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name" : @"name",
             @"version" : @"version",
             @"updateTime" :@"update_time",
             @"totals" : @"totals",
             @"groups" : @"groups"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"groups" : @"AMKEmojiGroup"};
}

@end
