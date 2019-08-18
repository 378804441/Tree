//
//  DWSearchTree.h
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/6.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TreeNode.h"
#import "DWComparatorProtocol.h"
#import "MJBinaryTreeInfo.h"


NS_ASSUME_NONNULL_BEGIN

@interface DWSearchTree : NSObject<MJBinaryTreeInfo>

/**
 * 初始化方法
 * comparator : 自定义比较器
 */
- (instancetype)initTreeWithComparator:(id <DWComparatorProtocol> __nullable)comparator;

/** 添加元素 */
- (void)addWithElement:(id)element;


/** 层序遍历 */
- (void)levelOrderTraversalWithVisitorBlock:(void (^)(id _Nonnull visitorData))visitorBlock;

/** 中序遍历 */
- (void)inorderTraversal;


/** 删除元素 */
- (void)removeWithElement:(id)element;

@end


NS_ASSUME_NONNULL_END
