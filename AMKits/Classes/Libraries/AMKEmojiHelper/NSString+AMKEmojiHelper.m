//
//  NSString+AMKEmojiHelper.m
//  Pods
//
//  Created by Andy on 2017/8/3.
//
//

#import "NSString+AMKEmojiHelper.h"
#import "NSArray+AMKEmojiHelper.h"


@implementation NSString (AMKEmojiHelper)

- (BOOL)amk_containsEmojiInUnicode {
    if (self.length) {
        __block BOOL contains = NO;
        [[NSArray amk_sortedEmojis] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *unicode = emoji.unicode;
            if ([self rangeOfString:unicode].location != NSNotFound) {
                contains = YES;
                *stop = YES;
            }
        }];
        return contains;
    }
    return NO;
}

- (BOOL)amk_containsEmojiInCheatCodes {
    if (self.length) {
        __block BOOL contains = NO;
        [[NSArray amk_sortedEmojis] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
            for (NSString *cheatCodes in emoji.cheatCodes) {
                if (cheatCodes && cheatCodes.length && [self rangeOfString:cheatCodes].location != NSNotFound) {
                    contains = YES;
                    *stop = YES;
                }
            }
        }];
        return contains;
    }
    return NO;
}

- (NSString *)amk_stringByRemovingEmojiInUnicode {
    return [self amk_stringByReplacingEmojiInUnicodeWithString:^NSString *(NSString *unicode, NSString *cheatCodes, BOOL *stop) {
        return nil;
    }];
}

- (NSString *)amk_stringByRemovingEmojiInCheatCodes {
    return [self amk_stringByReplacingEmojiInCheatCodesWithString:^NSString *(NSString *cheatCodes, NSString *unicode, BOOL *stop) {
        return nil;
    }];
}

- (NSString *)amk_stringByReplacingEmojiInUnicodeWithCheatCodes {
    return [self amk_stringByReplacingEmojiInUnicodeWithString:^NSString *(NSString *unicode, NSString *cheatCodes, BOOL *stop) {
        return cheatCodes;
    }];
}

- (NSString *)amk_stringByReplacingEmojiInCheatCodesWithUnicode {
    return [self amk_stringByReplacingEmojiInCheatCodesWithString:^NSString *(NSString *cheatCodes, NSString *unicode, BOOL *stop) {
        return unicode;
    }];
}

- (NSString *)amk_stringByReplacingEmojiInUnicodeWithString:(NSString *(^)(NSString *, NSString *, BOOL *))block {
    __block NSMutableString *newText = [NSMutableString stringWithString:self];
    if (newText.length) {
        if (kAMKEmojiManagerDebugEnable) NSLog(@"处理字符串(长度 %ld)", newText.length);
        if (kAMKEmojiManagerDebugEnable) NSLog(@"            %@", newText);
        
        __block NSString *withString = nil;
        [[NSArray amk_sortedEmojis] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL stopReplacing = NO;
            NSString *cheatCodes = emoji.cheatCodes.firstObject ?: @"";
            NSString *unicode = emoji.unicode;
            
            if ([newText containsString:unicode]) {
                withString = block(unicode, cheatCodes, &stopReplacing) ?: @"";
                if (!stopReplacing) {
                    [newText replaceOccurrencesOfString:unicode withString:withString options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
                } else {
                    *stop = YES;
                }
                if (kAMKEmojiManagerDebugEnable) NSLog(@"去除 [%@] 后：%@", unicode, newText);
            }
            
            static NSString *kSuffixStr = @"️";
            unicode = [emoji.unicode hasSuffix:kSuffixStr]
            ? [emoji.unicode substringToIndex:emoji.unicode.length-kSuffixStr.length]
            : [emoji.unicode stringByAppendingString:kSuffixStr];
            if ([newText containsString:unicode]) {
                withString = block(unicode, cheatCodes, &stopReplacing) ?: @"";
                if (!stopReplacing) {
                    [newText replaceOccurrencesOfString:unicode withString:withString options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
                } else {
                    *stop = YES;
                }
                if (kAMKEmojiManagerDebugEnable) NSLog(@"去除 [%@] 后：%@", unicode, newText);
            }
        }];
    }
    return newText;
}

- (NSString *)amk_stringByReplacingEmojiInCheatCodesWithString:(NSString *(^)(NSString *, NSString *, BOOL *))block {
    __block NSString *withString = nil;
    __block NSMutableString *newText = [NSMutableString stringWithString:self];
    [[NSArray amk_sortedEmojis] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
        if (emoji.cheatCodes.count) {
            BOOL stopReplacing = NO;
            NSString *cheatCodes = emoji.cheatCodes.firstObject;
            NSString *unicode = emoji.unicode;
            withString = block(cheatCodes, unicode, &stopReplacing) ?: @"";
            if (!stopReplacing) {
                [newText replaceOccurrencesOfString:cheatCodes withString:withString options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
            } else {
                *stop = YES;
            }
        }
    }];
    return newText;
}

@end
