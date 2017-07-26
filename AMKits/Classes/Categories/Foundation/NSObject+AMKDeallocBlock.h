//
//  NSObject+AMKDeallocBlock.h
//  Pods
//
//  Created by Andy on 2017/7/19.
//
//

#import <Foundation/Foundation.h>

/** AMKDeallocBlock的key */
typedef NSString AMKDeallocBlockKey;

/** AMKDeallocBlock */
typedef void(^AMKDeallocBlock)(id object);

/** 以默认格式生成当前的 AMKDeallocBlockKey */
#define AMKDeallocBlockDefaultKey() [NSString stringWithFormat:@"%@(%d) %s Line%d", [NSDate new], arc4random()%900+100, __PRETTY_FUNCTION__, __LINE__]


/** NSObject扩展 */
@interface NSObject (AMKDeallocBlock)

/** 在执行dealloc时遍历执行该字典中的所有block（可根据key来获取、移除指定block对象；务必注意同Key会相互覆盖value的情况！！） */
@property(nonatomic, readonly) NSMutableDictionary<AMKDeallocBlockKey *, AMKDeallocBlock> *amk_deallocBlocks;

/** 添加一个在执行dealloc时执行的block（务必注意同Key会相互覆盖value的情况！！） */
- (void)amk_addDeallocBlock:(AMKDeallocBlock)deallocBlock forKey:(AMKDeallocBlockKey *)deallocBlockKey;

/** 移除一个指定key的deallocBlock */
- (void)amk_removeDeallocBlockForKey:(AMKDeallocBlockKey *)deallocBlockKey;

@end

