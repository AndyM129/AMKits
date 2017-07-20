//
//  NSObject+AMKDeallocBlock.m
//  Pods
//
//  Created by Andy on 2017/7/19.
//
//

#import "NSObject+AMKDeallocBlock.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (AMKDeallocBlock)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        void (^__method_swizzling)(SEL, SEL) = ^(SEL sel, SEL _sel) {
            Method  method = class_getInstanceMethod(self, sel);
            Method _method = class_getInstanceMethod(self, _sel);
            method_exchangeImplementations(method, _method);
        };
        //  避免因为手动调用该方法引发被拒的可能
        NSString *selectorName = [NSString stringWithFormat:@"%@%@%@", @"de", @"al", @"loc"];
        NSString *newSelectorName = [NSString stringWithFormat:@"%@%@%@%@%@", @"AMKDea", @"llocB", @"lock", @"_dea", @"lloc"];
        __method_swizzling(NSSelectorFromString(selectorName), NSSelectorFromString(newSelectorName));
    });
}

- (void)AMKDeallocBlock_dealloc {
    NSMutableDictionary<AMKDeallocBlockKey *, AMKDeallocBlock> *deallocBlocks = objc_getAssociatedObject(self, @selector(amk_deallocBlocks));
    for (AMKDeallocBlockKey *deallocBlockKey in deallocBlocks) {
        AMKDeallocBlock deallocBlock = [self.amk_deallocBlocks objectForKey:deallocBlockKey];
        //NSLog(@"开始执行AMKDeallocBlock：%@", deallocBlockKey);
        deallocBlock();
        //NSLog(@"结束执行AMKDeallocBlock：%@", deallocBlockKey);
    }
    ((void(*)(id, SEL))objc_msgSend)(self, @selector(AMKDeallocBlock_dealloc));
}

- (NSMutableDictionary<AMKDeallocBlockKey *, AMKDeallocBlock> *)amk_deallocBlocks {
    NSMutableDictionary<AMKDeallocBlockKey *, AMKDeallocBlock> *deallocBlocks = objc_getAssociatedObject(self, @selector(amk_deallocBlocks));
    if (!deallocBlocks) {
        deallocBlocks = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(amk_deallocBlocks), deallocBlocks, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return deallocBlocks;
}

- (void)amk_addDeallocBlock:(AMKDeallocBlock)deallocBlock forKey:(AMKDeallocBlockKey *)deallocBlockKey {
    [self.amk_deallocBlocks setObject:deallocBlock forKey:deallocBlockKey];
}

- (void)amk_removeDeallocBlockForKey:(AMKDeallocBlockKey *)deallocBlockKey {
    [self.amk_deallocBlocks removeObjectForKey:deallocBlockKey];
}

@end
