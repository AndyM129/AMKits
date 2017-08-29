//
//  NSArray+AMKEmojiHelper.m
//  Pods
//
//  Created by Andy on 2017/8/3.
//
//

#import "NSArray+AMKEmojiHelper.h"


@implementation NSArray (AMKEmojiHelper)

+ (NSArray<AMKBaseEmoji *> *)amk_emojis {
    static NSArray<AMKBaseEmoji *> *emojis = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AMKEmojiManager *manager = [AMKEmojiManager defaultManager];
        emojis = [NSMutableArray arrayWithCapacity:manager.totals];
        for (AMKEmojiGroup *group in manager.groups) {
            for (AMKEmojiSubGroup *subGroup in group.subGroups) {
                for (AMKEmoji *emoji in subGroup.emojis) {
                    [(NSMutableArray *)emojis addObject:emoji];
                    if (emoji.skinTonesEmojis) {
                        [(NSMutableArray *)emojis addObjectsFromArray:emoji.skinTonesEmojis];
                    }
                }
            }
        }
        emojis = [emojis copy];
    });
    return emojis;
}

+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojis {
    static NSArray<AMKBaseEmoji *> *emojis = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojis = [[self.class amk_emojis] sortedArrayUsingComparator:^NSComparisonResult(AMKBaseEmoji *emoji1, AMKBaseEmoji *emoji2) {
            if (emoji1.unicode.length > emoji2.unicode.length) return NSOrderedAscending;
            if (emoji1.unicode.length < emoji2.unicode.length) return NSOrderedDescending;
            if (emoji1.no > emoji2.no) return NSOrderedAscending;
            if (emoji1.no < emoji2.no) return NSOrderedDescending;
            return NSOrderedSame;
        }];
    });
    return emojis;
}

+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojisAscendingByNo {
    static NSArray<AMKBaseEmoji *> *emojis = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojis = [[self.class amk_emojis] sortedArrayUsingComparator:^NSComparisonResult(AMKBaseEmoji *emoji1, AMKBaseEmoji *emoji2) {
            if (emoji1.no > emoji2.no) return NSOrderedDescending;
            if (emoji1.no < emoji2.no) return NSOrderedAscending;
            return NSOrderedSame;
        }];
    });
    return [emojis copy];
}

+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojisDescendingByNo {
    static NSArray<AMKBaseEmoji *> *emojis = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        emojis = [[self.class amk_emojis] sortedArrayUsingComparator:^NSComparisonResult(AMKBaseEmoji *emoji1, AMKBaseEmoji *emoji2) {
            if (emoji1.no > emoji2.no) return NSOrderedAscending;
            if (emoji1.no < emoji2.no) return NSOrderedDescending;
            return NSOrderedSame;
        }];
    });
    return emojis;
}

@end
