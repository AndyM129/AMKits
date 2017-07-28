//
//  AMKEmojiManager.h
//  Pods
//
//  Created by Andy on 2017/7/27.
//
//

#import <Foundation/Foundation.h>

@interface NSString (AMKEmojiManager)
- (instancetype)underlineString;
@end

/** 一个emoji与其对应的cheatCodes数组 */
@interface AMKEmoji : NSObject
@property(nonatomic, strong) NSString *unicode;                                 //!< unicode字符串
@property(nonatomic, strong) NSMutableArray<NSString *> *cheatCodesArray;       //!< cheatCodes数组

/** 批量添加cheatCodes，addedCheatCodesArray为新增cheatCodes，若有新增则返回YES，否则返回NO */
- (BOOL)addCheatCodesArrayWithArray:(NSArray *)array addedCheatCodesArray:(NSArray **)addedCheatCodesArray;

@end



/** 一个emoji分类 */
@interface AMKEmojiCategory : NSObject
@property(nonatomic, strong) NSString *name;                                    //!< 该分类的名称
@property(nonatomic, strong) NSMutableArray<AMKEmoji *> *emojis;                //!< 该分类下的emoji数组

/** 获取指定unicode的emoji，根据参数决定是否不存在时自动添加 */
- (AMKEmoji *)emojiWithUnicode:(NSString *)unicode automaticallyAdd:(BOOL)automaticallyAdd;

@end



/** emoji表情管理 */
@interface AMKEmojiManager : NSObject
@property(nonatomic, strong) NSMutableArray<AMKEmojiCategory *> *categories;    //!< 分类数组

/** 单例 */
+ (instancetype)sharedManager;

/** 配置文件名称 */
+ (NSString *)filenameForPlist;

/** 配置文件在沙盒中的路径 */
+ (NSString *)sandboxPathForPlist;

/** 配置文件在bundle中的路径 */
+ (NSString *)bundlePathForPlist;

/** 沙盒中配置文件的路径 */
+ (NSString *)pathForPlist;

- (instancetype)initWithContentsOfFile:(NSString *)path;

/** 获取指定名称的分类，根据参数决定是否不存在时自动添加 */
- (AMKEmojiCategory *)categoryWithName:(NSString *)name automaticallyAdd:(BOOL)automaticallyAdd;

/** 以指定categoryName、unicode、cheatCodesArray 新加一个emoji配置，若添加成功则返回YES，否则返回NO（如已存在） */
- (AMKEmoji *)addEmojiWithCategoryName:(NSString *)categoryName unicode:(NSString *)unicode cheatCodesArray:(NSArray *)cheatCodesArray addedCheatCodesArray:(NSArray **)addedCheatCodesArray;

/** 找到unicode的emoji后添加cheatCodesArray，若没找到则新增默认分类为categoryName后新加一个emoji配置，，若添加成功则返回YES，否则返回NO（如已存在） */
- (AMKEmoji *)addEmojiWithUnicode:(NSString *)unicode cheatCodesArray:(NSArray *)cheatCodesArray defaultCategoryName:(NSString **)defaultCategoryName addedCheatCodesArray:(NSArray **)addedCheatCodesArray;

/** 保存到指定文件(path为空则保存至sandboxPathForPlist) */
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end
