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
        [[NSArray amk_emojisOrderedDescendingByNo] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
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
        [[NSArray amk_emojisOrderedDescendingByNo] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
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
        __block NSString *withString = nil;
        [[NSArray amk_emojisOrderedDescendingByNo] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL stopReplacing = NO;
            NSString *cheatCodes = emoji.cheatCodes.firstObject ?: @"";
            NSString *unicode = emoji.unicode;
            withString = block(unicode, cheatCodes, &stopReplacing) ?: @"";
            if (!stopReplacing) {
                [newText replaceOccurrencesOfString:unicode withString:withString options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
            } else {
                *stop = YES;
            }
        }];
    }
    return newText;
}

- (NSString *)amk_stringByReplacingEmojiInCheatCodesWithString:(NSString *(^)(NSString *, NSString *, BOOL *))block {
    __block NSString *withString = nil;
    __block NSMutableString *newText = [NSMutableString stringWithString:self];
    [[NSArray amk_emojisOrderedDescendingByNo] enumerateObjectsUsingBlock:^(AMKBaseEmoji *emoji, NSUInteger idx, BOOL * _Nonnull stop) {
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
