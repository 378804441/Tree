//
//  TreeNode.m
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/13.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "TreeNode.h"

#define IsNull(obj)   (obj == nil || [obj isEqual:[NSNull null]])

@implementation TreeNode


/** 初始化 */
- (instancetype)initNodeWithParentNode:(TreeNode *__nullable)parentNode  element:(id __nullable)element{
    self = [super init];
    if (self) {
        self.parentNode = parentNode;
        self.element    = element;
    }
    return self;
}


/** 检测节点的度个数 */
- (NSInteger)chackingNodeDegree{
    
    if (self.leftNode != nil && self.rightNode != nil) {
        return 2;
        
    }else if(self.leftNode == nil && self.rightNode == nil){
        return 0;
        
    }else{
        return 1;
    }
}


/** 检查是否是叶子节点 */
- (BOOL)isLeaf{
    if ([self chackingNodeDegree] == 0) {
        return YES;
    }
    return NO;
}



#pragma mark - 获取 左右节点 / 兄弟节点 / 叔父节点 / 祖父节点 等等 节点方法

/** 判断该节点是在父节点的 右子树 */
- (BOOL)isLeftChild{
    return !IsNull(self.parentNode) && self == self.parentNode.leftNode;
}


/** 判断该节点是在父节点的 左子树 */
- (BOOL)isRightChild{
    return !IsNull(self.parentNode) && self == self.parentNode.rightNode;
}


/** 获取兄弟节点 */
- (TreeNode *)getSiblingNode{
    TreeNode *sibling = nil;
    if ([self isLeftChild]) {
        sibling = self.parentNode.rightNode;
    }
    
    if ([self isRightChild]){
        sibling = self.parentNode.leftNode;
    }
    return sibling;
}


/** 获取叔父节点 */
- (TreeNode *)getUncleNode{
    return [self.parentNode getSiblingNode];
}


@end

