//
//  RedBlackTree.h
//  DWTree
//
//  Created by 丁巍 on 2019/8/25.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWSearchTree.h"
#import "TreeNode.h"


NS_ASSUME_NONNULL_BEGIN

@interface RedBlackTree : DWSearchTree

@end





#pragma mark - AVL节点

@interface RBNode : TreeNode

/**
 * 节点颜色
 * red   : YES
 * black : NO
 */
@property (nonatomic, assign) BOOL  color;


@end

NS_ASSUME_NONNULL_END
