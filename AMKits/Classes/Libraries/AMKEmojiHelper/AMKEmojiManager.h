//
//  AMKEmojiManager.h
//  AMKits
//
//  Created by Andy on 2017/8/1.
//  Copyright © 2017年 AndyM129. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AMKEmojiManager;
static BOOL kAMKEmojiManagerDebugEnable = NO;      //!< debug开关

/** 各平台的支持情况 */
typedef NS_OPTIONS(NSInteger, AMKEmojiSupportVendor) {
    AMKEmojiSupportVendorNone = 0,                  //!< 没有平台支持（默认）
    AMKEmojiSupportVendorApple = 1 << 0,            //!< Apple平台支持
    AMKEmojiSupportVendorGoogle = 1 << 1,           //!< Google平台支持
    AMKEmojiSupportVendorTwitter = 1 << 2,          //!< Twitter平台支持
    AMKEmojiSupportVendorOne = 1 << 3,              //!< One平台支持
    AMKEmojiSupportVendorFacebook = 1 << 4,         //!< FB平台支持
    AMKEmojiSupportVendorFacebookMobile = 1 << 5,   //!< FacebookMobile平台支持
    AMKEmojiSupportVendorSamsung = 1 << 6,          //!< Samsung平台支持
    AMKEmojiSupportVendorWindows = 1 << 7,          //!< Windows平台支持
    AMKEmojiSupportVendorGmail = 1 << 8,            //!< Gmail平台支持
    AMKEmojiSupportVendorSB = 1 << 9,               //!< SB平台支持
    AMKEmojiSupportVendorDCM = 1 << 10,             //!< DCM平台支持
    AMKEmojiSupportVendorKDDI = 1 << 11,            //!< KDDI平台支持
};

/** emoji肤色类型 */
typedef NS_ENUM(NSInteger, AMKSkinTonesEmojiType) {
    AMKSkinTonesEmojiTypeNormal = 0,                //!< 普通（默认）
    AMKSkinTonesEmojiTypeLight = 1,                 //!< 白色
    AMKSkinTonesEmojiTypeMediumLight = 2,           //!< 中白色
    AMKSkinTonesEmojiTypeMedium = 3,                //!< 中色
    AMKSkinTonesEmojiTypeMediumDark = 4,            //!< 中深色
    AMKSkinTonesEmojiTypeDark = 5,                  //!< 深色
};

FOUNDATION_EXPORT NSString * const AMKEmojiMappingFilename;                     //!< Emoji映射文件名称
FOUNDATION_EXPORT NSString * const AMKUnicodeEmojiChartsUrl;                    //!< Unicode® Emoji Charts 网址
FOUNDATION_EXPORT NSString * const AMKUnicodeEmojiOrderingRulesUrl;             //!< emoji-ordering-rules.txt 网址
FOUNDATION_EXPORT NSString * const AMKEmojiManagerErrorDomain;                  //!< 错误信息Domain
FOUNDATION_EXPORT NSString * const AMKEmojiManagerErrorFilePathUserInfoKey;     //!< 错误信息UserInfoKey：文件路径


/** AMKEmojiManager 错误信息 */
typedef NS_OPTIONS(NSInteger, AMKEmojiManagerErrorOptions) {
    AMKEmojiManagerErrorOptionsNone = 0,                    //! 没有错误
    AMKEmojiManagerErrorOptionsDataEmpty = 1 << 0,          //!< 数据为空
    AMKEmojiManagerErrorOptionsFileNotExists = 1 << 1,      //!< 文件不存在
    AMKEmojiManagerErrorOptionsEmojiTotalsNotFound = 1 << 2,//!< 未找到Emoji表情总量
    AMKEmojiManagerErrorOptionsEmojiListNotFound = 1 << 3,  //!< 未找到Emoji列表
};

/** AMKEmojiManager 更新Emoji进度回调 */
typedef void(^AMKEmojiManagerReloadDataProgressBlock)(NSInteger totals, NSInteger currentCount);

/** AMKEmojiManager 更新Emoji结束回调 */
typedef void(^AMKEmojiManagerReloadDataCompletionBlock)(AMKEmojiManager *emojiManager, NSError *error);




/** emoji模型基类 */
@interface AMKBaseEmoji : NSObject
@property(nonatomic, copy) NSString *unicode;                       //!< emoji表情的unicode
@property(nonatomic, copy) NSString *shortName;                     //!< 短名称
@property(nonatomic, assign) AMKEmojiSupportVendor supportVendor;   //!< 支持平台
@property(nonatomic, strong) NSMutableArray<NSString *> *cheatCodes;//!< 替换码数组
@property(nonatomic, assign) CGFloat no;                            //!< 编号

/** 根据编号（no）排序 */
- (NSComparisonResult)compareWithNo:(AMKBaseEmoji *)emoji;

/** 获取该emoji的肤色信息 */
+ (AMKSkinTonesEmojiType)skinTonesEmojiTypeWithEmojiInUnicode:(NSString *)unicode;
@end



/** 带有肤色的Emoji表情 */
@interface AMKSkinTonesEmoji : AMKBaseEmoji
@property(nonatomic, assign) AMKSkinTonesEmojiType skinTonesEmojiType;  //!< 肤色类型
@end



/** Emoji表情 */
@interface AMKEmoji : AMKBaseEmoji
@property(nonatomic, strong) NSMutableArray<AMKSkinTonesEmoji *> *skinTonesEmojis;  //!< 带有肤色的Emoji
@end



/** Emoji子分组 */
@interface AMKEmojiSubGroup : NSObject
@property(nonatomic, copy) NSString *name;                          //!< 子分组名称
@property(nonatomic, strong) NSMutableArray<AMKEmoji *> *emojis;    //!< 子分组所包含的Emoji
@end



/** Emoji分组 */
@interface AMKEmojiGroup : NSObject
@property(nonatomic, copy) NSString *name;                                  //!< 名称
@property(nonatomic, copy) NSString *icon;                                  //!< 图标
@property(nonatomic, strong) NSMutableArray<AMKEmojiSubGroup *> *subGroups; //!< 当前分组所包含的子分组
@end



/** Emoji管理类，参照：http://www.unicode.org/emoji/charts/full-emoji-list.html */
@interface AMKEmojiManager : NSObject
@property(nonatomic, copy) NSString *name;                              //!< 配置文件名称
@property(nonatomic, copy) NSString *version;                           //!< 版本号
@property(nonatomic, copy) NSString *updateTime;                        //!< 更新时间
@property(nonatomic, assign) NSInteger totals;                          //!< Emoji总个数
@property(nonatomic, strong) NSMutableArray<AMKEmojiGroup *> *groups;   //!< 分组

/** 单例 */
+ (instancetype)defaultManager;

/** 下载并解析Unicode® Emoji Charts <http://www.unicode.org/emoji/charts/full-emoji-list.html> */
- (void)reloadDataWithContentsOfUnicodeEmojiChartsProgress:(AMKEmojiManagerReloadDataProgressBlock)progressBlock
                                                completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock;

/** 加载基于Unicode® Emoji Charts <http://www.unicode.org/emoji/charts/full-emoji-list.html> 生成的json文件 */
- (void)reloadDataWithContentsOfFile:(NSString *)path completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock;

/** 加载并基于 Emoji Ordering Rules <http://www.unicode.org/emoji/charts/emoji-ordering-rules.txt> 将Emoji排序 */
- (void)reloadOrderWithProgress:(AMKEmojiManagerReloadDataProgressBlock)progressBlock
                 completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock;;

/** 保存配置文件到指定文件 */
- (void)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile completion:(AMKEmojiManagerReloadDataCompletionBlock)completionBlock;

@end
