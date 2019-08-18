//
//  TreeAlgorithmTool.m
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/13.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "TreeAlgorithmTool.h"
#import "Person.h"
#import "DWQueue.h"         // 层序遍历


#define IsNull(obj)   (obj == nil || [obj isEqual:[NSNull null]])
#define IsEmpty(str)  (str == nil || ![str respondsToSelector:@selector(isEqualToString:)] || [str isEqualToString:@""])


@implementation TreeAlgorithmTool


#pragma mark - 前序递归

/** 前序遍历 */
+ (void)preorderTraversalWithNode:(TreeNode *)node{
    if (node == nil) return;
    
    NSLog(@"~~~~   %@", @([((Person *)node.element) getAge]));
    
    [self preorderTraversalWithNode:node.leftNode];
    [self preorderTraversalWithNode:node.rightNode];
}



#pragma mark - 中序遍历

/** 中序遍历 */
static NSString *str = @"";
+ (void)inorderTraversalWithNode:(TreeNode *)node{
    if (node == nil) {
        return;
    }
    
    [self inorderTraversalWithNode:node.leftNode];
    str = [NSString stringWithFormat:@"%@ %@", str, @([((Person *)node.element) getAge])];
    NSLog(@"~~~~   %@", str);
    [self inorderTraversalWithNode:node.rightNode];
}


#pragma mark - 后序遍历

/** 后序遍历 */
+ (void)postorderTraversalWithNode:(TreeNode *)node{
    if (node == nil) return;
    
    [self postorderTraversalWithNode:node.leftNode];
    [self postorderTraversalWithNode:node.rightNode];
    NSLog(@"~~~~   %@", @([((Person *)node.element) getAge]));
}



#pragma mark - 层序遍历  (重要 ***)

/** 层序遍历 */
+ (void)levelOrderTraversalWithNode:(TreeNode *)node VisitorBlock:(void (^)(id _Nonnull visitorData))visitorBlock{
    if (node == nil) return;
    
    DWQueue *queue = [[DWQueue alloc] init];
    [queue enQueue:node];
    
    
    // 队列不为空 一直循环取出头节点
    while (![queue isEmpty]) {
        
        TreeNode *node = [queue deQueue];
        
        if (visitorBlock) visitorBlock(node.element);
        
        if (!IsNull(node.leftNode)) {
            [queue enQueue:node.leftNode];
        }
        
        if (!IsNull(node.rightNode)) {
            [queue enQueue:node.rightNode];
        }
        
    }
}



#pragma mark - 获取树高度

/** 获取二叉树的高度 (递归)*/
+ (NSInteger)treeHeightWithNode:(TreeNode *)node{
    return [self __heightWithNode:node];
}


/** 获取二叉树的高度 (迭代 - 层序遍历)*/
+ (NSInteger)treeHeight2WithNode:(TreeNode *)node{
    if (node == nil) return 0;
    
    DWQueue *queue = [[DWQueue alloc] init];
    [queue enQueue:node];
    
    NSInteger height    = 0;
    NSInteger levelSize = 1;    // 存储着每一行的元素数量
    
    // 队列不为空 一直循环取出头节点
    while (![queue isEmpty]) {
        
        TreeNode *node = [queue deQueue];
        
        // 从队列里面 弹出去一个节点, 就要将当前行数的元素个数 减掉一个
        levelSize--;
        
        if (!IsNull(node.leftNode)) {
            [queue enQueue:node.leftNode];
        }
        
        if (!IsNull(node.rightNode)) {
            [queue enQueue:node.rightNode];
        }
        
        // 即将要访问下一层
        if (levelSize == 0) {
            // 一层遍历完了，这时levelSize 其实就是 当前队列里面的元素个数
            levelSize = [queue getSize];
            height++;
        }
        
    }
    
    return height;
}


/** 获取输入节点的前驱节点 */
+ (TreeNode *)predecessorWithNode:(TreeNode *)node type:(TreeBeforeAfterType)type{
    if (IsNull(node)) return nil;
    
    TreeNode *pNode = node.leftNode;
    if (type == TreePredecessorType_after) {
        pNode = node.rightNode;
    }
    
    // 节点有左节点, 从节点的左节点 开始 一直往右找，直到 右节点为null 循环结束为止
    if (!IsNull(pNode)) {
        if (type == TreePredecessorType_before) {
            while (pNode.rightNode) {
                pNode = pNode.rightNode;
            }
            return pNode;
        }
        
        if (type == TreePredecessorType_after) {
            while (pNode.leftNode) {
                pNode = pNode.leftNode;
            }
            return pNode;
        }
    }
    
    // 节点没有左节点, 但是有父节点, 开始循环向上寻找, 直到 找到的父节点在祖父节点的右节点上为止
    
    if (type == TreePredecessorType_before) {
        while (!IsNull(node.parentNode) && node == node.parentNode.leftNode ) {
            node = node.parentNode;
        }
    }
    
    if (type == TreePredecessorType_after) {
        while (!IsNull(node.parentNode) && node == node.parentNode.rightNode ) {
            node = node.parentNode;
        }
    }
    
    
    // 循环能到这里表示
    /** 1. node.parentNode == null      // 父节点为null, 没有前驱
        2. node == node.parantNode.left      // 该节点在父节点的右节点, 有前驱
        所以统一返回 node.parentNode 即可
     */
    
    return node.parentNode;
}



#pragma mark - private method

/** 获取某一个节点的高度 */
+ (NSInteger)__heightWithNode:(TreeNode *)node{
    if (node == nil) return 0;
    return 1 + MAX([self __heightWithNode:node.leftNode], [self __heightWithNode:node.rightNode]);
}




@end
