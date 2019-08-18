//
//  Person.m
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/8.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "Person.h"


@interface Person()

@property (nonatomic, assign) NSInteger age;

@end



@implementation Person

- (instancetype)initPersonWithAge:(NSInteger)age{
    self = [super init];
    if (self) {
        self.age = age;
    }
    return self;
}

/** 负数, 当前年龄小于传进来的年龄
    正数, 当前年龄大于传来的年龄
    0,   俩个年龄相同
 */
- (int)comparableTo:(Person *)element{
    return (int)self.age - element.age;
}


- (NSInteger)getAge{
    return self.age;
}

@end
