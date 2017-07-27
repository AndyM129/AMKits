//
//  NSDictionary+AMKEmojiHelper.h
//  Pods
//
//  Created by Andy on 2017/7/27.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AMKEmojiHelper)

/** Emoji 从 Unicode 到 CheatCode 的映射表 */
+ (NSDictionary *)amk_emojiMappingOfUnicodeToCheatCodes;

/** Emoji 从 CheatCode 到 Unicode 的映射表 */
+ (NSDictionary *)amk_emojiMappingOfCheatCodesToUnicode;

@end
