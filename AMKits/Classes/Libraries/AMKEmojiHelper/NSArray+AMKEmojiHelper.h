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

/** 获取所有已根据编号升序排序EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_emojisOrderedAscendingByNo;

/** 获取所有已根据编号降序排序EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_emojisOrderedDescendingByNo;

@end
