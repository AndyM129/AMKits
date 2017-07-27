//
//  NSString+AMKEmojiHelper.h
//  Pods
//
//  Created by Andy on 2017/7/27.
//
//

#import <Foundation/Foundation.h>

@interface NSString (AMKEmojiHelper)

/** 是否包含 Unicode-emoji */
- (BOOL)amk_containsEmojiInUnicode;

/** 是否包含 CheatCodes-emoji */
- (BOOL)amk_containsEmojiInCheatCodes;

/** 例如：将"This is a smiley face \U0001F604" 替换为 "This is a smiley face :smiley:" */
- (NSString *)amk_stringByReplacingEmojiUnicodeWithCheatCodes;

/** 例如：将"This is a smiley face :smiley:" 替换为 "This is a smiley face \U0001F604" */
- (NSString *)amk_stringByReplacingEmojiCheatCodesWithUnicode;

/** 将 Unicode-emoji 替换为指定字符串 */
- (NSString *)amk_stringByReplacingEmojiUnicodeWithString:(NSString *(^)(NSString *unicode, NSString *cheatCodes, BOOL *stop))block;

/** 将 CheatCodes-emoji 替换为指定字符串 */
- (NSString *)amk_stringByReplacingEmojiCheatCodesWithString:(NSString *(^)(NSString *cheatCodes, NSString *unicode, BOOL *stop))block;

@end
