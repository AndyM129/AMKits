//
//  NSDictionary+AMKEmojiHelper.m
//  Pods
//
//  Created by Andy on 2017/7/27.
//
//

#import "NSDictionary+AMKEmojiHelper.h"
#import "AMKEmojiManager.h"


@implementation NSDictionary (AMKEmojiHelper)

+ (NSDictionary *)amk_emojiMappingOfUnicodeToCheatCodes {
    static NSDictionary *mapping = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapping = [NSMutableDictionary dictionary];
        for (AMKEmojiCategory *category in [AMKEmojiManager sharedManager].categories) {
            for (AMKEmoji *emoji in category.emojis) {
                [(NSMutableDictionary *)mapping setObject:emoji.cheatCodesArray forKey:emoji.unicode];
            }
        }
    });
    return mapping;
}

+ (NSDictionary *)amk_emojiMappingOfCheatCodesToUnicode {
    static NSDictionary *emojiMappingOfCheatCodesToUnicode = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *emojiMappingOfUnicodeToCheatCodes = [NSDictionary amk_emojiMappingOfUnicodeToCheatCodes];
        emojiMappingOfCheatCodesToUnicode = [NSMutableDictionary dictionaryWithCapacity:emojiMappingOfUnicodeToCheatCodes.count];
        [emojiMappingOfUnicodeToCheatCodes enumerateKeysAndObjectsUsingBlock:^(NSString *unicode, NSArray *cheatCodesArray, BOOL *stop) {
            if (![cheatCodesArray isKindOfClass:[NSArray class]]) {
                cheatCodesArray = @[cheatCodesArray];
            }
            
            if ([cheatCodesArray isKindOfClass:[NSArray class]]) {
                for (NSString *cheatCodes in cheatCodesArray) {
                    if (cheatCodes.length) {
                        [(NSMutableDictionary *)emojiMappingOfCheatCodesToUnicode setObject:cheatCodes forKey:unicode];
                    }
                }
            }
        }];
        emojiMappingOfCheatCodesToUnicode = [NSDictionary dictionaryWithDictionary:emojiMappingOfCheatCodesToUnicode];
    });
    return emojiMappingOfCheatCodesToUnicode;
}

@end
