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
- (NSInteger)comparableWithObjc1:(id)objc1 objc2:(id)objc2;

@end
