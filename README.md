# AMKits

[![Platform](https://img.shields.io/cocoapods/p/AMKits.svg?style=flat)](http://cocoapods.org/pods/AMKits)
[![Language](https://img.shields.io/badge/Language-%20Objective%20C%20-blue.svg)]()
[![Support](https://img.shields.io/badge/support-iOS%208%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)
[![Version](https://img.shields.io/cocoapods/v/AMKits.svg?style=flat)](http://cocoapods.org/pods/AMKits)
[![License](https://img.shields.io/cocoapods/l/AMKits.svg?style=flat)](http://cocoapods.org/pods/AMKits)
[![Weibo](https://img.shields.io/badge/Sina微博-@Developer_Andy-orange.svg?style=flat)](http://weibo.com/u/5271489088)
[![GitHub stars](https://img.shields.io/github/stars/AndyM129/AMKits.svg)](https://github.com/AndyM129/AMKits/stargazers)
[![Download](https://img.shields.io/cocoapods/dt/AMKits.svg)](https://github.com/AndyM129/AMKits/archive/master.zip)


## 0x1. Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.



## 0x2.Requirements

- iOS8 +



## 0x3. Installation

AMKits is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```Linux
pod "AMKits"
```



## 0x4. Update History

### 2017-08-29：发布`2.0.1`版本

#### 1. 优化`AMKEmojiHelper`库对Emoji表情的处理



### 2017-08-05：发布`2.0.0`版本

#### 1. 重新整理了pod组件的目录结构

#### 2. 新增`AMKEmojiHelper`库

##### 1) 添加 `AMKEmojiMapping.json`

基于网上最全的Emoji配置《[Unicode® Emoji Charts](http://www.unicode.org/emoji/charts/index.html)》，结构化抓取后生成的配置文件，包括如下内容：

- Emoji表情的Unicode、ShortName、CheatCodes、Emoji肤色类型 等属性的查看
- 对各平台的支持情况，如Apple、Google、Twitter、One、FB、FBM、Samsung、Windows、Gmail、SB、DCM、KDDI等
- 总共收录2600+Emoji表情，并以2级分组归类

##### 2) 添加 `AMKEmojiManager.h`

- 实现对`AMKEmojiMapping.json`文件的加载
- 支持对`AMKEmojiMapping.json`文件的修改
- 实现对`AMKEmojiMapping.json`配置文件的联网更新，并支持基于《[emoji-ordering-rules](http://www.unicode.org/emoji/charts/emoji-ordering-rules.txt)》对全量Emoji进行排序（因Emoji的显示及查找、替换等处理是有优先级的）

##### 3) 添加 `NSArray+AMKEmojiHelper.h` 

```objective-c
/** 获取所有EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_emojis;

/** 获取所有已根据编号升序排序EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojisAscendingByNo;

/** 获取所有已根据编号降序排序EmojiModel的数组 */
+ (NSArray<AMKBaseEmoji *> *)amk_sortedEmojisDescendingByNo;
```

##### 4) 添加 `NSDictionary+AMKEmojiHelper.h`

```objective-c
/** Emoji 从 Unicode 到 CheatCode 的映射表 */
+ (NSDictionary *)amk_emojiMappingOfUnicodeToCheatCodes;

/** Emoji 从 CheatCode 到 Unicode 的映射表 */
+ (NSDictionary *)amk_emojiMappingOfCheatCodesToUnicode;
```

##### 5) 添加 `NSString+AMKEmojiHelper.h` 

```objective-c
/** 是否包含 Unicode-emoji */
- (BOOL)amk_containsEmojiInUnicode;

/** 是否包含 CheatCodes-emoji */
- (BOOL)amk_containsEmojiInCheatCodes;

/** 例如：将"This is a smiley face \U0001F604" 替换为 "This is a smiley face :smiley:" */
- (NSString *)amk_stringByReplacingEmojiInUnicodeWithCheatCodes;

/** 例如：将"This is a smiley face :smiley:" 替换为 "This is a smiley face \U0001F604" */
- (NSString *)amk_stringByReplacingEmojiInCheatCodesWithUnicode;

/** 将 Unicode-emoji 替换为指定字符串 */
- (NSString *)amk_stringByReplacingEmojiInUnicodeWithString:(NSString *(^)(NSString *unicode, NSString *cheatCodes, BOOL *stop))block;

/** 将 CheatCodes-emoji 替换为指定字符串 */
- (NSString *)amk_stringByReplacingEmojiInCheatCodesWithString:(NSString *(^)(NSString *cheatCodes, NSString *unicode, BOOL *stop))block;
```



### 2017-07-20

#### 1. 优化 NSObject+AMKDeallocBlock.h，以支持对当前object的处理



### 2017-07-19：发布`0.1.0`版本

#### 1. 搭建项目框架

#### 2. 发布`0.1.0`版本

##### 1) 添加 NSObject+AMKDeallocBlock.h

可随意给对象添加随意多个在执行`dealloc`时执行的block，可用来释放对象、移除通知

##### 2) 添加 NSObject+AMKLocaleDescription.h

重写相关方法，使得`NSArray`、`NSDictionary`、`NSSet`等集合类的实例在控制台输出时，能够正常的打印中文，而不是Unicode码

##### 3) 添加 UIViewController+AMKLifeCircleBlock.h

为外部提供的`viewDidLoad`、`viewWillAppear:`、`viewDidAppear:`、`viewWillDisappear:`、`viewDidDisappear:`等生命周期的回调

##### 4) 添加 UIViewController+AMKViewControllerSwitch.h

添加`UIViewController`切换相关扩展

##### 5) 添加 UIView+AMKExtendTouchRect.h

支持对`UIView`手势交互范围的调整



## 0x5. Author

如果你有好的 idea 或 疑问，请随时提 issue 或 request。

如果你在开发过程中遇到什么问题，或对iOS开发有着自己独到的见解，都可以关注或私信我的微博 [`@Developer_Andy`](http://weibo.com/u/5271489088)、[`简书`](http://www.jianshu.com/users/28d89b68984b/latest_articles)

“Stay hungry. Stay foolish.”

与君共勉~



## 0x6. One More Thing

如果你想了解开源框架的创建方法，具体可以参看我的简书[《创建自己的开源框架到CocoaPods》](http://www.jianshu.com/p/f39a22252e5f)



## 0x7. License

AMKits is available under the MIT license. See the LICENSE file for more info.
