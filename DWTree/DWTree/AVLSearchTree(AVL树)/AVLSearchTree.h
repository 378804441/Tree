//
//  AVLSearchTree.h
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/17.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import "DWSearchTree.h"
#import "TreeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface AVLSearchTree : DWSearchTree


@end



#pragma mark - AVL节点

@interface AVLNode : TreeNode

/** 节点高度 */
@property (nonatomic, assign) NSInteger height;


/** 获取该节点平衡因子 */
- (NSInteger)balanceFactor;

/** 更新节点高度 (节点高度 = 左,右 节点最高的 + 1) */
- (void)updateHeight;

/** 获取该节点 左右节点中 高度最高的节点 (如果相同，返回同方向的节点) */
- (AVLNode *)tallerChild;

@end

NS_ASSUME_NONNULL_END
