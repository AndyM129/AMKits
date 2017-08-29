//
//  NSArray+AMKEmojiHelper.h
//  Pods
//
//  Created by Andy on 2017/8/3.
//
//

#import <Foundation/Foundation.h>
#import "AMKEmojiManager.h"


@interface NSArray (AMKEmojiHelper)

/** 获取所有EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_emojis;

/** 获取所有已根据默认规则排序EmojiModel的数组，用于字符串中Emoji表情的过滤操作 */
+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojis;

/** 获取所有已根据编号升序排序EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojisAscendingByNo;

/** 获取所有已根据编号降序排序EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojisDescendingByNo;

@end
