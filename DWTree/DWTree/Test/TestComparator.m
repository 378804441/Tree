//
//  TestComparator.m
//  DWTree
//
//  Created by 丁巍 on 2019/8/28.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "TestComparator.h"

@implementation TestComparator

/**
 负数, 当前数小于传进来的数
 正数, 当前数大于传来的数
 0,   值相同
 */
- (NSInteger)comparableWithObjc1:(NSNumber *)objc1 objc2:(NSNumber *)objc2{
    NSAssert([objc1 isKindOfClass:[NSNumber class]] && [objc2 isKindOfClass:[NSNumber class]], @"该比较器俩个比较对象都需要是 NSNumber 类型");
    return [objc1 integerValue] - [objc2 integerValue];
}

@end
