//
//  TreeNode.h
//  DWSearchTree(二叉搜索树)
//
//  Created by 丁巍 on 2019/8/13.
//  Copyright © 2019 丁巍. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TreeNode : NSObject

/** 左节点 */
@property (nonatomic, strong) TreeNode * __nullable leftNode;

/** 右节点 */
@property (nonatomic, strong) TreeNode * __nullable rightNode;

/** 父节点 */
@property (nonatomic, strong) TreeNode * __nullable parentNode;

/** 存储内容 */
@property (nonatomic, strong) id         __nullable element;

/** 初始化 */
- (instancetype)initNodeWithParentNode:(TreeNode *__nullable)parentNode  element:(id __nullable)element;

/** 检测节点的度个数 */
- (NSInteger)chackingNodeDegree;

/** 判断该节点是在父节点的 右子树 */
- (BOOL)isLeftChild;

/** 判断该节点是在父节点的 左子树 */
- (BOOL)isRightChild;

@end

NS_ASSUME_NONNULL_END
