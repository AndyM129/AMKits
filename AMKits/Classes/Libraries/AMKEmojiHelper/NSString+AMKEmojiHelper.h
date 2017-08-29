//
//  NSString+AMKEmojiHelper.h
//  Pods
//
//  Created by Andy on 2017/8/3.
//
//

#import <Foundation/Foundation.h>

@interface NSString (AMKEmojiHelper)

/** 是否包含 Unicode-emoji */
- (BOOL)amk_containsEmojiInUnicode;

/** 是否包含 CheatCodes-emoji */
- (BOOL)amk_containsEmojiInCheatCodes;

/** 例如：将"This is a smiley face \U0001F604" 替换为 "" */
- (NSString *)amk_stringByRemovingEmojiInUnicode;

/** 例如：将"This is a smiley face :smiley:" 替换为 "" */
- (NSString *)amk_stringByRemovingEmojiInCheatCodes;

/** 例如：将"This is a smiley face \U0001F604" 替换为 "This is a smiley face :smiley:" */
- (NSString *)amk_stringByReplacingEmojiInUnicodeWithCheatCodes;

/** 例如：将"This is a smiley face :smiley:" 替换为 "This is a smiley face \U0001F604" */
- (NSString *)amk_stringByReplacingEmojiInCheatCodesWithUnicode;

/** 将 Unicode-emoji 替换为指定字符串 */
- (NSString *)amk_stringByReplacingEmojiInUnicodeWithString:(NSString *(^)(NSString *unicode, NSString *cheatCodes, BOOL *stop))block;

/** 将 CheatCodes-emoji 替换为指定字符串 */
- (NSString *)amk_stringByReplacingEmojiInCheatCodesWithString:(NSString *(^)(NSString *cheatCodes, NSString *unicode, BOOL *stop))block;

@end
