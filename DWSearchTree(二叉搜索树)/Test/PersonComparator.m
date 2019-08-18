//
//  PersonComparator.m
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/8.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "PersonComparator.h"
#import "Person.h"

@implementation PersonComparator

/**
 负数, 当前年龄小于传进来的年龄
 正数, 当前年龄大于传来的年龄
 0,   俩个年龄相同
 */
- (NSInteger)comparableWithE1:(Person *)e1 e2:(Person *)e2{
    return [e1 getAge] - [e2 getAge];
}

@end
