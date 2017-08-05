//
//  NSDictionary+AMKEmojiHelper.m
//  Pods
//
//  Created by Andy on 2017/8/3.
//
//

#import "NSDictionary+AMKEmojiHelper.h"
#import "NSArray+AMKEmojiHelper.h"


@implementation NSDictionary (AMKEmojiHelper)

+ (NSDictionary *)amk_emojiMappingOfUnicodeToCheatCodes {
    static NSDictionary *mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [NSMutableDictionary dictionary];
        for (AMKBaseEmoji *emoji in [NSArray amk_emojisOrderedAscendingByNo]) {
            [(NSMutableDictionary *)mapping setObject:emoji.cheatCodes.firstObject?:@"" forKey:emoji.unicode];
        }
        mapping = [NSDictionary dictionaryWithDictionary:mapping];
    });
    return mapping;
}

+ (NSDictionary *)amk_emojiMappingOfCheatCodesToUnicode {
    static NSDictionary *mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [NSMutableDictionary dictionary];
        for (AMKBaseEmoji *emoji in [NSArray amk_emojisOrderedAscendingByNo]) {
            for (NSString *cheatCodes in emoji.cheatCodes) {
                if (cheatCodes && cheatCodes.length) {
                    [(NSMutableDictionary *)mapping setObject:emoji.unicode forKey:cheatCodes];
                }
            }
        }
        mapping = [NSDictionary dictionaryWithDictionary:mapping];
    });
    return mapping;
}

@end
