//
//  NSString+AMKEmojiHelper.m
//  Pods
//
//  Created by Andy on 2017/7/27.
//
//

#import "NSString+AMKEmojiHelper.h"
#import "NSDictionary+AMKEmojiHelper.h"


@implementation NSString (AMKEmojiHelper)

- (BOOL)amk_containsEmojiInUnicode {
    __block BOOL contains = NO;
    [self amk_stringByReplacingEmojiUnicodeWithString:^NSString *(NSString *unicode, NSString *cheatCodes, BOOL *stop) {
        contains = YES;
        *stop = YES;
        return nil;
    }];
    return contains;
}

- (BOOL)amk_containsEmojiInCheatCodes {
    __block BOOL contains = NO;
    [self amk_stringByReplacingEmojiCheatCodesWithString:^NSString *(NSString *cheatCodes, NSString *unicode, BOOL *stop) {
        contains = YES;
        *stop = YES;
        return nil;
    }];
    return contains;
}

- (NSString *)amk_stringByReplacingEmojiUnicodeWithCheatCodes {
    return [self amk_stringByReplacingEmojiUnicodeWithString:^NSString *(NSString *unicode, NSString *cheatCodes, BOOL *stop) {
        return cheatCodes;
    }];
}

- (NSString *)amk_stringByReplacingEmojiCheatCodesWithUnicode {
    return [self amk_stringByReplacingEmojiCheatCodesWithString:^NSString *(NSString *cheatCodes, NSString *unicode, BOOL *stop) {
        return unicode;
    }];
}

- (NSString *)amk_stringByReplacingEmojiUnicodeWithString:(NSString *(^)(NSString *, NSString *, BOOL *))block {
    if (self.length) {
        __block NSString *withString = nil;
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [[NSDictionary amk_emojiMappingOfUnicodeToCheatCodes] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            BOOL stopReplacing = NO;
            withString = block(key, ([obj isKindOfClass:[NSArray class]] ? [obj firstObject] : obj), &stopReplacing) ?: @"";
            if (!stopReplacing) {
                [newText replaceOccurrencesOfString:key withString:withString options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
            } else {
                *stop = YES;
            }
        }];
        return newText;
    }
    return self;
}

- (NSString *)amk_stringByReplacingEmojiCheatCodesWithString:(NSString *(^)(NSString *, NSString *, BOOL *))block {
    if ([self rangeOfString:@":"].location != NSNotFound) {
        __block NSString *withString = nil;
        __block NSMutableString *newText = [NSMutableString stringWithString:self];
        [[NSDictionary amk_emojiMappingOfCheatCodesToUnicode] enumerateKeysAndObjectsUsingBlock:^(NSString *key, id obj, BOOL *stop) {
            BOOL stopReplacing = NO;
            withString = block(key, obj, &stopReplacing) ?: @"";
            if (!stopReplacing) {
                [newText replaceOccurrencesOfString:key withString:withString options:NSLiteralSearch range:NSMakeRange(0, newText.length)];
            } else {
                *stop = YES;
            }
        }];
        return newText;
    }
    return self;
}

@end
