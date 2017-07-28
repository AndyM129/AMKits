//
//  AMKEmojiManager.m
//  Pods
//
//  Created by Andy on 2017/7/27.
//
//

#import "AMKEmojiManager.h"


@implementation NSString (AMKEmojiManager)

- (instancetype)underlineString {
    NSString *underlineString = nil;
    
    if (self.length) {
        // 若有空格，则以空格分隔，以下划线连接
        NSArray *words = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (words.count) {
            NSMutableArray *lowercaseWords = [NSMutableArray arrayWithCapacity:words.count];
            for (NSString *word in words) {
                [lowercaseWords addObject:word.lowercaseString];
            }
            underlineString = [lowercaseWords componentsJoinedByString:@"_"];
        }
        // 否则按驼峰处理，转为一下划线连接
        else {
            NSMutableString *string = [NSMutableString string];
            for (NSUInteger i = 0; i<self.length; i++) {
                unichar c = [self characterAtIndex:i];
                NSString *cString = [NSString stringWithFormat:@"%c", c];
                NSString *cStringLower = [cString lowercaseString];
                if ([cString isEqualToString:cStringLower]) {
                    [string appendString:cStringLower];
                } else {
                    [string appendString:@"_"];
                    [string appendString:cStringLower];
                }
            }
            underlineString = [string copy];
        }
    }
    
    /*
    if (underlineString.length) {
        for (NSInteger i=0; i<underlineString.length-1; i++) {
            NSRange strRange = NSMakeRange(i, 1);
            NSString *str = [underlineString substringWithRange:strRange];
            if ([str isEqualToString:@"-"]) {
                if (i>0) {
                    if ([underlineString substringWithRange:NSMakeRange(i-1, 1)] i)
                }
                
                underlineString = [underlineString stringByReplacingCharactersInRange:strRange withString:@"_"];
            }
        }
    }
    */
    return underlineString?:self;
}

@end

@implementation AMKEmoji

- (NSMutableArray<NSString *> *)cheatCodesArray {
    if (!_cheatCodesArray) {
        _cheatCodesArray = [NSMutableArray array];
    }
    return _cheatCodesArray;
}

- (BOOL)addCheatCodesArrayWithArray:(NSArray *)array addedCheatCodesArray:(NSArray **)addedCheatCodesArray {
    NSMutableArray *tempAddedCheatCodesArray = nil;
    for (NSString *addedCheatCodes in array) {
        if (![self.cheatCodesArray containsObject:addedCheatCodes]) {
            [self.cheatCodesArray addObject:addedCheatCodes];
            
            if (!tempAddedCheatCodesArray) {
                tempAddedCheatCodesArray = [NSMutableArray array];
            }
            [tempAddedCheatCodesArray addObject:addedCheatCodes];
        }
    }
    *addedCheatCodesArray = tempAddedCheatCodesArray;
    return tempAddedCheatCodesArray.count ? YES : NO;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ => %@", self.unicode, [self.cheatCodesArray componentsJoinedByString:@" , "]];
}

@end



@implementation AMKEmojiCategory

- (NSMutableArray<AMKEmoji *> *)emojis {
    if (!_emojis) {
        _emojis = [NSMutableArray array];
    }
    return _emojis;
}

- (AMKEmoji *)emojiWithUnicode:(NSString *)unicode automaticallyAdd:(BOOL)automaticallyAdd {
    if (unicode && unicode.length) {
        // 根据unicode查找emoji
        __block AMKEmoji *emoji = nil;
        [self.emojis enumerateObjectsUsingBlock:^(AMKEmoji * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.unicode isEqualToString:unicode]) {
                emoji = obj;
                *stop = YES;
            }
        }];
        
        // 若没找到，且自动添加，则创建一个
        if (!emoji && automaticallyAdd) {
            emoji = [[AMKEmoji alloc] init];
            emoji.unicode = unicode;
            [self.emojis addObject:emoji];
        }
        
        return emoji;
    }
    return nil;
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString stringWithFormat:@"[%@]\n", self.name];
    for (AMKEmoji *emoji in self.emojis) {
        [string appendFormat:@"%@\n", emoji];
    }
    return string;
}

@end



@implementation AMKEmojiManager

+ (instancetype)sharedManager {
    static AMKEmojiManager *sharedManager = nil;
    if (!sharedManager) {
        // 优先加载沙盒中的配置（因为可能有自定义新加的字符），若没有则加载bundle中的配置文件
        NSString *plistPath = [self.class sandboxPathForPlist];
        if (plistPath && plistPath.length && [[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
            NSLog(@"加载沙盒中的Emoji配置文件：%@", plistPath);
        } else {
            plistPath = [self.class bundlePathForPlist];
            NSLog(@"加载MainBundle中的Emoji配置文件：%@", plistPath);
        }
        sharedManager = [[AMKEmojiManager alloc] initWithContentsOfFile:plistPath];
    }
    return sharedManager;
}

+ (NSString *)filenameForPlist {
    NSString *filename = [NSString stringWithFormat:@"%@.plist", NSStringFromClass(self.class)];
    return filename;
}

+ (NSString *)sandboxPathForPlist {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    path = [path stringByAppendingPathComponent:[self.class filenameForPlist]];
    return path;
}

+ (NSString *)bundlePathForPlist {
    NSString *path = [[NSBundle mainBundle] pathForResource:[self.class filenameForPlist] ofType:nil inDirectory:@"Frameworks/AMKits.framework"];
    return path;
}

- (instancetype)initWithContentsOfFile:(NSString *)path {
    AMKEmojiManager *manager = [[AMKEmojiManager alloc] init];
    
    NSArray *plist = [NSArray arrayWithContentsOfFile:path];
    if (plist && [plist isKindOfClass:[NSArray class]]) {
        for (NSDictionary *categoryDict in plist) {
            AMKEmojiCategory *category = [[AMKEmojiCategory alloc] init];
            category.name = categoryDict.allKeys.firstObject;
            [manager.categories addObject:category];
            for (NSArray *emojiArray in categoryDict.allValues) {
                for (NSDictionary *emojiDict in emojiArray) {
                    AMKEmoji *emoji = [[AMKEmoji alloc] init];
                    emoji.unicode = emojiDict.allKeys.firstObject;
                    [emoji.cheatCodesArray addObjectsFromArray:emojiDict[emoji.unicode]];
                    [category.emojis addObject:emoji];
                }
            }
        }
    }
    return manager;
}

- (NSMutableArray<AMKEmojiCategory *> *)categories {
    if (!_categories) {
        _categories = [NSMutableArray array];
    }
    return _categories;
}

- (AMKEmojiCategory *)categoryWithName:(NSString *)name automaticallyAdd:(BOOL)automaticallyAdd {
    if (name && name.length) {
        // 根据name查找category
        __block AMKEmojiCategory *category = nil;
        [self.categories enumerateObjectsUsingBlock:^(AMKEmojiCategory * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.name isEqualToString:name]) {
                category = obj;
                *stop = YES;
            }
        }];
        
        // 若没找到，且自动添加，则创建一个
        if (!category && automaticallyAdd) {
            category = [[AMKEmojiCategory alloc] init];
            category.name = name;
            [self.categories addObject:category];
        }
        return category;
    }
    return nil;
}

- (AMKEmoji *)addEmojiWithCategoryName:(NSString *)categoryName unicode:(NSString *)unicode cheatCodesArray:(NSArray *)cheatCodesArray addedCheatCodesArray:(NSArray **)addedCheatCodesArray {
    AMKEmojiCategory *category = [self categoryWithName:categoryName automaticallyAdd:YES];
    AMKEmoji *emoji = [category emojiWithUnicode:unicode automaticallyAdd:YES];
    [emoji addCheatCodesArrayWithArray:cheatCodesArray addedCheatCodesArray:addedCheatCodesArray];
    return emoji;
}

- (AMKEmoji *)addEmojiWithUnicode:(NSString *)unicode cheatCodesArray:(NSArray *)cheatCodesArray defaultCategoryName:(NSString **)defaultCategoryName addedCheatCodesArray:(NSArray **)addedCheatCodesArray {
    AMKEmoji *emoji = nil;
    for (AMKEmojiCategory *category in self.categories) {
        emoji = [category emojiWithUnicode:unicode automaticallyAdd:NO];
        if (emoji) {
            *defaultCategoryName = [category.name copy];
            [emoji addCheatCodesArrayWithArray:cheatCodesArray addedCheatCodesArray:addedCheatCodesArray];
            break;
        }
    }
    
    if (!emoji) {
        AMKEmojiCategory *category = [self categoryWithName:*defaultCategoryName automaticallyAdd:YES];
        AMKEmoji *emoji = [category emojiWithUnicode:unicode automaticallyAdd:YES];
        [emoji addCheatCodesArrayWithArray:cheatCodesArray addedCheatCodesArray:addedCheatCodesArray];
    }
    return emoji;
}



- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile {
    NSMutableArray *rootArray = [NSMutableArray arrayWithCapacity:self.categories.count];
    for (AMKEmojiCategory *category in self.categories) {
        NSMutableArray *categoryArray = [NSMutableArray arrayWithCapacity:category.emojis.count];
        [rootArray addObject:@{category.name: categoryArray}];
        for (AMKEmoji *emoji in category.emojis) {
            [categoryArray addObject:@{emoji.unicode: emoji.cheatCodesArray}];
        }
    }
    if (!path || !path.length) path = [self.class sandboxPathForPlist];
    BOOL successfully = [rootArray writeToFile:path atomically:useAuxiliaryFile];
    NSLog(@"【%@】保存配置到：%@", (successfully?@"成功":@"失败"), path);
    return successfully;
}

- (NSString *)description {
    NSMutableString *string = [NSMutableString stringWithFormat:@""];
    for (AMKEmojiCategory *category in self.categories) {
        [string appendFormat:@"%@\n\n", category];
    }
    return string;
}

@end

