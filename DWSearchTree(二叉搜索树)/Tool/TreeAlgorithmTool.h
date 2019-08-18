//
//  TreeAlgorithmTool.h
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/13.
//  Copyright © 2019 丁巍. All rights reserved.
//
//  二叉树的算法 (前中后序遍历, 层序遍历 等)

#import <Foundation/Foundation.h>
#import "TreeNode.h"


NS_ASSUME_NONNULL_BEGIN

/** 搜索节点 前驱/后继 类型 */
typedef NS_ENUM(NSInteger, TreeBeforeAfterType){
    TreePredecessorType_before = 0,     // 前驱
    TreePredecessorType_after           // 后继
};


@interface TreeAlgorithmTool : NSObject

#pragma mark - 遍历获取

/** 前序遍历 */
+ (void)preorderTraversalWithNode:(TreeNode *)node;

/** 中序遍历 */
+ (void)inorderTraversalWithNode:(TreeNode *)node;

/** 后序遍历 */
+ (void)postorderTraversalWithNode:(TreeNode *)node;

/** 层序遍历 */
+ (void)levelOrderTraversalWithNode:(TreeNode *)node VisitorBlock:(void (^)(id _Nonnull visitorData))visitorBlock;


#pragma mark - 获取树高度

/** 获取二叉树的高度 (递归)*/
+ (NSInteger)treeHeightWithNode:(TreeNode *)node;

/** 获取二叉树的高度 (迭代 - 层序遍历)*/
+ (NSInteger)treeHeight2WithNode:(TreeNode *)node;


#pragma mark - 获取 前驱 / 后继  (中序遍历的 节点的 前一个/后一个 节点)

/** 获取输入节点的前驱节点 */
+ (TreeNode *)predecessorWithNode:(TreeNode *)node type:(TreeBeforeAfterType)type;


@end

NS_ASSUME_NONNULL_END
