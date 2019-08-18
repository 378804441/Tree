//
//  DWComparatorProtocol.h
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/8.
//  Copyright © 2019 丁巍. All rights reserved.
//

//  比较器 协议层

@protocol DWComparatorProtocol <NSObject>
@optional

/** 自定义比对方法 */
- (NSInteger)comparableWithE1:(id)e1 e2:(id)e2;

@end
